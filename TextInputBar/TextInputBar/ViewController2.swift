//
//  ViewController2.swift
//  TextInputBar
//
//  Created by Yaroslav Bondar on 12.04.2023.
//

import UIKit

class ViewController2: UIViewController {
    
    private let textInputBar = TextInputBar.initFromNib()
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var bottomTextInputBarConstraint = textInputBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        //        if #available(iOS 15.0, *) {
        //            UITableView.appearance().sectionHeaderTopPadding = 0
        //        }
        
        
        view.addSubview(textInputBar)
        
        textInputBar.translatesAutoresizingMaskIntoConstraints = false
        textInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomTextInputBarConstraint.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGesture)
        
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        textInputBar.layoutIfNeeded()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: textInputBar.bounds.height, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 66.0
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: "UserChatCell", bundle: nil), forCellReuseIdentifier: "UserChatCell")
        tableView.register(UINib(nibName: "AssistantChatCell", bundle: nil), forCellReuseIdentifier: "AssistantChatCell")
        
        textInputBar.onSizeChange = { [weak self] in
            guard let self = self else {
                return
            }
            
            UIView.animate(withDuration: 0.25) {
                let height: CGFloat = -self.bottomTextInputBarConstraint.constant + self.textInputBar.bounds.height - (UIDevice.hasNotch ? 34 : 0)
                let insets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                self.tableView.contentInset = insets
                self.tableView.scrollIndicatorInsets = insets
                
                let isReachingEnd = self.tableView.contentOffset.y >= 0 && self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.frame.size.height)
                if isReachingEnd {
                    self.tableView.scrollToRow(at: IndexPath(row: 29 , section: 0), at: .bottom, animated: false)
                }

            }
        }
    }
    
    @objc private func onTap() {
        textInputBar.textView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        
        let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = frame.height
        self.bottomTextInputBarConstraint.constant = -height
        
        func animations() {
            self.view.layoutIfNeeded()
            
            let insetHeight: CGFloat = height + self.textInputBar.bounds.height - (UIDevice.hasNotch ? 34 : 0)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: insetHeight, right: 0)
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
            
            
//
            let isReachingEnd = self.tableView.contentOffset.y >= 0 && self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.frame.size.height)
            if isReachingEnd {
                self.tableView.scrollToRow(at: IndexPath(row: 29 , section: 0), at: .bottom, animated: false)
            }
        }
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            animations()
            return
        }
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curveRawValue), animations: { ()->() in
            animations()
        }, completion: nil)
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: self.textInputBar.bounds.height, right: 0)
        
        func animations() {
            let height: CGFloat = 0//textInputBar.bounds.height +
            self.bottomTextInputBarConstraint.constant = -height
            self.view.layoutIfNeeded()
            
            
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        }
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            animations()
            return
        }
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curveRawValue), animations: { ()->() in
            animations()
        }, completion: nil)
    }
    
    
    @objc func keyboardFrameChanged(notification: NSNotification) {
            print("keyboardFrameChanged")
    }
    
}

extension ViewController2: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell", for: indexPath) as? UserChatCell else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.setup(with: "Row \(indexPath.row + 1). \(randomString(length: .random(in: 2...100)))")
        //cell.backgroundColor = .red
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Row \(indexPath.row + 1)"
//        //cell.backgroundColor = .red
//        return cell
        
        
    }
    
    
    
}

extension ViewController2: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        guard let cell = tableView.cellForRow(at: indexPath) else {
//            assertionFailure()
//            return nil
//        }
        
        let text = "Row \(indexPath.row + 1)"
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { action in
                UIPasteboard.general.string = text
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
                let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                self?.present(activityViewController, animated: true, completion: nil)
            }
            return UIMenu(title: "", children: [shareAction, copyAction])
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        targetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        targetedPreview(for: configuration)
    }
    
    private func targetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview?  {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) as? UserChatCell
        else {
            return nil
        }
        return UITargetedPreview(view: cell.textBackgroundView)
    }
    
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}



/*
 https://medium.com/ios-os-x-development/speech-recognition-with-swift-in-ios-10-50d5f4e59c48
 swift ui https://developer.apple.com/tutorials/app-dev-training/transcribing-speech-to-text
 https://heartbeat.comet.ml/speech-recognition-and-speech-synthesis-on-ios-with-swift-d1a63e469cd9
 */

/*
 TODO
 - check keyboard voice recognition errors
 - character limit + keyboard voice recognition
 - button change
 - add text, not replace all (if need)
 */
/*
 DONE
 - audio interupt and continue
 - caret scroll
 - fixed text change after stop
 - auto stop 5 sec
 */
import Speech
final class SpeachManager {
    
    static let shared = SpeachManager()
    private init() {}
    
    private let audioEngine = AVAudioEngine()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioSession = AVAudioSession.sharedInstance()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    private let autoStopTaskSecond: TimeInterval = 5
    
    private var isRecording = false
    
    var onTextChange: ((String) -> Void)?
    var onAutoStop: (() -> Void)?
    
    private var autoStopTask: DispatchWorkItem?
    
    private func tryRecordAndRecognizeSpeech() {
        assert(AVAudioSession.sharedInstance().recordPermission == .granted, "Speech recognition is not available. Check mic permission")
        
        do {
            //try audioSession.setCategory(.record, mode: .default, options: .duckOthers)
            /*
             fixed crash during user audio playing: `required condition is false: IsFormatSampleRateAndChannelCountValid` https://stackoverflow.com/a/61317322/5893286
             
             use `.duckOthers` to low volume for user audio
             */
            try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            assertionFailure(error.debugDescription)
            return
        }
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            assertionFailure(error.debugDescription + " There has been an audio engine error.")
            return
        }
        guard let speechRecognizer = speechRecognizer else {
            assertionFailure("Speech recognition is not supported for current locale.")
            return
        }
        guard speechRecognizer.isAvailable else {
            assertionFailure("Speech recognition is not currently available. Check back at a later time.")
            return
        }
        resetAutoStopTask()
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
            if let result = result {
                
//                let bestString = result.bestTranscription.formattedString
//                var lastString: String = ""
//                for segment in result.bestTranscription.segments {
//                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
//                    lastString = String(bestString[indexTo...])
//                }
//                self?.onTextChange?(bestString)
//                print("bestString \(bestString)")
//                print("lastString \(lastString)")
                
                /// called after recognitionTask stop and text can be changed
                if !result.isFinal {
                    self?.onTextChange?(result.bestTranscription.formattedString)
                    self?.resetAutoStopTask()
                }
                
            } else if let error = error as? NSError {
//                kAFAssistantErrorDomain
                /**
                 on autoStopTask `Domain=kAFAssistantErrorDomain Code=1110 "No speech detected" UserInfo={NSLocalizedDescription=No speech detected`
                 possible error 216 https://developer.apple.com/forums/thread/80993
                 */
                if !(error.domain == "kAFAssistantErrorDomain" && error.code == 1110) {
                    print(error.debugDescription + "- speech recognition error.")
                    self?.stop()
                }
                
                
            } else {
                assertionFailure()
            }
            
        })
    }
    
    private func resetAutoStopTask() {
        print("- resetAutoStopTask")
        let autoStopTask = DispatchWorkItem { [weak self] in
            print("- autoStopTask")
            self?.stop()
            self?.onAutoStop?()
        }
        self.autoStopTask?.cancel()
        self.autoStopTask = autoStopTask
        DispatchQueue.main.asyncAfter(deadline: .now() + autoStopTaskSecond, execute: autoStopTask)
    }
    
    func start() {
        guard !isRecording else {
            assertionFailure()
            return
        }
        isRecording = true
        
        tryRecordAndRecognizeSpeech()
    }
    
    func stop() {
        guard isRecording else {
            assertionFailure()
            return
        }
        isRecording = false
        
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        autoStopTask?.cancel()
        autoStopTask = nil

        
        /// `.notifyOthersOnDeactivation` to continue users audio
        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    
    enum SpeechAuthorizationResult {
        case authorized
        case denied(DeniedType)
        
        enum DeniedType {
            case voiceRecord
            case speechRecognizer
        }
    }
    func requestSpeechAuthorization(handler: @escaping (SpeechAuthorizationResult) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                SFSpeechRecognizer.requestAuthorization { authStatus in
                    DispatchQueue.main.async {
                        let result: SpeechAuthorizationResult = (authStatus == .authorized) ? .authorized : .denied(.speechRecognizer)
                        handler(result)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    handler(.denied(.voiceRecord))
                }
            }
        }
        
        
    }
}

extension Error {
    var debugDescription: String {
        String(describing: self)
    }
}

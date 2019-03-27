//
//  ViewController.swift
//  DiskSpace
//
//  Created by Bondar Yaroslav on 3/20/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var sizeLabel1: UILabel!
    @IBOutlet private weak var sizeLabel2: UILabel!
    @IBOutlet private weak var sizeLabel3: UILabel!
    @IBOutlet private weak var sizeLabel4: UILabel!
    @IBOutlet private weak var sizeLabel5: UILabel!
    
    @IBOutlet private weak var titleLabel1: UILabel!
    @IBOutlet private weak var titleLabel2: UILabel!
    @IBOutlet private weak var titleLabel3: UILabel!
    @IBOutlet private weak var titleLabel4: UILabel!
    @IBOutlet private weak var titleLabel5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitles()
    }
    
    private func setTitles() {
        titleLabel1.text = "volumeAvailableCapacityKey"
        titleLabel2.text = "volumeAvailableCapacityForImportantUsageKey"
        titleLabel3.text = "volumeAvailableCapacityForOpportunisticUsageKey"
        titleLabel4.text = "volumeTotalCapacityKey"
        titleLabel5.text = "iOS 9/10"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSizes()
    }
    
    @IBAction private func onRefresh(_ sender: UIBarButtonItem) {
//        updateSizes()
        let vc = WebViewController(urlString: "https://www.turkcell.com.tr/tr/hakkimizda/genel-bakis/istiraklerimiz", title: nil)
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func onClear(_ sender: UIBarButtonItem) {
        clearCache()
        updateSizes()
    }
    
    @IBAction private func onCreateCash(_ sender: UIBarButtonItem) {
        createCash()
        updateSizes()
    }
    
    private func clearCache() {
        let fileManager = FileManager.default
        guard let documentsUrl =  fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            assertionFailure()
            return
        }
        let documentsPath = documentsUrl.path
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            print("--- all files in cache:\n\(fileNames)")
            
            for fileName in fileNames {
                /// System Error Code=513:
                /// "Snapshots" couldn’t be removed because you don’t have permission to access it.
                guard fileName != "Snapshots" else {
                    return
                }
                let filePathName = "\(documentsPath)/\(fileName)"
                try fileManager.removeItem(atPath: filePathName)
            }
            
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            print("--- all files in cache after deleting images:\n\(files)")
            
        } catch {
            assertionFailure("Could not clear temp folder: \(error)")
        }

        /// #2
        /// https://stackoverflow.com/a/50122279/5893286
//        let caches = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
//        let appId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
//        let path = String(format:"%@/%@/Cache.db-wal",caches, appId)
//        do {
//            try FileManager.default.removeItem(atPath: path)
//        } catch {
//            print("ERROR DESCRIPTION: \(error)")
//        }
        
    }
    
    private func createCash() {
        guard let temporaryDirectoryURL = try? FileManager.default.url(for: .cachesDirectory,
                                                                   in: .userDomainMask,
                                                                   appropriateFor: nil,
                                                                   create: false)
            else {
                assertionFailure()
                return
        }
        let fileName = ProcessInfo().globallyUniqueString
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(fileName)
        let data = Data(repeating: 1, count: 1024 * 1024 * 100)
        do {
            try data.write(to: temporaryFileURL, options: .atomicWrite)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        print("ready")
    }

    private func updateSizes() {
        /// volumeAvailableCapacityKey - доступное место, тоже самое что файловый менеджер отдаст.
        /// volumeAvailableCapacityForImportantUsageKey - всё свободное, с учётом возможности удаления кэша, временных файлов и т.д.
        /// В случае с volumeAvailableCapacityForImportantUsageKey нас не  пускает система в “защищенное” пространство
        // TODO: check vs .volumeAvailableCapacityKey, .volumeAvailableCapacityForOpportunisticUsageKey
        
//        let fileURL = URL(fileURLWithPath: Device.homeFolder)
//        let fileURL = URL(fileURLWithPath: "/")
        let fileURL = URL(fileURLWithPath: NSHomeDirectory())
        
        
        
        if #available(iOS 11.0, *) {

            let mb: Double = 1024
//            let mb: Double = 1000
            
//            let allVolumeStorageCapacity = VolumeStorageCapacityAny.shared.allVolumeStorageCapacity()
            
            let values1 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
            let size1 = Int64(values1?.volumeAvailableCapacity ?? 0)
            sizeLabel1.text = "\(size1)\n\(Double(size1)/mb/mb/mb)"
            
            
            /// not working with fileURL "URL(fileURLWithPath: "/")"
            let values2 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            let size2 = Int64(values2?.volumeAvailableCapacityForImportantUsage ?? 0)
            sizeLabel2.text = "\(size2)\n\(Double(size2)/mb/mb/mb)"
            
            /// not working with fileURL "URL(fileURLWithPath: "/")"
            let values3 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
            let size3 = Int64(values3?.volumeAvailableCapacityForOpportunisticUsage ?? 0)
            sizeLabel3.text = "\(size3)\n\(Double(size3)/mb/mb/mb)"
            
            let values4 = try? fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
            let size4 = Int64(values4?.volumeTotalCapacity ?? 0)
            sizeLabel4.text = "\(size4)\n\(Double(size4)/mb/mb/mb)"
            
            sizeLabel1.text! += "\n\(Double(size4 - size1)/mb/mb/mb)"
            sizeLabel2.text! += "\n\(Double(size4 - size2)/mb/mb/mb)"
            sizeLabel3.text! += "\n\(Double(size4 - size3)/mb/mb/mb)"
        }
        
//        if #available(iOS 11.0, *) {
//            let fileURL = URL(fileURLWithPath: Device.homeFolder)
//
//            //let mb: Double = 1024
//            let mb: Double = 1000
//
//
//
//            let values1 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
//            let size1 = Int64(values1?.volumeAvailableCapacity ?? 0)
//            sizeLabel1.text! += "\n\(size1)\n\(Double(size1)/mb/mb/mb)"
//
//
//            /// Failed to get available space for volume /: Error Domain=CacheDeleteErrorDomain Code=10 "(null)" UserInfo={Volume=/}
//            //            let values2 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
//            //            sizeLabel2.text = String(Int64(values2?.volumeAvailableCapacityForImportantUsage ?? 0))
//            //
//            //            let values3 = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
//            //            sizeLabel3.text = String(Int64(values3?.volumeAvailableCapacityForOpportunisticUsage ?? 0))
//
//            let values4 = try? fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
//            let size4 = Int64(values4?.volumeTotalCapacity ?? 0)
//            sizeLabel4.text! += "\n\n\(size4)\n\(Double(size4)/mb/mb/mb)"
//            sizeLabel4.text! +=  "\n\(Double(size4 - size1)/mb/mb/mb)"
//        }
        
        /// iOS 9
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
        let freeSize = systemAttributes?[.systemFreeSize] as? NSNumber
        
        let newFreeSize = freeSize?.int64Value ?? 0
        print("--- size:", self.freeSize - newFreeSize)
        self.freeSize = newFreeSize
        sizeLabel5.text = String(self.freeSize)
        
        
        ///////////////////////////
        
        /// https://stackoverflow.com/a/32814710/5893286
        let fileManager = FileManager.default
        guard let documentsUrl =  fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            assertionFailure()
            return
        }
        
        // check if the url is a directory
        if (try? documentsUrl.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true {
            var folderSize = 0
            print("count: ",FileManager.default.enumerator(at: documentsUrl, includingPropertiesForKeys: nil)!.allObjects.count)
            (FileManager.default.enumerator(at: documentsUrl, includingPropertiesForKeys: nil)?.allObjects as? [URL])?.lazy.forEach {
                //print("name:", $0.lastPathComponent)
                folderSize += (try? $0.resourceValues(forKeys: [.totalFileAllocatedSizeKey]))?.totalFileAllocatedSize ?? 0
            }
            let  byteCountFormatter =  ByteCountFormatter()
            byteCountFormatter.allowedUnits = .useMB
            byteCountFormatter.countStyle = .file
            let sizeToDisplay = byteCountFormatter.string(for: folderSize) ?? ""
            print(sizeToDisplay)
            print()
        }
    }
    
    var freeSize: Int64 = 0
}


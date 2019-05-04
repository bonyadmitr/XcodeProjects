import UIKit

/// https://developer.apple.com/videos/play/wwdc2018/204/
///
/// docs
/// https://developer.apple.com/documentation/security/password_autofill/
/// https://developer.apple.com/documentation/security/password_autofill/enabling_password_autofill_on_a_text_input_view
/// https://developer.apple.com/documentation/security/password_autofill/customizing_password_autofill_rules
final class ViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField! {
        willSet {
            newValue.keyboardType = .emailAddress
            
            if #available(iOS 11.0, *) {
                newValue.textContentType = .username
            }
        }
    }
    
    @IBOutlet private weak var oldPasswordTextField: UITextField! {
        willSet {
            newValue.isSecureTextEntry = true
            
            if #available(iOS 11.0, *) {
                newValue.textContentType = .password
            }
            
            newValue.font = UIFont.systemFont(ofSize: 17)
            newValue.textColor = UIColor.black
            newValue.borderStyle = .none
            newValue.backgroundColor = .white
            newValue.isOpaque = true
            newValue.placeholder = "oldPasswordTextField"
            
            newValue.returnKeyType = .next
            
            /// removes suggestions bar above keyboard
            newValue.autocorrectionType = .no
            
            /// removed useless features
            newValue.autocapitalizationType = .none
            newValue.spellCheckingType = .no
            newValue.enablesReturnKeyAutomatically = true
            if #available(iOS 11.0, *) {
                newValue.smartQuotesType = .no
                newValue.smartDashesType = .no
            }
        }
    }
    
    //confirmNewPasswordTextField
    @IBOutlet private weak var newPasswordTextField: UITextField! {
        willSet {
            if #available(iOS 12.0, *) {
                newValue.textContentType = .newPassword
                
                newValue.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; max-consecutive: 2; minlength: 8;")
            }
        }
    }
    
    @IBOutlet private weak var repeatPasswordTextField: UITextField! {
        willSet {
            if #available(iOS 12.0, *) {
                newValue.textContentType = .newPassword
            }
        }
    }
    
    @IBOutlet private weak var codeTextField: UITextField! {
        willSet {
            if #available(iOS 12.0, *) {
                newValue.textContentType = .oneTimeCode
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

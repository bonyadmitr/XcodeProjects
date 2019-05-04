import UIKit

/// https://developer.apple.com/videos/play/wwdc2018/204/
///
/// rus (!!! Capabilities > Associated Domains and AutoFill Credential Provider)
/// https://habr.com/ru/post/438580/
///
/// docs
/// https://developer.apple.com/documentation/security/password_autofill/
/// https://developer.apple.com/documentation/security/password_autofill/enabling_password_autofill_on_a_text_input_view
/// https://developer.apple.com/documentation/security/password_autofill/customizing_password_autofill_rules
///
/// Cannot show Automatic Strong Passwords for app bundleID: com.by.PasswordAutoFill due to error: iCloud Keychain is disabled
/// Cannot show Automatic Strong Passwords for app bundleID: com.by.PasswordAutoFill due to error: Cannot save passwords for this app. Make sure you have set up Associated Domains for your app and AutoFill Passwords is enabled in Settings
/// Settings > Passwords & Accounts > Autofill Passwords
/// Settings > Passwords & Accounts > iCloud > Keychain on
/// https://www.digitaltrends.com/mobile/how-to-use-passwords-and-accounts-in-ios-12/
final class ViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField! {
        willSet {
            newValue.placeholder = "usernameTextField"
            newValue.keyboardType = .emailAddress
            
            if #available(iOS 11.0, *) {
                newValue.textContentType = .username
            }
        }
    }
    
    @IBOutlet private weak var oldPasswordTextField: UITextField! {
        willSet {
            newValue.placeholder = "oldPasswordTextField"
            newValue.isSecureTextEntry = true
            
            if #available(iOS 11.0, *) {
                newValue.textContentType = .password
            }
            
            newValue.font = UIFont.systemFont(ofSize: 17)
            newValue.textColor = UIColor.black
            newValue.borderStyle = .none
            newValue.backgroundColor = .white
            newValue.isOpaque = true
            
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
                newValue.placeholder = "newPasswordTextField"
                newValue.textContentType = .newPassword
                
                newValue.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; allowed: [-().&@?'#,/&quot;+]; max-consecutive: 2; minlength: 8; maxlength: 16;")
            }
        }
    }
    
    @IBOutlet private weak var repeatPasswordTextField: UITextField! {
        willSet {
            newValue.placeholder = "repeatPasswordTextField"
            if #available(iOS 12.0, *) {
                newValue.textContentType = .newPassword
                
                newValue.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; allowed: [-().&@?'#,/&quot;+]; max-consecutive: 2; minlength: 8; maxlength: 16;")
            }
        }
    }
    
    @IBOutlet private weak var codeTextField: UITextField! {
        willSet {
            newValue.placeholder = "codeTextField"
            if #available(iOS 12.0, *) {
                newValue.textContentType = .oneTimeCode
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

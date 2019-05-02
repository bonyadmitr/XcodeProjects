import UIKit

final class GameSettingsController: UIViewController {
    
    @IBOutlet private weak var rawsStepper: UIStepper!
    @IBOutlet private weak var collumnsStepper: UIStepper!
    @IBOutlet private weak var equalsStepper: UIStepper!
    
    @IBOutlet private weak var rawsCountLabel: UILabel!
    @IBOutlet private weak var collumnsCountLabel: UILabel!
    @IBOutlet private weak var equalsCountLabel: UILabel!
    
    @IBOutlet weak var startBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rawsStepper.value = 4
        collumnsStepper.value = 4
        equalsStepper.value = 2
        
        rawsCountLabel.text = String(rawsStepper.value)
        collumnsCountLabel.text = String(collumnsStepper.value)
        equalsCountLabel.text = String(equalsStepper.value)
        
        check()
    }
    
    @IBAction func onStartBarButton(_ sender: UIBarButtonItem) {
        
        let raws = Int(rawsStepper.value)
        let collumns = Int(collumnsStepper.value)
        let equalNumber = Int(equalsStepper.value)
        
        let isAvailableGame = Game.isAvailableToStartWith(raws: raws, collumns: collumns, equalNumber: equalNumber)
        assert(isAvailableGame)
        
        let vc = GameController()
        vc.numberOfRaws = raws
        vc.numberOfCollumns = collumns
        vc.equalNumber = equalNumber
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction private func onRawsStepper(_ sender: UIStepper) {
        rawsCountLabel.text = String(sender.value)
        check()
    }
    
    @IBAction private func onCollumnsStepper(_ sender: UIStepper) {
        collumnsCountLabel.text = String(sender.value)
        check()
    }
    
    @IBAction private func onEqualsStepper(_ sender: UIStepper) {
        equalsCountLabel.text = String(sender.value)
        check()
    }
    
    private func check() {
        let raws = Int(rawsStepper.value)
        let collumns = Int(collumnsStepper.value)
        let equalNumber = Int(equalsStepper.value)
        
        let isAvailableGame = Game.isAvailableToStartWith(raws: raws, collumns: collumns, equalNumber: equalNumber)
        startBarButton.isEnabled = isAvailableGame
    }
}

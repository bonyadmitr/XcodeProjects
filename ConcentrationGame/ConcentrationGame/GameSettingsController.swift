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
        
        initialSetup()
        check()
    }
    
    private func initialSetup() {
        rawsStepper.minimumValue = 1
        collumnsStepper.minimumValue = 1
        equalsStepper.minimumValue = 1
        
        collumnsStepper.maximumValue = 10
        
        let raws = 4
        let collumns = 4
        let equalNumber = 2
        
        rawsStepper.value = Double(raws)
        collumnsStepper.value = Double(collumns)
        equalsStepper.value = Double(equalNumber)
        
        rawsCountLabel.text = String(raws)
        collumnsCountLabel.text = String(collumns)
        equalsCountLabel.text = String(equalNumber)
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
        rawsCountLabel.text = String(Int(sender.value))
        check()
    }
    
    @IBAction private func onCollumnsStepper(_ sender: UIStepper) {
        collumnsCountLabel.text = String(Int(sender.value))
        check()
    }
    
    @IBAction private func onEqualsStepper(_ sender: UIStepper) {
        equalsCountLabel.text = String(Int(sender.value))
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

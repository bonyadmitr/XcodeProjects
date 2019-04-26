import UIKit

enum ConcentrationState {
    case start
    case wrongPaire
    case selection
    case finished
}

/// for novice
/// https://habr.com/ru/company/skillbox/blog/447598/
/// https://github.com/Xiomara7/Memory

final class ConcentrationGame {
    
    var raws: Int = 0
    var collumns: Int = 0
    
    var gameModels = [GameModel]()
    
    func start(raws: Int, collumns: Int) {
        self.raws = raws
        self.collumns = collumns
        
        let totalCells = raws * collumns
        if totalCells % 2 == 1 {
            assertionFailure()
            return
        }
        let createCellsCount = totalCells / 2
        
        var emojies = [String]()
        while emojies.count < createCellsCount {
            let randomEmojy = Emoji.shared.emojiCategories["people"]!.randomElement()!
            if !emojies.contains(randomEmojy) {
                emojies.append(randomEmojy)
            }
        }
        
        assert(emojies.count == createCellsCount)
        
        gameModels = emojies.enumerated().map { GameModel(id: $0.offset, emojy: $0.element) }
        //gameModels = emojies.map { GameModel(id: UUID().uuidString, emojy: $0) }
        
        gameModels += gameModels
        gameModels.shuffle()
        
        assert(gameModels.count == totalCells)
    }
    
    var openedCount = 0
    var isFinished = false
}

final class GameModel {
    let id: Int
    let emojy: String
    var isOpened = false
    var isAlwayesOpened = false
    
    init(id: Int, emojy: String) {
        self.id = id
        self.emojy = emojy
    }
}

extension GameModel: Equatable {
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.id == rhs.id
    }
}

final class GameController: UIViewController {

    private let game = ConcentrationGame()
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        willSet {
            let viewWidth = UIScreen.main.bounds.width
            
            let columns: CGFloat = CGFloat(numberOfCollumns)
            let padding: CGFloat = 1
            let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
            let itemSize = CGSize(width: itemWidth, height: itemWidth)
            
            if let layout = newValue.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = itemSize
                layout.minimumInteritemSpacing = padding
                layout.minimumLineSpacing = padding
            }
            
            
            newValue.register(GameCell.self, forCellWithReuseIdentifier: "GameCell")
            newValue.dataSource = self
            newValue.delegate = self
            
            newValue.backgroundColor = UIColor.lightGray
        }
    }
    
    let numberOfRaws = 4
    let numberOfCollumns = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.start(raws: numberOfRaws, collumns: numberOfCollumns)
        // TODO: update lauout
        collectionView.reloadData()
    }

    var lastSelectedIndexPath: IndexPath?
    
    
    var closeIndexPath1: IndexPath?
    var closeIndexPath2: IndexPath?
}

extension GameController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.raws * game.collumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        
//        let w = UnicodeScalar("👻")
//        let next = UnicodeScalar(w.value + UInt32(indexPath.row))!
//        cell.label.text = String(next)
        
//        cell.label.text = game.gameModels[indexPath.row].emojy
        return cell
    }
}

extension GameController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if game.isFinished {
            return
        }
        
        if lastSelectedIndexPath == indexPath {
            return
        }
        
        let selectedModel = game.gameModels[indexPath.row]
        if selectedModel.isAlwayesOpened {
            return
        }
        
        if let closeIndexPath1 = closeIndexPath1, let closeIndexPath2 = closeIndexPath2 {
            self.closeIndexPath1 = nil
            self.closeIndexPath2 = nil
            let cell1 = collectionView.cellForItem(at: closeIndexPath1) as! GameCell
            let cell2 = collectionView.cellForItem(at: closeIndexPath2) as! GameCell
            cell1.close()
            cell2.close()
        }
        
        if let lastSelectedIndexPath = lastSelectedIndexPath {
            let lastSelectedModel = game.gameModels[lastSelectedIndexPath.row]
            
            if selectedModel == lastSelectedModel {
                selectedModel.isAlwayesOpened = true
                lastSelectedModel.isAlwayesOpened = true
                game.openedCount += 2
                
                if game.openedCount == game.gameModels.count {
                    game.isFinished = true
                    print("- finished")
                }
                
            } else {
                closeIndexPath1 = indexPath
                closeIndexPath2 = lastSelectedIndexPath
            }
            
            self.lastSelectedIndexPath = nil
        } else {
            self.lastSelectedIndexPath = indexPath
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! GameCell
        UIView.transition(with: cell, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: {
            cell.label.text = self.game.gameModels[indexPath.row].emojy
        }, completion: nil)
        
//        let q: UIView.AnimationOptions = cell.isShown ? .transitionFlipFromRight : .transitionFlipFromLeft
//        UIView.transition(with: cell, duration: 0.5, options: [q, .showHideTransitionViews], animations: {
//            if cell.isShown {
//                cell.label.text = self.game.gameModels[indexPath.row].emojy
//            } else {
//                cell.label.text = ""
//            }
//        }, completion: nil)
    }
}

final class GameCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
//        label.font = UIFont.systemFont(ofSize: 70) //5se
//        label.font = UIFont.systemFont(ofSize: 90) //6+
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        label.isOpaque = true
//        label.numberOfLines = 1
//        label.lineBreakMode = .byWordWrapping
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.1
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if label.frame != bounds {
            label.frame = bounds
            label.font = label.font.withSize(bounds.height * 0.9)
        }
    }
    
    func close() {
        UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], animations: {
            self.label.text = ""
        }, completion: nil)
    }
    
    var isShown: Bool = false
    
    // MARK: - Methods
//    func showCard(_ show: Bool, animted: Bool) {
    func toggle() {
//        frontImageView.isHidden = false
//        backImageView.isHidden = false
        isShown = !isShown

        if isShown {
            UIView.transition(with: label, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: nil, completion: nil)
//            UIView.transition(
//                from: label,
//                to: label,
//                duration: 0.5,
//                options: [.transitionFlipFromRight, .showHideTransitionViews],
//                completion: { nil)
        } else {
            UIView.transition(with: label, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: nil, completion: nil)
//            UIView.transition(
//                from: frontImageView,
//                to: backImageView,
//                duration: 0.5,
//                options: [.transitionFlipFromRight, .showHideTransitionViews],
//                completion:  { (finished: Bool) -> () in
//            })
        }
        
//        if animted {
//            if show {
//                UIView.transition(
//                    from: backImageView,
//                    to: frontImageView,
//                    duration: 0.5,
//                    options: [.transitionFlipFromRight, .showHideTransitionViews],
//                    completion: { (finished: Bool) -> () in
//                })
//            } else {
//                UIView.transition(
//                    from: frontImageView,
//                    to: backImageView,
//                    duration: 0.5,
//                    options: [.transitionFlipFromRight, .showHideTransitionViews],
//                    completion:  { (finished: Bool) -> () in
//                })
//            }
//        } else {
//            if show {
//                bringSubview(toFront: frontImageView)
//                backImageView.isHidden = true
//            } else {
//                bringSubview(toFront: backImageView)
//                frontImageView.isHidden = true
//            }
//        }
    }
}

final class Emoji {
    
    static let shared = Emoji()
    
    let q = "👻🎃😱👽💀🧟‍♀️🐲👹🤡☠️"
    
    //    let themes = [
    //        "Halloween": "👻🎃😱👽💀🧟‍♀️🐲👹🤡☠️",
    //        "Animals": "😸🐶🐰🦊🐷🐥🐼🦋🐭🐠",
    //        "Numbers": "1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟",
    //        "Letters": "АБВГДЕЖЗИКЛМНОПРСТУФХЦШЩЬЪЭЮЯ",
    //        "Cats": "😹😻😼😽🙀😿😾🐱😸😺"
    //    ]
    
    /// https://github.com/onmyway133/Smile/blob/master/Sources/Smile.swift
    public func list() -> [String] {
        let ranges = [
            0x1F601...0x1F64F,
            0x2600...0x27B0,
            0x23F0...0x23FA,
            0x1F680...0x1F6C0,
            0x1F170...0x1F251
        ]
        
        var all = ranges.joined().map {
            return String(Character(UnicodeScalar($0)!))
        }
        
        //⌚️⌨️⭐️
        let solos = [0x231A, 0x231B, 0x2328, 0x2B50]
        all.append(contentsOf: solos.map({ String(Character(UnicodeScalar($0)!))}))
        
        return all
    }
    
    /// https://github.com/onmyway133/Smile/blob/master/Sources/Categories.swift
    /// Emoji.shared.emojiCategories.forEach { print("\($0): \($1.count)") }
    //nature: 159
    //people: 291
    //foods: 86
    //objects: 173
    //activity: 80
    //places: 119
    //symbols: 271
    //flags: 253
    public let emojiCategories: [String: [String]] = [
        "people": ["😀","😃","😄","😁","😆","😅","😂","🤣","☺️","😊","😇","🙂","🙃","😉","😌","😍","😘","😗","😙","😚","😋","😜","😝","😛","🤑","🤗","🤓","😎","🤡","🤠","😏","😒","😞","😔","😟","😕","🙁","☹️","😣","😖","😫","😩","😤","😠","😡","😶","😐","😑","😯","😦","😧","😮","😲","😵","😳","😱","😨","😰","😢","😥","🤤","😭","😓","😪","😴","🙄","🤔","🤥","😬","🤐","🤢","🤧","😷","🤒","🤕","😈","👿","👹","👺","💩","👻","💀","☠️","👽","👾","🤖","🎃","😺","😸","😹","😻","😼","😽","🙀","😿","😾","👐","🙌","👏","🙏","🤝","👍","👎","👊","✊","🤛","🤜","🤞","✌️","🤘","👌","👈","👉","👆","👇","☝️","✋","🤚","🖐","🖖","👋","🤙","💪","🖕","✍️","🤳","💅","💍","💄","💋","👄","👅","👂","👃","👣","👁","👀","🗣","👤","👥","👶","👦","👧","👨","👩","👱‍♀️","👱","👴","👵","👲","👳‍♀️","👳","👮‍♀️","👮","👷‍♀️","👷","💂‍♀️","💂","🕵️‍♀️","🕵️","👩‍⚕️","👨‍⚕️","👩‍🌾","👨‍🌾","👩‍🍳","👨‍🍳","👩‍🎓","👨‍🎓","👩‍🎤","👨‍🎤","👩‍🏫","👨‍🏫","👩‍🏭","👨‍🏭","👩‍💻","👨‍💻","👩‍💼","👨‍💼","👩‍🔧","👨‍🔧","👩‍🔬","👨‍🔬","👩‍🎨","👨‍🎨","👩‍🚒","👨‍🚒","👩‍✈️","👨‍✈️","👩‍🚀","👨‍🚀","👩‍⚖️","👨‍⚖️","🤶","🎅","👸","🤴","👰","🤵","👼","🤰","🙇‍♀️","🙇","💁","💁‍♂️","🙅","🙅‍♂️","🙆","🙆‍♂️","🙋","🙋‍♂️","🤦‍♀️","🤦‍♂️","🤷‍♀️","🤷‍♂️","🙎","🙎‍♂️","🙍","🙍‍♂️","💇","💇‍♂️","💆","💆‍♂️","🕴","💃","🕺","👯","👯‍♂️","🚶‍♀️","🚶","🏃‍♀️","🏃","👫","👭","👬","💑","👩‍❤️‍👩","👨‍❤️‍👨","💏","👩‍❤️‍💋‍👩","👨‍❤️‍💋‍👨","👪","👨‍👩‍👧","👨‍👩‍👧‍👦","👨‍👩‍👦‍👦","👨‍👩‍👧‍👧","👩‍👩‍👦","👩‍👩‍👧","👩‍👩‍👧‍👦","👩‍👩‍👦‍👦","👩‍👩‍👧‍👧","👨‍👨‍👦","👨‍👨‍👧","👨‍👨‍👧‍👦","👨‍👨‍👦‍👦","👨‍👨‍👧‍👧","👩‍👦","👩‍👧","👩‍👧‍👦","👩‍👦‍👦","👩‍👧‍👧","👨‍👦","👨‍👧","👨‍👧‍👦","👨‍👦‍👦","👨‍👧‍👧","👚","👕","👖","👔","👗","👙","👘","👠","👡","👢","👞","👟","👒","🎩","🎓","👑","⛑","🎒","👝","👛","👜","💼","👓","🕶","🌂","☂️"],
        "nature": ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷","🐽","🐸","🐵","🙈","🙉","🙊","🐒","🐔","🐧","🐦","🐤","🐣","🐥","🦆","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝","🐛","🦋","🐌","🐚","🐞","🐜","🕷","🕸","🐢","🐍","🦎","🦂","🦀","🦑","🐙","🦐","🐠","🐟","🐡","🐬","🦈","🐳","🐋","🐊","🐆","🐅","🐃","🐂","🐄","🦌","🐪","🐫","🐘","🦏","🦍","🐎","🐖","🐐","🐏","🐑","🐕","🐩","🐈","🐓","🦃","🕊","🐇","🐁","🐀","🐿","🐾","🐉","🐲","🌵","🎄","🌲","🌳","🌴","🌱","🌿","☘️","🍀","🎍","🎋","🍃","🍂","🍁","🍄","🌾","💐","🌷","🌹","🥀","🌻","🌼","🌸","🌺","🌎","🌍","🌏","🌕","🌖","🌗","🌘","🌑","🌒","🌓","🌔","🌚","🌝","🌞","🌛","🌜","🌙","💫","⭐️","🌟","✨","⚡️","🔥","💥","☄️","☀️","🌤","⛅️","🌥","🌦","🌈","☁️","🌧","⛈","🌩","🌨","☃️","⛄️","❄️","🌬","💨","🌪","🌫","🌊","💧","💦","☔️"],
        "foods": ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍈","🍒","🍑","🍍","🥝","🥑","🍅","🍆","🥒","🥕","🌽","🌶","🥔","🍠","🌰","🥜","🍯","🥐","🍞","🥖","🧀","🥚","🍳","🥓","🥞","🍤","🍗","🍖","🍕","🌭","🍔","🍟","🥙","🌮","🌯","🥗","🥘","🍝","🍜","🍲","🍥","🍣","🍱","🍛","🍚","🍙","🍘","🍢","🍡","🍧","🍨","🍦","🍰","🎂","🍮","🍭","🍬","🍫","🍿","🍩","🍪","🥛","🍼","☕️","🍵","🍶","🍺","🍻","🥂","🍷","🥃","🍸","🍹","🍾","🥄","🍴","🍽"],
        "activity": ["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸","🥅","🏒","🏑","🏏","⛳️","🏹","🎣","🥊","🥋","⛸","🎿","⛷","🏂","🏋️‍♀️","🏋️","🤺","🤼‍♀️","🤼‍♂️","🤸‍♀️","🤸‍♂️","⛹️‍♀️","⛹️","🤾‍♀️","🤾‍♂️","🏌️‍♀️","🏌️","🏄‍♀️","🏄","🏊‍♀️","🏊","🤽‍♀️","🤽‍♂️","🚣‍♀️","🚣","🏇","🚴‍♀️","🚴","🚵‍♀️","🚵","🎽","🏅","🎖","🥇","🥈","🥉","🏆","🏵","🎗","🎫","🎟","🎪","🤹‍♀️","🤹‍♂️","🎭","🎨","🎬","🎤","🎧","🎼","🎹","🥁","🎷","🎺","🎸","🎻","🎲","🎯","🎳","🎮","🎰"],
        "places": ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐","🚚","🚛","🚜","🛴","🚲","🛵","🏍","🚨","🚔","🚍","🚘","🚖","🚡","🚠","🚟","🚃","🚋","🚞","🚝","🚄","🚅","🚈","🚂","🚆","🚇","🚊","🚉","🚁","🛩","✈️","🛫","🛬","🚀","🛰","💺","🛶","⛵️","🛥","🚤","🛳","⛴","🚢","⚓️","🚧","⛽️","🚏","🚦","🚥","🗺","🗿","🗽","⛲️","🗼","🏰","🏯","🏟","🎡","🎢","🎠","⛱","🏖","🏝","⛰","🏔","🗻","🌋","🏜","🏕","⛺️","🛤","🛣","🏗","🏭","🏠","🏡","🏘","🏚","🏢","🏬","🏣","🏤","🏥","🏦","🏨","🏪","🏫","🏩","💒","🏛","⛪️","🕌","🕍","🕋","⛩","🗾","🎑","🏞","🌅","🌄","🌠","🎇","🎆","🌇","🌆","🏙","🌃","🌌","🌉","🌁"],
        "objects": ["⌚️","📱","📲","💻","⌨️","🖥","🖨","🖱","🖲","🕹","🗜","💽","💾","💿","📀","📼","📷","📸","📹","🎥","📽","🎞","📞","☎️","📟","📠","📺","📻","🎙","🎚","🎛","⏱","⏲","⏰","🕰","⌛️","⏳","📡","🔋","🔌","💡","🔦","🕯","🗑","🛢","💸","💵","💴","💶","💷","💰","💳","💎","⚖️","🔧","🔨","⚒","🛠","⛏","🔩","⚙️","⛓","🔫","💣","🔪","🗡","⚔️","🛡","🚬","⚰️","⚱️","🏺","🔮","📿","💈","⚗️","🔭","🔬","🕳","💊","💉","🌡","🚽","🚰","🚿","🛁","🛀","🛎","🔑","🗝","🚪","🛋","🛏","🛌","🖼","🛍","🛒","🎁","🎈","🎏","🎀","🎊","🎉","🎎","🏮","🎐","✉️","📩","📨","📧","💌","📥","📤","📦","🏷","📪","📫","📬","📭","📮","📯","📜","📃","📄","📑","📊","📈","📉","🗒","🗓","📆","📅","📇","🗃","🗳","🗄","📋","📁","📂","🗂","🗞","📰","📓","📔","📒","📕","📗","📘","📙","📚","📖","🔖","🔗","📎","🖇","📐","📏","📌","📍","✂️","🖊","🖋","✒️","🖌","🖍","📝","✏️","🔍","🔎","🔏","🔐","🔒","🔓"],
        "symbols": ["❤️","💛","💚","💙","💜","🖤","💔","❣️","💕","💞","💓","💗","💖","💘","💝","💟","☮️","✝️","☪️","🕉","☸️","✡️","🔯","🕎","☯️","☦️","🛐","⛎","♈️","♉️","♊️","♋️","♌️","♍️","♎️","♏️","♐️","♑️","♒️","♓️","🆔","⚛️","🉑","☢️","☣️","📴","📳","🈶","🈚️","🈸","🈺","🈷️","✴️","🆚","💮","🉐","㊙️","㊗️","🈴","🈵","🈹","🈲","🅰️","🅱️","🆎","🆑","🅾️","🆘","❌","⭕️","🛑","⛔️","📛","🚫","💯","💢","♨️","🚷","🚯","🚳","🚱","🔞","📵","🚭","❗️","❕","❓","❔","‼️","⁉️","🔅","🔆","〽️","⚠️","🚸","🔱","⚜️","🔰","♻️","✅","🈯️","💹","❇️","✳️","❎","🌐","💠","Ⓜ️","🌀","💤","🏧","🚾","♿️","🅿️","🈳","🈂️","🛂","🛃","🛄","🛅","🚹","🚺","🚼","🚻","🚮","🎦","📶","🈁","🔣","ℹ️","🔤","🔡","🔠","🆖","🆗","🆙","🆒","🆕","🆓","0️⃣","1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣","9️⃣","🔟","🔢","#️⃣","*️⃣","▶️","⏸","⏯","⏹","⏺","⏭","⏮","⏩","⏪","⏫","⏬","◀️","🔼","🔽","➡️","⬅️","⬆️","⬇️","↗️","↘️","↙️","↖️","↕️","↔️","↪️","↩️","⤴️","⤵️","🔀","🔁","🔂","🔄","🔃","🎵","🎶","➕","➖","➗","✖️","💲","💱","™️","©️","®️","〰️","➰","➿","🔚","🔙","🔛","🔝","🔜","✔️","☑️","🔘","⚪️","⚫️","🔴","🔵","🔺","🔻","🔸","🔹","🔶","🔷","🔳","🔲","▪️","▫️","◾️","◽️","◼️","◻️","⬛️","⬜️","🔈","🔇","🔉","🔊","🔔","🔕","📣","📢","👁‍🗨","💬","💭","🗯","♠️","♣️","♥️","♦️","🃏","🎴","🀄️","🕐","🕑","🕒","🕓","🕔","🕕","🕖","🕗","🕘","🕙","🕚","🕛","🕜","🕝","🕞","🕟","🕠","🕡","🕢","🕣","🕤","🕥","🕦","🕧"],
        "flags": ["🏳️","🏴","🏁","🚩","🏳️‍🌈","🇦🇫","🇦🇽","🇦🇱","🇩🇿","🇦🇸","🇦🇩","🇦🇴","🇦🇮","🇦🇶","🇦🇬","🇦🇷","🇦🇲","🇦🇼","🇦🇺","🇦🇹","🇦🇿","🇧🇸","🇧🇭","🇧🇩","🇧🇧","🇧🇾","🇧🇪","🇧🇿","🇧🇯","🇧🇲","🇧🇹","🇧🇴","🇧🇶","🇧🇦","🇧🇼","🇧🇷","🇮🇴","🇻🇬","🇧🇳","🇧🇬","🇧🇫","🇧🇮","🇨🇻","🇰🇭","🇨🇲","🇨🇦","🇮🇨","🇰🇾","🇨🇫","🇹🇩","🇨🇱","🇨🇳","🇨🇽","🇨🇨","🇨🇴","🇰🇲","🇨🇬","🇨🇩","🇨🇰","🇨🇷","🇨🇮","🇭🇷","🇨🇺","🇨🇼","🇨🇾","🇨🇿","🇩🇰","🇩🇯","🇩🇲","🇩🇴","🇪🇨","🇪🇬","🇸🇻","🇬🇶","🇪🇷","🇪🇪","🇪🇹","🇪🇺","🇫🇰","🇫🇴","🇫🇯","🇫🇮","🇫🇷","🇬🇫","🇵🇫","🇹🇫","🇬🇦","🇬🇲","🇬🇪","🇩🇪","🇬🇭","🇬🇮","🇬🇷","🇬🇱","🇬🇩","🇬🇵","🇬🇺","🇬🇹","🇬🇬","🇬🇳","🇬🇼","🇬🇾","🇭🇹","🇭🇳","🇭🇰","🇭🇺","🇮🇸","🇮🇳","🇮🇩","🇮🇷","🇮🇶","🇮🇪","🇮🇲","🇮🇱","🇮🇹","🇯🇲","🇯🇵","🎌","🇯🇪","🇯🇴","🇰🇿","🇰🇪","🇰🇮","🇽🇰","🇰🇼","🇰🇬","🇱🇦","🇱🇻","🇱🇧","🇱🇸","🇱🇷","🇱🇾","🇱🇮","🇱🇹","🇱🇺","🇲🇴","🇲🇰","🇲🇬","🇲🇼","🇲🇾","🇲🇻","🇲🇱","🇲🇹","🇲🇭","🇲🇶","🇲🇷","🇲🇺","🇾🇹","🇲🇽","🇫🇲","🇲🇩","🇲🇨","🇲🇳","🇲🇪","🇲🇸","🇲🇦","🇲🇿","🇲🇲","🇳🇦","🇳🇷","🇳🇵","🇳🇱","🇳🇨","🇳🇿","🇳🇮","🇳🇪","🇳🇬","🇳🇺","🇳🇫","🇲🇵","🇰🇵","🇳🇴","🇴🇲","🇵🇰","🇵🇼","🇵🇸","🇵🇦","🇵🇬","🇵🇾","🇵🇪","🇵🇭","🇵🇳","🇵🇱","🇵🇹","🇵🇷","🇶🇦","🇷🇪","🇷🇴","🇷🇺","🇷🇼","🇧🇱","🇸🇭","🇰🇳","🇱🇨","🇵🇲","🇻🇨","🇼🇸","🇸🇲","🇸🇹","🇸🇦","🇸🇳","🇷🇸","🇸🇨","🇸🇱","🇸🇬","🇸🇽","🇸🇰","🇸🇮","🇸🇧","🇸🇴","🇿🇦","🇬🇸","🇰🇷","🇸🇸","🇪🇸","🇱🇰","🇸🇩","🇸🇷","🇸🇿","🇸🇪","🇨🇭","🇸🇾","🇹🇼","🇹🇯","🇹🇿","🇹🇭","🇹🇱","🇹🇬","🇹🇰","🇹🇴","🇹🇹","🇹🇳","🇹🇷","🇹🇲","🇹🇨","🇹🇻","🇺🇬","🇺🇦","🇦🇪","🇬🇧","🇺🇸","🇻🇮","🇺🇾","🇺🇿","🇻🇺","🇻🇦","🇻🇪","🇻🇳","🇼🇫","🇪🇭","🇾🇪","🇿🇲","🇿🇼"],
    ]

}

//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        (collectionView.bounds.width - CGFloat(numberOfCollumns - 1) * 1) / CGFloat(numberOfCollumns)
//        return CGSize(width: 100, height: 100)
//    }
//}

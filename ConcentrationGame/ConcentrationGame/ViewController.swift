//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Bondar Yaroslav on 4/23/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class Game {
    
    var raws: Int = 0
    var collumns: Int = 0
    
    var gameModels = [GameModel]()
    var showedModels = [GameModel]()
    
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
        
        gameModels = emojies.map { GameModel(id: UUID().uuidString, emojy: $0) }
        gameModels += gameModels
        gameModels.shuffle()
        
        assert(gameModels.count == totalCells)
    }
}

final class GameModel {
    let id: String
    let emojy: String
    var isOpened = false
    
    init(id: String, emojy: String) {
        self.id = id
        self.emojy = emojy
    }
}

extension GameModel: Equatable {
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.id == rhs.id
    }
}

class ViewController: UIViewController {

    let game = Game()
    
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


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.raws * game.collumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        
//        let w = UnicodeScalar("👻")
//        let next = UnicodeScalar(w.value + UInt32(indexPath.row))!
//        cell.label.text = String(next)
        
        cell.label.text = game.gameModels[indexPath.row].emojy
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        //label.font = UIFont.systemFont(ofSize: 130)
        label.font = UIFont.systemFont(ofSize: 90)
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        label.isOpaque = true
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
    }
    
    var isShown: Bool = false
    
    // MARK: - Methods
//    func showCard(_ show: Bool, animted: Bool) {
//        frontImageView.isHidden = false
//        backImageView.isHidden = false
//        shown = show
//
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
//    }
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

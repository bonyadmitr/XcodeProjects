//
//  TableCell.swift
//  AsyncDisplayKitTest
//
//  Created by zdaecqze zdaecq on 28.08.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class Item {
    var title = ""
    var time = NSDate()
    var jobType = ""
    
    init(title: String, time: NSDate, jobType: String) {
        self.title = title
        self.time = time
        self.jobType = jobType
    }
}

class TableCell: ASCellNode {
    
    var titleNode: ASTextNode
    var dateNode: ASTextNode
    var typeNode: ASTextNode
    var backgroundImageNode = ASImageNode()
    
    let blueColor = UIColor ( red: 0.1569, green: 0.4784, blue: 0.7765, alpha: 1.0 )
    let bubbleImage = UIImage(named: "chat_bubble_mine")!
    
    let dateFormatter = NSDateFormatter()
    
    init!(item: Item) {
        titleNode = ASTextNode()
        dateNode = ASTextNode()
        typeNode = ASTextNode()
        //ASDisplayNode
        
        super.init()
        //selectionStyle = .None
        dateFormatter.dateFormat = "yyyy-MM-dd"
        setupSubNodesWithItem(item)
        selectionStyle = .None
    }
    
    func setupSubNodesWithItem(item: Item) {
        titleNode.attributedString = NSAttributedString(string: item.title, attributes: [
            NSForegroundColorAttributeName: UIColor.whiteColor()
            //NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            ])
        titleNode.placeholderColor = UIColor.whiteColor()
        titleNode.flexGrow = true
        titleNode.flexShrink = true
        
        
        //dateNode.attributedString = NSAttributedString(string: dateFormatter.stringFromDate(item.time), attributes: [
            //NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            //])
        
        //typeNode.attributedString = NSAttributedString(string: item.jobType, attributes: [
            //NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline),
            //NSForegroundColorAttributeName: UIColor.blueColor()
            //])
        

        //titleNode.backgroundColor = UIColor.orangeColor()
        //titleNode.cornerRadius = 10
        //titleNode.clipsToBounds = true
        
        
        //dateNode.backgroundColor = UIColor.redColor()
        //dateNode.cornerRadius = 10
        //dateNode.clipsToBounds = true
        
        //typeNode.backgroundColor = UIColor.yellowColor()
        //typeNode.cornerRadius = 10
        //typeNode.clipsToBounds = true

        
        //MARK: Image Size Section
        
        
        //MARK: Node Creation Section
        
        backgroundImageNode.image = bubbleImage
        backgroundImageNode.placeholderColor = blueColor
        //backgroundImageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        //backgroundImageNode.contentMode = .ScaleAspectFill
        //backgroundImageNode.layerBacked = true
        //backgroundImageNode.preferredFrameSize = CGSizeMake(44, 44);
        
        addSubnode(backgroundImageNode)
        addSubnode(titleNode)
        //addSubnode(dateNode)
        //addSubnode(typeNode)
        

        

    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        //let verticalNodeStack = ASStackLayoutSpec(direction: .Vertical, spacing: 8.0, justifyContent: .End, alignItems: .BaselineFirst, children: [dateNode, typeNode])
        ////verticalNodeStack.flexShrink = true
        ////verticalNodeStack.flexGrow = true
        
        //let horisontalNodeStack = ASStackLayoutSpec(direction: .Horizontal, spacing: 5, justifyContent: .Center, alignItems: .BaselineFirst, children: [textSpec, verticalNodeStack])
        
        let backgroundSpec = ASBackgroundLayoutSpec(child: textSpec, background: backgroundImageNode)
        
        let totalInset = UIEdgeInsets(top: 10, left: 150, bottom: 10, right: 10)
        let insetSpec = ASInsetLayoutSpec(insets: totalInset, child: backgroundSpec)
        
        insetSpec.flexGrow = true
        insetSpec.flexShrink = true
        
        return insetSpec
    }
    
    var textSpec: ASLayoutSpec {
        let textInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        let titleLayout = ASInsetLayoutSpec(insets: textInsets, child: titleNode)
        titleLayout.flexGrow = true
        titleLayout.flexShrink = true
        return titleLayout
    }

}













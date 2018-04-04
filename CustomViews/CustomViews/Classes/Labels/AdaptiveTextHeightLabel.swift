//
//  AdaptiveTextHeightLabel.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 18.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: Check this class and extension

class AdaptiveTextHeightLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    // Returns an UIFont that fits the new label's height.
    private func fontToFitHeight() -> UIFont {
        
        var minFontSize: CGFloat = 18
        var maxFontSize: CGFloat = 67
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard text!.count > 0 else {
                break
            }
            
            if let labelText: NSString = text as NSString? {
                let labelHeight = frame.size.height
                
                let testStringHeight = labelText.size(
                    withAttributes: [NSAttributedStringKey.font: font.withSize(fontSizeAverage)]
                    ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return font.withSize(fontSizeAverage)
                }
            }
        }
        return font.withSize(fontSizeAverage)
    }
}


extension UILabel {
    
    open override func didMoveToWindow() {
        
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        
    }
    
    
    //Finds and sets a font size that matches the height of the frame.
    //Use in case the font size is epic huge and you need to resize it.
    func resizeToFitHeight(){
        var currentfontSize = font.pointSize
        let minFontsize = CGFloat(5)
        let constrainedSize = CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude)
        
        while (currentfontSize >= minFontsize){
            let newFont = font.withSize(currentfontSize)
            let attributedText: NSAttributedString = NSAttributedString(string: text!, attributes: [NSAttributedStringKey.font: newFont])
            let rect: CGRect = attributedText.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, context: nil)
            let size: CGSize = rect.size
            
            if (size.height < frame.height - 10) {
                font = newFont
                break;
            }
            
            currentfontSize -= 1
        }
        
        //In case the text is too long, we still show something... ;)
        if (currentfontSize == minFontsize){
            font = font.withSize(currentfontSize)
        }
    }
}

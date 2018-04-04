//
//  StyledLabel.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 18.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

@IBDesignable
class StyledLabel: UILabel
{
    @IBInspectable var tracking:CGFloat = 0.8
    // values between about 0.7 to 1.3.  one means normal.
    
    @IBInspectable var stretching:CGFloat = -0.1
    // values between about -.5 to .5.  zero means normal.
    
    override func awakeFromNib()
    {
        tweak()
    }
    
    override func prepareForInterfaceBuilder()
    {
        tweak()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    private func fontToFitHeight() -> UIFont
    {
        /* Apple have failed to include a basic thing needed in handling text: fitting the text to the height. Here's the simplest and fastest way to do that:
         
         guess = guess * ( desiredHeight / guessHeight )
         
         That's really all there is to it. The rest of the code in this routine is safeguards. Further, the routine iterates a couple of times, which is harmless, to take care of any theoretical bizarre nonlinear sizing issues with strange typefaces. */
        
        guard text!.characters.count > 0 else { return font }
        let desiredHeight:CGFloat = frame.size.height
        guard desiredHeight>1 else { return font }
        var guess:CGFloat
        var guessHeight:CGFloat
        
        print("searching for... ", desiredHeight)
        
        guess = font.pointSize
        if (guess>1&&guess<1000) { guess = 50 }
        
        guessHeight = sizeIf(pointSizeToTry: guess)
        
        if (guessHeight==desiredHeight)
        {
            print("fluke, exact match within float math limits, up front")
            return font.withSize(guess)
        }
        
        var iterations:Int = 4
        
        /* It is incredibly unlikely you would need more than four iterations, "two" would rarely be needed. You could imagine some very strange glyph handling where the relationship is non-linear (or something weird): That is the only theoretical reason you'd ever need more than one or two iterations. Note that when you watch the output of the iterations, you'll sometimes/often see same or identical values for the result: this is correct and expected in a float iteration. */
        
        while(iterations>0)
        {
            guess = guess * ( desiredHeight / guessHeight )
            guessHeight = sizeIf(pointSizeToTry: guess)
            
            if (guessHeight==desiredHeight)
            {
                print("unbelievable fluke, exact match within float math limits while iterating")
                return font.withSize(guess)
            }
            
            iterations -= 1
        }
        
        print("done. Shame Apple doesn't do this for us!")
        return font.withSize(guess)
    }
    
    private func sizeIf(pointSizeToTry:CGFloat)->(CGFloat)
    {
        let s:CGFloat = text!.size(
            withAttributes: [NSAttributedStringKey.font as NSAttributedStringKey: font.withSize(pointSizeToTry)] )
            .height
        
        print("guessing .. ", pointSizeToTry, " .. " , s)
        return s
    }
    
    private func tweak()
    {
        let ats = NSMutableAttributedString(string: self.text!)
        let rg = NSRange(location: 0, length: self.text!.count)
        ats.addAttribute(
            NSAttributedStringKey.kern, value:CGFloat(tracking), range:rg )
        
        ats.addAttribute(NSAttributedStringKey.expansion, value:CGFloat(stretching), range:rg )
        
        self.attributedText = ats
    }
}

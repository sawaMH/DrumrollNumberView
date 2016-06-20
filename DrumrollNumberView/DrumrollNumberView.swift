//
//  DrumrollNumberView.swift
//  DrumrollNumberView
//
//  Created by sawaMH on 2016/06/17.
//  Copyright © 2016年 sawaMH. All rights reserved.
//

import UIKit

class DrumrollNumberView: UIView {

    @IBInspectable var fontSize:CGFloat = 14
    @IBInspectable var font:String = ""
    @IBInspectable var textColor:UIColor = UIColor.blackColor()
    @IBInspectable var rollDuration:Double = 0.01
    @IBInspectable var maxRollCount = 20
    @IBInspectable var randomMode:Bool = false
    
    @IBInspectable var labelWidth:CGFloat = 8.0
    @IBInspectable var labelMargin:CGFloat = 0.0
    
    private var currentIndex = 0
    private var rollCount = 0
    var number = 0
    
    
    private var status:DrumrollStatus = .Rolling
    enum DrumrollStatus: Int {
        case Rolling
        case Pause
        case Stop
    }
    
    private func initializeView() {
        self.currentIndex = 0
        self.rollCount = 0
        self.status = .Rolling
        
        for label in self.subviews {
            label.removeFromSuperview()
        }
        
        var offsetX = CGFloat(0)
        var offsetY = CGFloat(0)
        for _ in "\(self.number)".characters {
            let label = UILabel(frame: CGRectMake(offsetX, offsetY, self.labelWidth, self.frame.height / 2))
            
            if self.frame.width < (offsetX + label.frame.width) {
                offsetX = CGFloat(0)
                offsetY = offsetY + label.frame.height
                label.frame.origin.x = offsetX
                label.frame.origin.y = offsetY
            }
            label.backgroundColor = self.backgroundColor
            label.font = self.font == "" ? UIFont.systemFontOfSize(self.fontSize) : UIFont(name: self.font, size: self.fontSize)
            label.textAlignment = .Center
            label.textColor = self.textColor
            
            self.addSubview(label)
            offsetX = offsetX + label.frame.width + self.labelMargin
        }
    }
    
    func startAnimation() {
        self.initializeView()
        self.addTransition()
    }
    
    func addTransition() {
        if self.currentIndex >= "\(self.number)".characters.count {
            return
        }
        
        let transition = CATransition()
        transition.duration = self.rollDuration
        transition.delegate = self
        transition.removedOnCompletion = false
        
        let numberLabels = Array(self.subviews.reverse())
        if let label = numberLabels[self.currentIndex] as? UILabel {
            label.layer.addAnimation(transition, forKey: nil)
        }
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if self.status == .Pause {
            return
        }
        
        let numberLabels = Array(self.subviews.reverse())
        if let label = numberLabels[self.currentIndex] as? UILabel {
            if anim == label.layer.animationForKey("transition") {
                label.layer.removeAnimationForKey("transition")
                
                let index = "\(self.number)".startIndex.advancedBy(("\(self.number)".characters.count - 1) - self.currentIndex)
                let number = "\(self.number)".substringWithRange(index...index)
                
                let nextRollNumber = { () -> Void in
                    label.text = number
                    
                    self.rollCount = 0
                    self.currentIndex = self.currentIndex + 1
                    self.addTransition()
                }
                
                if number == "-" {
                    nextRollNumber()
                    return
                }

                self.rollCount = self.rollCount + 1
                let max = self.randomMode == true ? self.maxRollCount : (self.maxRollCount + Int(number)!)
                if self.rollCount == max {
                    nextRollNumber()
                } else {
                    label.text = self.randomMode == true ? "\(Int(arc4random() % 9))" : "\(self.rollCount % 10)"
                }
                self.addTransition()
            }
        }
    }

    
    func pauseAnimation() {
        if self.status == .Stop {
            return
        }
        
        self.status = self.status == .Pause ? .Rolling : .Pause
        if self.status == .Rolling {
            self.addTransition()
        }
    }
    
    func stopAnimation() {
        self.status = .Stop
        for label in self.subviews {
            label.layer.removeAnimationForKey("transition")
        }
    }
}

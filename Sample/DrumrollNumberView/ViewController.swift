//
//  ViewController.swift
//  DrumrollNumberView
//
//  Created by sawaMH on 2016/06/17.
//  Copyright © 2016年 sawaMH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drumrollNumberView: DrumrollNumberView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.drumrollNumberView.layer.borderColor = UIColor.blackColor().CGColor
        self.drumrollNumberView.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonTaped(sender: UIButton) {
        var number = 0
        if let additionalNumber = Int(self.numberTextField.text!) {
            number = additionalNumber
        }
        self.drumrollNumberView.number = self.drumrollNumberView.number &+ number
        self.drumrollNumberView.startAnimation()
        
        self.numberLabel.text = "Number: \(self.drumrollNumberView.number)"
    }
    
    @IBAction func pauseButtonTaped(sender: UIButton) {
        self.drumrollNumberView.pauseAnimation()
    }
    
    @IBAction func stopButtonTaped(sender: UIButton) {
        self.drumrollNumberView.stopAnimation()
    }
}
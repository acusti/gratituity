//
//  ViewController.swift
//  Swift Tip Calculator
//
//  Created by Andrew Patton on 2014-12-02.
//  Copyright (c) 2014 acusti.ca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textMealCost: UITextField!
    
    @IBOutlet weak var textTip: UITextField!
    
    @IBOutlet weak var labelTipCalculated: UILabel!
    
    var mealCost       = ""
    var tipPercentage  = ""
    var answer : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonCalculate(sender: UIButton) {
        self.calculateTip()
    }

    @IBAction func buttonClear(sender: UIButton) {
    }
    
    func calculateTip() -> Bool {
        mealCost      = textMealCost.text
        tipPercentage = textTip.text
        
        var floatMealCost      = (mealCost as NSString).floatValue
        var floatTipPercentage = (tipPercentage as NSString).floatValue

        answer = floatMealCost * floatTipPercentage / 100
        
        // Format answer as currency
        var answerFormat = NSString(format: "%0.2f", answer)
        
        labelTipCalculated.text = "$\(answerFormat)"
        
        return true
    }
}


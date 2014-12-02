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
    
    @IBOutlet weak var sliderTip: UISlider!
    
    @IBOutlet weak var labelTipCalculated: UILabel!
    
    @IBOutlet weak var labelTipValue: UILabel!
    @IBAction func didSliderTipChange(sender: UISlider) {
        var tipFormat = NSString(format: "%0.f", sliderTip.value)
        labelTipValue.text = "\(tipFormat)%"
        calculateTip()
    }
    
    var mealCost = ""
    var tipPercentage : Float = 0
    var answer : Float = 0
    var sliderTipDefault : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sliderTipDefault = sliderTip.value;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonCalculate(sender: UIButton) {
        self.calculateTip()
    }

    @IBAction func buttonClear(sender: UIButton) {
        textMealCost.text       = ""
        sliderTip.value         = sliderTipDefault
        labelTipCalculated.text = ""
        textMealCost.becomeFirstResponder()
    }
    
    func calculateTip() -> Bool {
        mealCost      = textMealCost.text
        // Tip percentage must be rounded to match label
        tipPercentage = round(sliderTip.value)
        
        var floatMealCost = (mealCost as NSString).floatValue

        answer = floatMealCost * tipPercentage / 100
        
        // Format answer as currency
        var answerFormat = NSString(format: "%0.2f", answer)
        
        labelTipCalculated.text = "$\(answerFormat)"
        
        return true
    }
}


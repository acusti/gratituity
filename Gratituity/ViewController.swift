//
//  ViewController.swift
//  Swift Tip Calculator
//
//  Created by Andrew Patton on 2014-12-02.
//  Copyright (c) 2014 acusti.ca. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // Declare storyboard's Interface Builder outlets
    @IBOutlet weak var textMealCost:         UITextField!
    @IBOutlet weak var sliderTip:            UISlider!
    @IBOutlet weak var labelTipValue:        UILabel!
    @IBOutlet weak var labelTipCalculated:   UILabel!
    @IBOutlet weak var labelTotalCalculated: UILabel!
    
    // Defaults for resetting UI
    var sliderTipDefault:            Float  = 0
    var labelTipCalculatedDefault:   String = ""
    var labelTotalCalculatedDefault: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textMealCost.delegate       = self
        sliderTipDefault            = sliderTip.value
        labelTipCalculatedDefault   = labelTipCalculated.text!
        labelTotalCalculatedDefault = labelTotalCalculated.text!
        textMealCost.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Use UITextField's shouldChangeCharactersInRange delegated action to trigger calculateTip
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString addedCharacter: String) -> Bool {
        // First validate to make sure we are not adding multiple decimal points
        if addedCharacter == "." && find(textField.text, ".") != nil {
            return false
        }
        // Reconstruct value of textfield for calculateTip()
        // The range represents what part of the text should be replaced by replacementString
        // If user added text, range length is 0; if user deleted, range length is 1 and replacementString is empty
        // Lastly, need to cast textField.text to NSString because range is an NSRange
        let textFieldBefore: NSString = textField.text
        var textFieldValue:  String   =
              textFieldBefore.substringToIndex(range.location) +
              addedCharacter +
              textFieldBefore.substringFromIndex(range.location + range.length)
        
        self.calculateTip(textFieldValue)
        return true
    }
    
    // When user clicks clear button in textfield, reset app state
    func textFieldShouldClear(textField: UITextField) -> Bool {
        resetState()
        return true
    }
    
    // Calculate new tip when tip slider's value changes
    @IBAction func didSliderTipChange(sender: UISlider) {
        var tipFormat = NSString(format: "%0.f", sliderTip.value)
        labelTipValue.text = "\(tipFormat)%"
        calculateTip()
    }

    // Function to reset the app state
    // @param optional Bool isSliderTipReset indicates whether to also reset tipSlider
    func resetState(isSliderTipReset : Bool = false) {
        textMealCost.text         = ""
        labelTipCalculated.text   = labelTipCalculatedDefault
        labelTotalCalculated.text = labelTotalCalculatedDefault
        if isSliderTipReset {
            sliderTip.value    = sliderTipDefault
            labelTipValue.text = "\(sliderTipDefault)"
        }
    }
    
    // Main logic to calculate the tip and display it (with function overloading)
    func calculateTip() -> Bool {
        return calculateTip(textMealCost.text)
    }
    func calculateTip(mealCost:String) -> Bool {
        // Tip percentage must be rounded to match label
        var tipPercentage : Float = round(sliderTip.value)
        
        var floatMealCost   = (mealCost as NSString).floatValue
        var calculatedTip   = floatMealCost * tipPercentage / 100
        var calculatedTotal = calculatedTip + floatMealCost
        
        // Format calculations as currency
        var calculatedTipFormat   = NSString(format: "%0.2f", calculatedTip)
        var calculatedTotalFormat = NSString(format: "%0.2f", calculatedTotal)
        
        labelTipCalculated.text   = "$\(calculatedTipFormat)"
        labelTotalCalculated.text = "$\(calculatedTotalFormat)"
        
        return true
    }
}


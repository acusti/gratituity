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
    @IBOutlet weak var textMealCost:                  UITextField!
    @IBOutlet weak var sliderTip:                     UISlider!
    @IBOutlet weak var labelTipValue:                 UILabel!
    @IBOutlet weak var labelTipCalculated:            UILabel!
    @IBOutlet weak var labelTotalCalculated:          UILabel!
    @IBOutlet weak var segmentedNumberPeople:         UISegmentedControl!
    @IBOutlet weak var labelTipCalculatedPerPerson:   UILabel!
    @IBOutlet weak var labelTotalCalculatedPerPerson: UILabel!
    
    // Declare defaults for resetting UI state
    var sliderTipDefault:                     Float  = 0
    var labelTipCalculatedDefault:            String = ""
    var labelTotalCalculatedDefault:          String = ""
    var segmentedNumberPeopleDefault:         Int    = 0
    var labelTipCalculatedPerPersonDefault:   String = ""
    var labelTotalCalculatedPerPersonDefault: String = ""
    var segmentedNumberPeopleOffset:          Int    = 2
    
    // Fetch app styling constants
    let appStyles = GratuityStyles()
    
    // Kick it off
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default tint color
        self.view.tintColor = appStyles.colors["accent"]
        
        // Set up defaults
        textMealCost.delegate                = self
        sliderTipDefault                     = sliderTip.value
        labelTipCalculatedDefault            = labelTipCalculated.text!
        labelTotalCalculatedDefault          = labelTotalCalculated.text!
        segmentedNumberPeopleDefault         = segmentedNumberPeople.selectedSegmentIndex + segmentedNumberPeopleOffset
        labelTipCalculatedPerPersonDefault   = labelTipCalculatedPerPerson.text!
        labelTotalCalculatedPerPersonDefault = labelTotalCalculatedPerPerson.text!
        
        // Set up Done toolbar for “cost of meal” numeric keyboard
        let textMealCostDoneButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "didTextMealCostEndEditing")
        let textMealCostSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let textMealCostToolbarButtons = [textMealCostSpaceButton, textMealCostDoneButton]
        
        let textMealCostToolbar = UIToolbar()
        textMealCostToolbar.sizeToFit()
        textMealCostToolbar.tintColor = appStyles.colors["accent"]
        textMealCostToolbar.barStyle = UIBarStyle.Black
        textMealCostToolbar.setItems(textMealCostToolbarButtons, animated: false)
        
        // Set toolbar as inputAccessoryView of textMealCost
        textMealCost.inputAccessoryView = textMealCostToolbar
        
        // Give text meal cost field focus and show keyboard
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
        // Add "$" if not yet present (either textfield is empty or it doesn't yet have "$")
        if countElements(textField.text) == 0 || textField.text[textField.text.startIndex] != "$" {
            textField.text = "$" + textField.text
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
    
    func didTextMealCostEndEditing() {
        textMealCost.resignFirstResponder()
    }
    
    // Calculate new tip when tip slider's value changes
    @IBAction func didSliderTipChange(sender: UISlider) {
        var tipFormat = NSString(format: "%0.f", sliderTip.value)
        labelTipValue.text = "\(tipFormat)%"
        calculateTip()
    }
    
    // Calculate new tip break down when number of diners value changes
    @IBAction func didSegmentedNumberPeopleChange(sender: UISegmentedControl) {
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
        var tipPercentage: Float = round(sliderTip.value)
        // Make sure meal cost has no dollar sign
        var mealCostSanitized = mealCost
        if (countElements(mealCost) > 0 && mealCost[mealCost.startIndex] == "$") {
            mealCostSanitized = mealCost.substringFromIndex(advance(mealCost.startIndex, 1))
        }
        var floatMealCost   = (mealCostSanitized as NSString).floatValue
        var calculatedTip   = floatMealCost * tipPercentage / 100
        var calculatedTotal = calculatedTip + floatMealCost
        
        // Format calculations as currency
        var calculatedTipFormat   = NSString(format: "%0.2f", calculatedTip)
        var calculatedTotalFormat = NSString(format: "%0.2f", calculatedTotal)
        
        labelTipCalculated.text   = "$\(calculatedTipFormat)"
        labelTotalCalculated.text = "$\(calculatedTotalFormat)"
        
        // Now calculate tip and totals per person
        var numberPeople = Float(segmentedNumberPeople.selectedSegmentIndex + segmentedNumberPeopleOffset)
        
        var calculatedTipPerPerson   = calculatedTip / numberPeople
        var calculatedTotalPerPerson = calculatedTotal / numberPeople
        
        // Format calculations as currency
        var calculatedTipPerPersonFormat   = NSString(format: "%0.2f", calculatedTipPerPerson)
        var calculatedTotalPerPersonFormat = NSString(format: "%0.2f", calculatedTotalPerPerson)
        
        labelTipCalculatedPerPerson.text   = "$\(calculatedTipPerPersonFormat)"
        labelTotalCalculatedPerPerson.text = "$\(calculatedTotalPerPersonFormat)"
        
        return true
    }
}


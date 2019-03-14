//
//  AdditionalInfoController.swift
//  Snapfood
//
//  Created by Rohan Ravindran  on 2018-12-26.
//  Copyright © 2018 Rohan Ravindran. All rights reserved.
//

import UIKit
import SwiftyJSON

class AdditionalInfoController: UIViewController {

    var ingredientsText : Array<JSON> = []
    var recipeLinkText = ""
    var recipeButtonClicked = false
    var classifiedObjectTitle : String = ""
    var nutritionalInfoJSON : JSON?
    var healthLabelArray : Array<JSON> = []
    var nuttitionalInfoKeys = ["CHOCDF" : "Carbs (g)", "CHOLE" : "Cholesterol (mg)", "FAT" : "Fat (g)", "FASAT" : "Saturated (g)", "FATRN" : "Trans Fat (g)", "FE" : "Iron (mg)", "FIBTG" : "Fiber (g)", "K" : "Potassium (mg)", "NA" : "Sodium (mg)", "P" : "Phosphorus (mg)", "PROCNT" : "Protein (g)", "SUGAR" : "Sugars (g)", "TOCPHA" : "Vitamin E (mg)", "VITA_RAE" : "Vitamin A (aeg)", "VITB12" : "Vitamin B12 (aeg)", "VITB6A" : "Vitamin B6 (mg)", "VITC" : "Vitamin C (mg)", "VITD" : "Vitamin D (aeg)", "VITK1" : "Vitamin K (aeg)"] //add keys here
    var nutritionalInfoArray = ["CHOCDF", "CHOLE", "FAT", "FASAT", "FATRN", "FE", "FIBTG", "K", "NA", "P", "PROCNT", "SUGAR", "TOCPHA", "VITA_RAE", "VITB12", "VITB6A", "VITC", "VITD", "VITK1"]
    
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstTitleDescription: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var secondTitleDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = classifiedObjectTitle.capitalized
//        print(ingredientsText)
//        print(recipeLinkText)
        
        
        displayItems()
        // Do any additional setup after loading the view.
    }
    
    func displayItems() {
        if recipeButtonClicked == true {
            //set labels
            firstTitleDescription.text = ""
            firstTitleLabel.text = "Ingredients"
            firstTitleDescription.numberOfLines = 0

            for i in 0..<(ingredientsText.count) {
                firstTitleDescription.text?.append(("  \u{2022} " + ingredientsText[i].stringValue + "\n\n"))
            }
            firstTitleDescription.sizeToFit()

            let xPointFirstDescription = (firstTitleDescription.frame.origin.x)
            let yPointFirstDiscription = (firstTitleDescription.frame.origin.y + firstTitleDescription.frame.size.height)
//            var height = firstTitleDescription.frame.size.height
//            var width = firstTitleDescription.frame.size.width
            
            secondTitleLabel.frame.origin = CGPoint(x: xPointFirstDescription, y: yPointFirstDiscription)
            let xPointSecondTitle = (secondTitleLabel.frame.origin.x)
            let yPointSecondTitle = (secondTitleLabel.frame.origin.y + secondTitleLabel.frame.size.height)
            
            secondTitleDescription.frame.origin = CGPoint(x: xPointSecondTitle, y: yPointSecondTitle)
            
            
            secondTitleLabel.text = "Full Recipe Links"
            secondTitleDescription.isEditable = false
            secondTitleDescription.dataDetectorTypes = .link
            secondTitleDescription.text = recipeLinkText
        } else {
            firstTitleDescription.text = ""
            firstTitleLabel.text = "Nutrition Facts"
            firstTitleDescription.numberOfLines = 0
            print(nutritionalInfoJSON!)
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            for i in 0..<(nutritionalInfoArray.count) {
                let boldText = "\((nuttitionalInfoKeys["\(nutritionalInfoArray[i])"])!): "
                let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
                firstTitleDescription.text?.append((boldString).string + "\(((nutritionalInfoJSON!["\(nutritionalInfoArray[i])"]["quantity"]).stringValue))" + "\n\n")
                //print(nutritionalInfoArray[i])
            }
            
            firstTitleDescription.sizeToFit()
            
            let xPointFirstDescription = (firstTitleDescription.frame.origin.x)
            let yPointFirstDiscription = (firstTitleDescription.frame.origin.y + firstTitleDescription.frame.size.height)
           
            secondTitleLabel.frame.origin = CGPoint(x: xPointFirstDescription, y: yPointFirstDiscription)
            let xPointSecondTitle = (secondTitleLabel.frame.origin.x)
            let yPointSecondTitle = (secondTitleLabel.frame.origin.y + secondTitleLabel.frame.size.height)
            
            secondTitleDescription.frame.origin = CGPoint(x: xPointSecondTitle, y: yPointSecondTitle)
            
            secondTitleLabel.text = "Health Labels"
            secondTitleDescription.text = ""
            secondTitleDescription.isEditable = false
            
            for i in 0..<(healthLabelArray.count) {
                secondTitleDescription.text.append("  \u{2022} " + "\(healthLabelArray[i])\n\n")
            }
        }
    }
    //add realm and recent on home page
    //add accuracy checks and output cannot classify if lower than 10%
    //wake up at 7 and finish before breakfast, before 10
    //add auto layout contraints -- address warnings

}

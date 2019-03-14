//
//  DescriptionViewController.swift
//  Snapfood
//
//  Created by Rohan Ravindran  on 2018-12-29.
//  Copyright © 2018 Rohan Ravindran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DescriptionViewController: UIViewController {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var descriptionBody: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    
    var foodPic : UIImage?
    var foodName : String = ""
    let baseURL = "http://en.wikipedia.org/w/api.php"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        foodImageView.image = foodPic!
        foodImageView.layer.cornerRadius = 20
        foodImageView.clipsToBounds = true

        navigationItem.title = foodName
        // Do any additional setup after loading the view.
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "titles" : "\(foodName)",
            "indexpageids" : "",
            "redirects" : "1"
        ]
        
        getDescriptionData(url: baseURL, params: parameters)
        
    }
    
    func getDescriptionData(url : String, params : [String : String]) {
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let descriptionJSON : JSON = JSON(response.result.value!)
                print(descriptionJSON)
                self.parseJSON(descriptionJSON: descriptionJSON)
            } else {
                self.errorGettingAPIResults()
            }
        }
    }
    
    func errorGettingAPIResults() {
        let alert = UIAlertController(title: "Error", message: "There was an error getting results from the server, please make sure you spelled everything correctly.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            print("error")
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func parseJSON(descriptionJSON : JSON) {
        let pageid = descriptionJSON["query"]["pageids"][0].stringValue
        let description = descriptionJSON["query"]["pages"]["\(pageid)"]["extract"].stringValue
        if description.count == 0 {
            errorGettingAPIResults()
        }
        let descriptionSplit = description.components(separatedBy: ".")
        descriptionBody.numberOfLines = 0
        if descriptionSplit.count < 2 {
            descriptionBody.text = ("\(descriptionSplit[0])" + ".")

        } else {
            descriptionBody.text = ("\(descriptionSplit[0])" + "." + "\(descriptionSplit[1])" + ".")
        }
        descriptionBody.sizeToFit()
    }

}

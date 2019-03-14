//
//  FoodViewController.swift
//  Snapfood
//
//  Created by Govi Ravindran on 2018-12-24.
//  Copyright © 2018 Rohan Ravindran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class FoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var indexPathGlobal : Int?
    var classifiedObjectImage : UIImage?
    var classifiedObjectName : String?
    let basePath = "https://api.edamam.com/search"
    let cellTitleArray = ["Recipe", "Nutrition", "Description"]
    let cellDiscriptionArray = ["Ingredients, Recipe Links, and More!", "Calories, Vitamins and Nutrients, and More!", "Find out about the food searched!"]
    let cellPicNameArray = ["recipe", "nutrition", "info-flat-1"]
    let cellSegueIdentifierArray = ["goToNutritionOrRecipe", "goToNutritionOrRecipe", "goToDescriptionController"]
    
    
    
    
    var foodJSON : JSON?
    var onlineImageLink : String?
    
    @IBOutlet weak var foodView: UIImageView!
    @IBOutlet weak var tableViewCellU: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parameters : [String : String] = ["q" : classifiedObjectName!, "app_id" : "41b9dfb1", "app_key" : "9a736fb5e5b11365a977c5868760e1ff", "from" : "0", "to" : "1", "recipe" : ""]
        
        getFoodData(url: basePath, params: parameters)
        
        navigationItem.title = classifiedObjectName?.capitalized
        foodView.layer.cornerRadius = 20
        foodView.clipsToBounds = true
        print("new")

        
        if classifiedObjectImage != nil {
            foodView.image = classifiedObjectImage
        }
        
        tableViewCellU.delegate = self
        
            print(tableViewCellU.frame.height)
        
        tableViewCellU.rowHeight = ((tableViewCellU.frame.height) / 3)
        
        tableViewCellU.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCellUnder")
        tableViewCellU.allowsSelection = false
    }
    
    
    
    func getFoodData(url : String, params : [String : String]) {
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                print("Got the food data")
                self.foodJSON = JSON(response.result.value!)
                print(self.foodJSON!["count"].intValue)
                    if (self.foodJSON!["count"].intValue) == 0 {
                        self.errorGettingAPIResults()
                }
                self.parseOnlineImage(foodImageJSON: self.foodJSON!) { (success) -> Void in
                    if success == true {
                        self.tableViewCellU.allowsSelection = true
                    }
                }
            } else {
                print("error getting food data: \(response.error!)")
                self.foodJSON = JSON() //provide warning for user
                self.errorGettingAPIResults()
            }
        }
        
    }
    
    func errorGettingAPIResults() {
        let alert = UIAlertController(title: "Error", message: "There was an error getting results from the server, please make sure you spelled everything correctly.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            print("error")
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func parseOnlineImage(foodImageJSON : JSON, completion: (_ success: Bool) -> Void) {
        if (foodImageJSON["count"].intValue != 0) {
            onlineImageLink = foodImageJSON["hits"][0]["recipe"]["image"].stringValue
            if foodView.image == nil {
                foodView.sd_setImage(with: URL(string: onlineImageLink!), completed: nil)
                
                let url = URL(string: onlineImageLink!)
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            let image: UIImage = UIImage(data: data)!
                            self.classifiedObjectImage = image
                        }
                    }
                }
            }
        }
        completion(true)
    }
    
    func parseJSON(foodJSON : JSON) -> (Array<JSON>, String, JSON, Array<JSON>) {
        
        guard let ingredients : Array<JSON> = foodJSON["hits"][0]["recipe"]["ingredientLines"].array else {
            fatalError("Error getting ingredients array from JSON")
        }
        guard let recipeLink : String = foodJSON["hits"][0]["recipe"]["url"].stringValue else {
            fatalError("Error getting recipeLink from JSON")
        }
        guard let nutritionalInfoArray : JSON = foodJSON["hits"][0]["recipe"]["totalNutrients"] else {
            fatalError("Error getting nutritional info from JSON")
        }
        guard let healthLabelArray : Array<JSON> = foodJSON["hits"][0]["recipe"]["healthLabels"].array else {
            fatalError("Error getting nutritional info from JSON")
        }
        return (ingredients, recipeLink, nutritionalInfoArray, healthLabelArray)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellUnder", for: indexPath) as! CustomCell
        cell.title.text = cellTitleArray[indexPath.row]
        cell.underTitleDescription.text = cellDiscriptionArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.imageViewDescriptor.image = UIImage(named: cellPicNameArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathGlobal = indexPath.row
        performSegue(withIdentifier: "\(cellSegueIdentifierArray[indexPath.row])", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if indexPathGlobal == 0 {
            print("recipe button")
            let additionalInfoVC = segue.destination as! AdditionalInfoController
            var ingredients : Array<JSON> = []
            var recipeLink : String = ""
            (ingredients, recipeLink, _, _) = parseJSON(foodJSON: foodJSON ?? JSON()) //provide a safer alternative to force unwrapping
            additionalInfoVC.ingredientsText = ingredients
            additionalInfoVC.recipeLinkText = recipeLink
            additionalInfoVC.recipeButtonClicked = true
            additionalInfoVC.classifiedObjectTitle = classifiedObjectName!
            
        } else if indexPathGlobal == 1 {
            print("Nutrition button")
            let additionalInfoVC = segue.destination as! AdditionalInfoController
            additionalInfoVC.recipeButtonClicked = false
            var nutritionalInfoArray : JSON = JSON()
            var healthLabelArray : Array<JSON> = []
            (_, _, nutritionalInfoArray, healthLabelArray) = parseJSON(foodJSON: foodJSON ?? JSON())
            additionalInfoVC.classifiedObjectTitle = classifiedObjectName!
            additionalInfoVC.nutritionalInfoJSON = nutritionalInfoArray
            additionalInfoVC.healthLabelArray = healthLabelArray
        } else {
            print("description button")
            let descriptionVC = segue.destination as! DescriptionViewController
            descriptionVC.foodPic = classifiedObjectImage!
            descriptionVC.foodName = classifiedObjectName!
        }
    }
    

}

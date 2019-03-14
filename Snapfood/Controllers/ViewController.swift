//
//  ViewController.swift
//  Snapfood
//
//  Created by Govi Ravindran on 2018-12-24.
//  Copyright © 2018 Rohan Ravindran. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ChameleonFramework

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    //let realm = try! Realm()
    let imagePicker = UIImagePickerController()
    var predictedItem = ""
    var imageBeingClassified : UIImage?
    var image : UIImage?
    var searchBarText : String?
    
    
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        cameraButtonOutlet.layer.cornerRadius = 20
        searchButtonOutlet.layer.cornerRadius = 20
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(hexString: "E74A4A")
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        present(imagePicker,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //do prediction
        //send data over to another view controller
        //do alamofire stuff
        

        if let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = userPickedimage
            guard let ciimage = CIImage(image: userPickedimage) else {
                fatalError("Can't convert to CIImage.")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image : CIImage) {
        guard let model = try? VNCoreMLModel(for: FoodClassifierAugmented().model) else {
            fatalError("Could not convert model into VNCoreMLModel.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            let results = request.results as? [VNClassificationObservation]
            
            if let firstResult = results?.first {
                
                self.predictedItem = firstResult.identifier
                self.predictedItem = (self.predictedItem.replacingOccurrences(of: "_", with: " ")).capitalized
                print(self.predictedItem)
                self.imageBeingClassified = UIImage(ciImage: image)
                print("Segue performed")
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "goToDepthFood", sender: self)
                }
                print("Segue performed after")
                //self.navigationItem.title = firstResult.identifier
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try! handler.perform([request])
        } catch {
            print("Error performing image classification request: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDepthFood" {
            
            let foodVC = segue.destination as! FoodViewController
            
            foodVC.classifiedObjectName = predictedItem
            foodVC.classifiedObjectImage = imageBeingClassified
            
//            let newRecentObject = Recent()
//            newRecentObject.recentFoodName = self.predictedItem
//            newRecentObject.recentFoodPicture = self.image!.pngData()
//            self.saveRecent(recentCategory: newRecentObject)
        }
        
        if segue.identifier == "goToDepthFromSearch" {
            let foodVC = segue.destination as! FoodViewController
            
            foodVC.classifiedObjectName = searchBarText!.capitalized
            foodVC.classifiedObjectImage = nil
        }
        

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarText = searchBar.text
        searchBar.text = ""
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        searchBar.setShowsCancelButton(false, animated: true)
        performSegue(withIdentifier: "goToDepthFromSearch", sender: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

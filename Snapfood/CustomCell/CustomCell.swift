//
//  CustomCell.swift
//  Snapfood
//
//  Created by Rohan Ravindran  on 2018-12-26.
//  Copyright © 2018 Rohan Ravindran. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var imageViewDescriptor: UIImageView!
    
    @IBOutlet weak var underTitleDescription: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageViewDescriptor.layer.cornerRadius = 20
        imageViewDescriptor.clipsToBounds = true
        underTitleDescription.numberOfLines = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

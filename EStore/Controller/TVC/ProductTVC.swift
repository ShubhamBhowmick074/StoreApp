//
//  ProductTVC.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import UIKit

class ProductTVC: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

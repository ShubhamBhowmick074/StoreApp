//
//  ProductListingVC.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import UIKit

class ProductListingVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tblVwProducts: UITableView!
    
    //MARK: Properties
    var viewModel = ProductListingVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        hitApiProductList()
    }

}


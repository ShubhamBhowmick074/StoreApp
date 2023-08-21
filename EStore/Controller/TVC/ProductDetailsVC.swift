//
//  ProductDetailsVC.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import UIKit
import SDWebImage
class ProductDetailsVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    
    //MARK: Properties
    var viewModel = ProductDetailsVM()

    
    //MARK: LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: Functions
    func setData(){
        let data = viewModel.productData
        imgVwProduct.sd_setImage(with: URL(string: data?.image ?? ""), placeholderImage: nil)
        lblTitle.text = data?.title ?? ""
        lblDesc.text = data?.description ?? ""
        lblPrice.text = "Price : $\(data?.price ?? 0)"
        lblCategory.text = data?.category ?? ""
    }

}

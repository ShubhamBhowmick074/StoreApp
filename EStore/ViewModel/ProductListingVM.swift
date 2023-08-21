//
//  ProductListingVM.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import UIKit
import SDWebImage

class ProductListingVM{
    
    //MARK: Properties
    var arrProductsList : ProductsDataModelList?
    var apiService = GetFeaturedApiServices()
    
    //MARK: Api Calling
    
    func getDataFromProductApi(completion : @escaping ApiResponseCompletion){
        apiService.getProductList { result in
            switch result{
            case .success(let response):
                guard let data = response.resultData as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: LocalizedStringEnum.somethingWentWrong.localized)))
                    return
                }
                //Converting api Data response to respective response model.
                self.arrProductsList = JSONDecoder().convertDataToModel(data)
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//MARK: API Call
extension ProductListingVC{
    
    func hitApiProductList(){
        CustomLoader.shared.show()
        viewModel.getDataFromProductApi { result in
            CustomLoader.shared.hide()
            switch result{
            case.success(_):
                DispatchQueue.main.async {
                    self.tblVwProducts.reloadData()
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}

//MARK: TableView Delegate and DataSource
extension ProductListingVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrProductsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTVC") as! ProductTVC
        let data = viewModel.arrProductsList?[indexPath.row]
        cell.imgVwProduct.sd_setImage(with: URL(string: data?.image ?? ""), placeholderImage: nil)
        cell.lblTitle.text = data?.title ?? ""
        cell.lblPrice.text = "$\(data?.price ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.viewModel.productData = viewModel.arrProductsList?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

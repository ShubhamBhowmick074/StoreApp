//
//  GetApiServices.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import Foundation
fileprivate enum GetFeaturedApiServicesEndPoints: APIService {
    //Define cases according to API's
    case getProductList

  
    //Return path according to api case
    var path: String {
        switch self {
        case .getProductList:
            return "https://fakestoreapi.com/products"

        }
    }
    
    //Return resource according to api case
    var resource: Resource {
        let headers: [String: Any] = [
            "Content-Type": "application/json"
        ]
    
        switch self {
        case .getProductList :
            return Resource(method: .get, parameters: nil, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
     

        }
    }
    
}

struct GetFeaturedApiServices {
    
    func getProductList( completionBlock: @escaping ApiResponseCompletion) {
        GetFeaturedApiServicesEndPoints.getProductList.urlRequest(completionBlock: completionBlock)
    }
    
  
  
}

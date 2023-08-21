//
//  ProductsDataModel.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import Foundation

struct ApiResponseSuccessBlock{
    var message: String
    var statusCode: Int
    var resultData: Any?
}

struct ApiResponseErrorBlock: Error {
    var message: String
  //  var statusCode: String
}

typealias ApiResponseCompletion = ((Result<ApiResponseSuccessBlock, ApiResponseErrorBlock>) -> ())


protocol APIResultValidatorApi{
    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion)
    func getApiError(result:String?) -> ApiResponseErrorBlock
    func getApiResponse(result:Any?, statusCode: Int) -> ApiResponseSuccessBlock
}

extension APIResultValidatorApi{
    
    func getApiError(result:String?) -> ApiResponseErrorBlock{
        let apiError = ApiResponseErrorBlock.init(message: result ?? "Error description not available")
        return apiError
    }
    
    func getApiResponse(result:Any?, statusCode: Int) -> ApiResponseSuccessBlock{
        var apiResponse = ApiResponseSuccessBlock.init(message: "", statusCode: statusCode, resultData: result)
        if let responseDict = result as? [String:AnyObject] {
            
            if let msg = responseDict["msg"] as? String {
                apiResponse.message = msg
            }

            apiResponse.resultData = responseDict as Any
        }
        return apiResponse
    }
}


struct APIDataResultValidator: APIResultValidatorApi {
    
    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion) {
        
        var jsonResponse: [[String: Any]]?
        if let data = response as? Data {
            do {
                jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
                debugPrint("API response is: ", jsonResponse ?? [[:]])
                var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
                apiResponse.resultData = response
                completionBlock(.success(apiResponse))
            }catch {
                debugPrint("Error converting data to JSON: ", error.localizedDescription)
                completionBlock(.failure(self.getApiError(result: "Error converting data to JSON: ")))
            }
        }
        
       
    }
    
}

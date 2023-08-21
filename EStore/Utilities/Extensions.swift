//
//  Extensions.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import UIKit

//Methods for UIApplication
extension UIApplication {
    var appWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = delegate.window else { return nil }
            return window
        } else {
            // Fallback on earlier versions
            guard let delegate = UIApplication.shared.delegate else { return nil }
            return delegate.window ?? nil
        }
        
    }
}
extension JSONEncoder {
    
    ///This method will convert the Codable type model(T) to return type(U).
    ///Usage => let dict: [String: Any] = JSONEncoder().convertToDictionary(model)
    ///Parameter and return type both are generic
    func convertToDictionary<T: Encodable, U>(_ model: T) -> U? {
        do {
            let data = try JSONEncoder().encode(model)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? U
            return dictionary
        }catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func convertToData<T: Encodable>(_ model: T) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(model)
    }
}

extension JSONDecoder {
    func convertDataToModel<T: Decodable>(_ data: Data) -> T? {
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        }catch {
            debugPrint(error)
            return nil
        }
    }
}

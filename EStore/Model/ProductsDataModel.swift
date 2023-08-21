//
//  ProductsDataModel.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import Foundation

// MARK: - ProductsDataModelElement
struct ProductsDataModel: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let description: String?
    let category: String?
    let image: String?
    let rating: Rating?
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double?
    let count: Int?
}

typealias ProductsDataModelList = [ProductsDataModel]

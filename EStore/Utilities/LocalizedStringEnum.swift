//
//  LocalizedStringEnum.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import Foundation
enum LocalizedStringEnum:String {
    case appName
    case networkNotReachable
    case somethingWentWrong
    case sessionExpired
    

    var localized: String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}

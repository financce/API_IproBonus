//
//  RequestModel.swift
//  AppExample
//
//  Created by slava on 26/04/2021.
//

import Foundation


struct RequestModel: Codable  {
    let idClient, accessToken, paramName, paramValue: String
    let latitude, longitude, sourceQuery: Int
}

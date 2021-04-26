//
//  GetModel.swift
//  AppExample
//
//  Created by slava on 26/04/2021.
//

import Foundation

 struct GetModel: Codable {
    let resultOperation: ResultOperation
    let data: DataClass
}

 struct DataClass: Codable {
    let typeBonusName: String
    let currentQuantity, forBurningQuantity: Int
    let dateBurning: String
}

 struct ResultOperation: Codable {
    let status: Int
    let message, messageDev: String?
    let codeResult, duration: Int
    let idLog: String
}


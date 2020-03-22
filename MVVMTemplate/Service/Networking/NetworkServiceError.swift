//
//  NetworkServiceError.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 27/02/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

enum NetworkServiceError: Error {

    case noData
    case wrongResponse
    case wrongStatusCode(statusCode: Int)
}

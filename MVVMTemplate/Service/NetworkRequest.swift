//
//  Endpoint.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 27/02/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import Foundation

/**
 Príklad, ako ošetriť rôzne url v aplikácii.

 V case searchExample nevytvárame skutočnú url, je to len na ukázanie, ako sa
 dá enum `Endpoint` jednoducho rozšíriť na používanie url s parametrami.
 */
enum NetworkRequest {

    case ipAdress
    case searchExample(search: String)

    var request: URLRequest {
        switch self {
        case .ipAdress:
            return URLRequest.initFromUrlString("https://api.ipify.org?format=json")
        case let .searchExample(search: searchText):
            return URLRequest.initFromUrlString("https://www.example.com?search=\(searchText)")
        }
    }
}

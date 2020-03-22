//
//  NetworkServiceFactory.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 22/03/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import Foundation

/**
 Vytvorí instanciu `NetworkServiceProtocol`.

 Na odstienenie, akú triedu hľadáme, pracujeme čo najviac s nejakou abstrakciou,
 v tomto prípapade užívateľovi vraciame struct `NetworkService`, ktorý ale v
 budúcnosti môžeme nahradiť napr. triedou, ak by sme potrebovali využiť stored propeties,
 OperationQueue atď bez toho, aby sme museli v celej aplikácii meniť konkrétnu triedu.
*/
enum NetworkServiceFactory {

    static func makeNetworkService() -> NetworkServiceProtocol {
        return NetworkService()
    }
}

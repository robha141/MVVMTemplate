//
//  URLRequest+Extension.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 22/03/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import Foundation

extension URLRequest {

    /**
     Vytvorí urlRequest na základe zadaného url stringu.

     Funkcia obsahuje `precondition`, keď string nie je URL. V reálnej
     aplikácii bude lepšie vraciať optional alebo vyhodiť výnimku.

     - parameters:
        - string: url vo formáte string.
     - returns: urlrequest (napr. pre pre networkservice).
    */
    static func initFromUrlString(_ string: String) -> URLRequest {
        guard let url = URL(string: string) else {
            preconditionFailure("💥 Wrong url format \(string)")
        }
        return URLRequest(url: url)
    }
}

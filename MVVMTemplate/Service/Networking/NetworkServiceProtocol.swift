//
//  NetworkServiceProtocol.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 27/02/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import Foundation

/**
 Service, s ktorým budeme získavať dáta pre view model.

 Používame protocol preto, lebo pri testoch ho budeme nahradzovať takzvaným `Mock` protocolom,
 v ktorom si implementujeme funkcie tak, aby nám vrátil požadované dáta na základe ktorých budeme
 ďalej testovať funkcionalitu.
 */
protocol NetworkServiceProtocol {

    /**
     Na základe parametru request sa nám zavolá closure `onError` alebo `onSuccess`.

     Parametrom escaping sa moc netrápte, pre jednoduchosť, keď uvidíte closure, použite
     tam **vždy** `weak self`, aby ste ho v tej closure takzvne ne-`capture`-ovali
     (to slovo som znásilnil, ale ide o princíp, keby to chcete vyhľadávať a čítať si o tom viac 😀).
     */
    func getData(
        from request: URLRequest,
        returnQueue: DispatchQueue,
        onSuccess: @escaping (Data) -> Void,
        onError: @escaping (Error) -> Void
    )

    /// Convience funkcia, ktorá ako parameter berie  `NetworkRequest`.
    func getData(
        from request: NetworkRequest,
        returnQueue: DispatchQueue,
        onSuccess: @escaping (Data) -> Void,
        onError: @escaping (Error) -> Void
    )

    /**
    Na základe parametru request sa nám zavolá closure `onError` alebo `onSuccess`.

    V tomto nám v `onSucces` príde rovno dekódovaný model.
    */
    func getData<TDecodable: Decodable>(
        from request: URLRequest,
        decodedType: TDecodable.Type,
        returnQueue: DispatchQueue,
        onSuccess: @escaping (TDecodable) -> Void,
        onError: @escaping (Error) -> Void
    )

    /// Convience funkcia, ktorá ako parameter berie  `NetworkRequest`.
    func getData<TDecodable: Decodable>(
        from request: NetworkRequest,
        decodedType: TDecodable.Type,
        returnQueue: DispatchQueue,
        onSuccess: @escaping (TDecodable) -> Void,
        onError: @escaping (Error) -> Void
    )
}

extension NetworkServiceProtocol {

    func getData(
        from request: URLRequest,
        returnQueue: DispatchQueue,
        onSuccess: @escaping (Data) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        URLSession.shared.dataTask(
            with: request,
            completionHandler: { data, response, error in
                // Najprv skontrolujeme, či sa nám vo výsledku vrátila chyba, ak hej,
                // vrátime ju v closure `onError`.
                if let error = error {
                    returnQueue.async {
                        onError(error)
                    }
                }
                // Skúsime pretypovať (downcasting) respone na HTTPURLResponse
                // Ak to nevýjde, taktiež zavoláme closure onError ale tentokrát
                // ako argument použijeme náš vlastný response.
                // Hint: po return statemente môžeme použiť funkciu ktorá
                // má návratový typ void alebo napr. priraďovací statement.
                guard let response = response as? HTTPURLResponse else {
                    returnQueue.async {
                        onError(NetworkServiceError.wrongResponse)
                    }
                    return
                }
                let statusCode = response.statusCode
                // Operátor ~= slúži na zistenie, či sa hodnota nachádza v
                // danom intervale.
                guard 200 ..< 300 ~= statusCode else {
                    returnQueue.async {
                        onError(NetworkServiceError.wrongStatusCode(statusCode: statusCode))
                    }
                    return
                }
                // ⚠️ musíme sa uistiť, že vo všetkých častiach voláme nejakú closure.
                guard let data = data else {
                    returnQueue.async {
                        onError(NetworkServiceError.noData)
                    }
                    return
                }
                returnQueue.async {
                    onSuccess(data)
                }
            }
        )
        .resume()
    }

    func getData(
        from request: NetworkRequest,
        returnQueue: DispatchQueue,
        onSuccess: @escaping (Data) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        getData(
            from: request.request,
            returnQueue: returnQueue,
            onSuccess: onSuccess,
            onError: onError
        )
    }

    func getData<TDecodable: Decodable>(
        from request: URLRequest,
        decodedType: TDecodable.Type,
        returnQueue: DispatchQueue,
        onSuccess: @escaping (TDecodable) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        // Zavoláme už implementovanú funkciu `getData` a v closure `onSuccess`
        // implementujeme parsovanie
        getData(
            from: request,
            returnQueue: DispatchQueue.global(qos: .userInteractive),
            onSuccess: { data in
                do {
                    let decoder = JSONDecoder()
                    let decodedItems = try decoder.decode(
                        TDecodable.self,
                        from: data
                    )
                    returnQueue.async {
                        onSuccess(decodedItems)
                    }
                } catch {
                    // V do catch mám automatický syntetizovaný parameter error,
                    // ak chcem ošetriť špecifický, môžem mať niekoľko catch statementov.
                    // https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html
                    returnQueue.async {
                        onError(error)
                    }
                }
            },
            onError: { error in
                returnQueue.async {
                    onError(error)
                }
            }
        )
    }

    func getData<TDecodable: Decodable>(
        from request: NetworkRequest,
        decodedType: TDecodable.Type,
        returnQueue: DispatchQueue,
        onSuccess: @escaping (TDecodable) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        getData(
            from: request.request,
            decodedType: decodedType,
            returnQueue: returnQueue,
            onSuccess: onSuccess,
            onError: onError
        )
    }
}

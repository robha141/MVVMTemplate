//
//  IPAdressViewModel.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 27/02/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import Foundation

/// Na updatovanie controlleru použijeme delegate pattern.
protocol IPAdressViewModelDelegate: class {

    func iPAdressViewModelTextUpdated(_ iPAdressViewModel: IPAdressViewModel)
}

private enum IPAdressViewModelState {

    case errorReceived(message: String)
    case hasAdress(adress: String)
    case loading
}

final class IPAdressViewModel {

    // MARK: - properties

    private weak var delegate: IPAdressViewModelDelegate?
    private let networkService: NetworkServiceProtocol
    private var state: IPAdressViewModelState = .loading {
        didSet { delegate?.iPAdressViewModelTextUpdated(self) }
    }

    // MARK: - output

    /**
     Text globálnej IP adresy.

     Na základe hodnoty v premennej state updatujeme text.
     Toto nie je univerzálne riešenie, v zložitejších aplikáciach
     bude viacero hodnôt ako napr. `isLoading: Bool`, na základe ktorých
     sa budeme rozhodovať, či zapneme `UIActivityIndicator` alebo
     inú formu načitavania.
    */
    var ipAdressText: String {
        switch state {
        case let .hasAdress(adress: address):
            return "Your global IP adress is\n\(address)"
        case let .errorReceived(message: message):
            return "💥 \(message) 💥\nPlease, try again!"
        case .loading:
            return "Loading IP adress ..."
        }
    }

    // MARK: - init

    init(
        networkService: NetworkServiceProtocol,
        delegate: IPAdressViewModelDelegate
    ) {
        self.networkService = networkService
        self.delegate = delegate
    }

    // MARK: - input

    func refresh() {
        state = .loading
        networkService.getData(
            from: NetworkRequest.ipAdress,
            decodedType: IPAdress.self,
            returnQueue: .main,
            // Ako som spomínal, `onSuccess` a `onError` sú escaping closure,
            // takže aby sme zabránili memory leakom, použijeme weak self.
            // Viac info v https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
            onSuccess: { [weak self] adress in
                self?.state = .hasAdress(adress: adress.ip)
            },
            // Nechceme užívateľovi dať vedieť každý jeden error, ktorý
            // sa mohol vyskytnúť, pre zjednodušenie používam nejaký generický
            // message. Takéto chyby si potom môžeme logovať interne napr.
            // pomocou `Firebase` a rýchlo na ne reagovať a opravovať ich
            onError: { [weak self] error in
                print("Error getting ip adress: \(error)")
                self?.state = .errorReceived(message: "Opps, something went wrong")
            }
        )
    }
}

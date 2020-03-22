//
//  Coordinator.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 22/03/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import UIKit

/**
 Trieda slúžiaca na navigačnú logiku.

 Navigácia sa nebude riešiť na úrovni view controllerov,
 bude ju mať nastarosti táto trieda. V prípade apky
 FamilyPoint a pre vás ako začiatočníkov navrhujem len
 jeden coordinator pre celú apku.
 View controller komunikuje s apkou pomocou closures / delegate patternu,
 implementácia je na vás, ale vybral by som jednu a tej sa držal.
 (podľa mňa jednoduhšie pre vás bude použitie delegate patternu).
*/
final class Coordinator {

    // MARK: - Properties

    private let window: UIWindow

    // MARK: - Init

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let controller = IPAdressViewControllerFactory.makeIPAdressController()
        // Stojí za porozmýšlanie, ako chcem injectovať coordinaor
        // do view controlleru
        controller.delegate = self
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}

extension Coordinator: IPAdressViewControllerDelegate {

    func ipAdressViewController(_ ipAdressViewController: IPAdressViewController) {
        // Ak mám nejakú časť v projekte, ktorú momentálne nebudem implementovať
        // a môžem to odložiť na neskôr, tak môžem využiť compiler flag #warning či #error
        // aby som si pripomenul, čo treba spraviť alebo kde som skončil v implementácii.
        #warning("TODO: - not implemented")
    }
}

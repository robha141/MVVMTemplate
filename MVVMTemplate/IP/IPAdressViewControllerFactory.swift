//
//  IPAdressViewControllerFactory.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 27/02/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import UIKit

/**
 View controllery budeme vytvárať manuálne.

 V prípade, že controller potrebuje parametre od predchádzajúceho, jednoducho ich dáme
 do parametru funkcie. Ak sa v istom bode implementáci rozhodneme opustit storyboardy,
 stačí zmeniť implementácie factory fukcii a všetko bude fungovať ako pred tým.
 */
enum IPAdressViewControllerFactory {

    static func makeIPAdressController() -> IPAdressViewController {
        let controller = IPAdressViewController.initializeFromStoryboard()
        let viewModel = IPAdressViewModel(
            networkService: NetworkServiceFactory.makeNetworkService(),
            delegate: controller
        )
        controller.viewModel = viewModel
        return controller
    }
}

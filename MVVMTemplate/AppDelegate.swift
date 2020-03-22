//
//  AppDelegate.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 27/02/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Instanciu musíme mať niekde uloženú, inak by ju ARC odstránil.
    var coordinator: Coordinator?

    // V projekte > General sme vymazali Main interface a vytvárame ho ručne.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = Coordinator(window: window)
        coordinator?.start()
        return true
    }
}


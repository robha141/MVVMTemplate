//
//  StoryboardInitializable.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 22/03/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import UIKit

/**
 Protocol, ktorý pomôže s inicializáciou zo storyboardu.

 Na splnenie protokolu stačí implementovať statickú property `storyboardName`,
 na základe ktorej bude mať UIViewController 2 syntetizované funkcie na jeho inicializáciu.
*/
protocol StoryboardInitializable {

    static var storyboardName: String { get }
}

extension StoryboardInitializable where Self: UIViewController {

    static func initializeFromStoryboard() -> Self {
        let controller = storyboard.instantiateInitialViewController() as? Self
        guard let unwrappedController = controller else {
            preconditionFailure("Initial controller in \(storyboardName) is not \(Self.self)")
        }
        return unwrappedController
    }

    static func initializeFromStoryboard(with controllerId: String) -> Self {
        let controller = storyboard.instantiateViewController(identifier: controllerId) as? Self
        guard let unwrappedController = controller else {
            preconditionFailure("Controller with id \(controllerId) is not in \(storyboardName)")
        }
        return unwrappedController
    }

    private static var storyboard: UIStoryboard {
        return UIStoryboard(
            name: Self.storyboardName,
            bundle: nil
        )
    }
}

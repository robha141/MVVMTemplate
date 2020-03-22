//
//  IPAdressViewController.swift
//  MVVMTemplate
//
//  Created by Róbert Oravec on 27/02/2020.
//  Copyright © 2020 Robo. All rights reserved.
//

import UIKit

/**
 Protokol na komunikáciou s coordinatorom.

 Aj keď je tu len na ukážku, v princípe by mal takto controller komunikovať s Coordinatorom
 (on nevie, že akurát coordinator implementuje delegate protocol, môže to byť hocičo iné).
 Tu ideme trochu proti MVVM patternu, kedy by mal na všetky imputy reagovať
 view model, ale keďže UIKit je postavený na MVC architektúre, musíme si
 aj to MVVM trochu pozmeniť, aby sa s ním lepšie pracovalo. Táto architektúra
 sa konkrétne nazýva MVVM-C, na medium je o nej dosť článkov.
 ⚠️ nikde nenájdete presne, ako sa má táto architektúra implementovať. Je dobré
 myslieť na rozsah projektu a na základe toho zvoliť implementačné technológie.
*/
protocol IPAdressViewControllerDelegate: class {

    func ipAdressViewController(_ ipAdressViewController: IPAdressViewController)
}

final class IPAdressViewController: UIViewController,
    StoryboardInitializable {

    // MARK: - StoryboardInitializable

    // V prípade používania R.swift môžeme použiť
    // https://github.com/mac-cain13/R.swift/blob/master/Documentation/Examples.md#storyboards
    static let storyboardName: String = "IP"

    // MARK: - properties

    var viewModel: IPAdressViewModel!
    weak var delegate: IPAdressViewControllerDelegate?

    // MARK: - outlets

    @IBOutlet weak var iPAdressLabel: UILabel!

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Force unwrapovať budeme len s rozumom a vždy keď to robíme,
        // tak by sme mali nejako dať aj iným developerom najavo, čo
        // sa stalo, keby zabudli injectovať view model.
        // V tomto prípade je view model force unwrapnutý z dôvodu,
        // že nemôžeme použiť constructor base dependency injection,
        // lebo controller inicializujeme cez storyboard.
        precondition(
            viewModel != nil,
            "View model should be injected at this point in time"
        )
        viewModel.refresh()
    }

    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        viewModel.refresh()
    }
}

extension IPAdressViewController: IPAdressViewModelDelegate {

    func iPAdressViewModelTextUpdated(_ iPAdressViewModel: IPAdressViewModel) {
        iPAdressLabel.text = iPAdressViewModel.ipAdressText
    }
}

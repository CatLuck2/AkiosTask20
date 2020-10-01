//
//  AddOrEditViewController.swift
//  AkiosTask20
//
//  Created by Nekokichi on 2020/09/30.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet private weak var itemNameTextField: UITextField!

    private(set) var betaItemName: String!

    @IBAction private func addItemButton(_ sender: UIBarButtonItem) {
        betaItemName = itemNameTextField.text ?? ""
        performSegue(withIdentifier: IdentifierType.segueFromAddID, sender: nil)
    }

    @IBAction private func backBUtton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

//
//  EditItemViewController.swift
//  AkiosTask20
//
//  Created by Nekokichi on 2020/10/01.
//

import UIKit

class EditItemViewController: UIViewController {

    @IBOutlet private weak var itemNameTextField: UITextField!

    var selectedItemName: String!
    var selectedIndexPathRow: Int!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemNameTextField.text = selectedItemName
    }

    @IBAction private func editItemButton(_ sender: UIBarButtonItem) {
        selectedItemName = itemNameTextField.text ?? ""
        performSegue(withIdentifier: IdentifierType.segueFromEditID, sender: nil)
    }

    @IBAction private func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

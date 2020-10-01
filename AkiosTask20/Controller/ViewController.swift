//
//  ViewController.swift
//  AkiosTask20
//
//  Created by Nekokichi on 2020/09/29.
//
/*
 遭遇したエラー
 ・An NSManagedObject of class 'CheckItem' must have a valid NSEntityDescription.
 ・error: Multiple commands produce '/Users/fuji_yosu/Library/Developer/Xcode/DerivedData/AkiosTask20-dzusgwtsccnqefbwoxyzjvrxxcus/Build/Intermediates.noindex/AkiosTask20.build/Debug-iphonesimulator/AkiosTask20.build/Objects-normal/x86_64/CheckItem+CoreDataProperties.o':
 1) Target 'AkiosTask20' (project 'AkiosTask20') has compile command for Swift source files
 2) Target 'AkiosTask20' (project 'AkiosTask20') has compile command for Swift source files
 ・nil is not a legal NSManagedObjectContext parameter searching for entity name 'CheckItem'
 https:teratail.com/questions/145548
 */

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet private weak var checkListTableView: UITableView!

    private var checkList: [CheckItem] = []
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkListTableView.delegate = self
        checkListTableView.dataSource = self
    }

    @IBAction private func unwindToVC(_ unwindSegue: UIStoryboardSegue) {
        switch unwindSegue.identifier {
        case IdentifierType.segueFromAddID:
            let addItemVC = unwindSegue.source as! AddItemViewController
            let newCheckItem = CheckItem(context: self.coreDataContext)
            newCheckItem.name = addItemVC.betaItemName
            newCheckItem.isChecked = false
            checkList.append(newCheckItem)
            saveData()
            fetchData()
        case IdentifierType.segueFromEditID:
            let editItemVC = unwindSegue.source as! EditItemViewController
            checkList[editItemVC.selectedIndexPathRow].name = editItemVC.selectedItemName
            saveData()
            fetchData()
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifierType.segueToEditID {
            guard let nvc = segue.destination as? UINavigationController else {
                return
            }
            guard let editItemVC = nvc.viewControllers[0] as? EditItemViewController else {
                return
            }
            guard let indexpathrow = sender as? Int else {
                return
            }
            editItemVC.selectedIndexPathRow = indexpathrow
            editItemVC.selectedItemName = checkList[indexpathrow].name ?? ""
        }
    }

    // CoreDataからチェックリストを取得
    private func fetchData() {
        do {
            checkList = try coreDataContext.fetch(CheckItem.fetchRequest())
            DispatchQueue.main.async {
                self.checkListTableView.reloadData()
            }
        } catch {
            print("Failed to read")
        }
    }

    // CoreDataにチェックリストを保存
    private func saveData() {
        do {
            try self.coreDataContext.save()
        } catch {
            print("Failed to save")
        }
    }

}

class CheckListTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkItemImage: UIImageView!
    @IBOutlet private weak var checkItemName: UILabel!

    fileprivate func configureCell(isChecked: Bool, name: String) {
        if isChecked {
            checkItemImage.image = UIImage(systemName: IdentifierType.itemImageID)
        } else {
            checkItemImage.image = nil
        }
        checkItemName.text = name
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellID) as! CheckListTableViewCell
        cell.configureCell(isChecked: checkList[indexPath.row].isChecked, name: checkList[indexPath.row].name ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkList[indexPath.row].isChecked.toggle()
        checkListTableView.reloadRows(at: [indexPath], with: .automatic)
        saveData()
        fetchData()
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: IdentifierType.segueToEditID, sender: indexPath.row)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemForDeletion = checkList[indexPath.row]
            coreDataContext.delete(itemForDeletion)
            saveData()
            fetchData()
        }
    }
}

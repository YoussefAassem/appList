//
//  ViewController.swift
//  appList
//
//  Created by AASSEM Youssef on 11/18/19.
//  Copyright © 2019 YoussefPersonal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var names: [String] = []
    var peoples: [NSManagedObject] = []
    let cellName: String = "Cell"
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
           peoples = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellName)
    }
    
    @IBAction func addName(_ sender: Any) {
      let alert = UIAlertController(title: "New name", message: "Add new name", preferredStyle: .alert)
      let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let name = textField.text else {
                    print("No name has been added")
                    return
            }
            self.save(name: name)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: "name")

        do {
            try managedContext.save()
            peoples.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName,for: indexPath)
        let person = peoples[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }


}


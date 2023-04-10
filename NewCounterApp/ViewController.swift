//
//  ViewController.swift
//  NewCounterApp
//
//  Created by Pavel on 10.04.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var isEditingClicked = false
    var counts: [CountModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .updateData, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.updateData()
        }
        
        updateData()
    }
    
    func updateData() {
        guard let newCounts = FactoryStorage.getCounts() else {
            return
        }
        counts = newCounts
    }
    @IBAction func addCount(_ sender: UIButton) {
        let alert = UIAlertController(title: "Create Count", message: "Enter a text", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let count = CountModel()
            count.title = (textField?.text)!
            FactoryStorage.addCount(count)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if !isEditingClicked {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            isEditingClicked = true
        } else {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            isEditingClicked = false
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if counts.isEmpty {
            let label = UILabel()
            label.text = "No Counts"
            label.textColor = .white
            label.textAlignment = .center
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return counts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.countCell) else {
            return UITableViewCell()
        }
        
        let count = counts[indexPath.section]
        
        cell.textLabel?.text = count.title
        cell.detailTextLabel?.text = "\(count.count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = counts[indexPath.section]
        
        try? FactoryStorage.realm.write({
            count.count += 1
            tableView.reloadData()
        })
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        FactoryStorage.deleteCount(counts[indexPath.section])
    }
}

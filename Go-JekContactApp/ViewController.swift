//
//  ViewController.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel = HomeContactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact"
        
        view.accessibilityIdentifier = "contactHomePage"
        tableView.accessibilityIdentifier = "homeTableId"
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "add"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        tableView.tableFooterView = footerView
        
        tableView.register(UINib.init(nibName: "HomeContactCell", bundle: nil), forCellReuseIdentifier: TableConstants.tableViewCellID)
        
        tableView.tableHeaderView = LoaderView()
        
        viewModel.getContactList(withCompletion: { [weak self] (status, error) in
            if let err = error {
                self?.tableView.tableHeaderView = TableErrorView(text: err.errorMessage)
            }
            else {
                self?.tableView.tableHeaderView = nil
            }
            self?.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController {
            vc.viewModel = ContactDetailViewModel(withState: .add, contact: nil)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func gouopButtonTapped(_ sender: Any) {
        
    }
    
    // View size is changed (e.g., device is rotated.)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    /**
     UITableView's life cycle methods.
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConstants.tableViewCellID, for: indexPath) as! HomeContactCell
        let data = viewModel[indexPath]
        cell.updateView(withData: data)
        cell.accessibilityIdentifier = "homeCell_\(indexPath.section)_\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = viewModel[indexPath]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController {
            vc.viewModel = ContactDetailViewModel(withState: .detail, contact: data as? Contact)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let backView = view as? UITableViewHeaderFooterView {
            backView.backgroundView?.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(forSection : section)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionTitles
    }
}

extension ViewController : ContactActionsProtocol {
    func contactAdded(withContactResponse reponse : [AnyHashable : Any]?) {
        viewModel.addContact(withData: reponse) { [weak self] (status) in
            self?.tableView.reloadData()
        }
    }
    
    func contactUpdated(status : Bool) {
        if status {
            tableView.reloadData()
        }
    }
}

extension ViewController {
    private struct TableConstants {
        static let tableViewCellID = "ContactViewCellID"
    }
}

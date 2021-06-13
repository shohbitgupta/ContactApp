//
//  ContactDetailViewController.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import MessageUI
import MobileCoreServices
import UIKit

enum ControllerState : Int{
    case detail, add, edit
}

class ContactDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var contactDetailTopHeader: ContactDetailHeaderView?
    var viewModel : ContactDetailViewModel?
    weak var delegate : ContactActionsProtocol?
    weak var contactUpdateDelegate : UserUpdatedContactProtocol?
    var gradient: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = viewModel?.vmState == .detail ? "contactDetailPage" : viewModel?.vmState == .edit ? "contactEditPage" : "contactAddPage"
        
        addRightBarButtonTiem()
        
        addHeaderView()
        addSubLayer()
        addFooterView()
    }
    
    // View size is changed (e.g., device is rotated.)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.updateHeaderViewFrame()
            self?.gradient?.frame = CGRect(x: 0.0, y: 0.0, width: self?.view.bounds.size.width ?? 0, height: self?.contactDetailTopHeader?.bounds.size.height ?? 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyBoardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyBoardNotification()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ContactDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    /**
     UITableView's life cycle methods.
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel?.vmState == .detail {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConstants.tableViewCellID, for: indexPath) as! ContactDetailCellTableViewCell
            let data = viewModel?[indexPath]
            cell.updateView(withData: data)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConstants.editTableViewCellID, for: indexPath) as! EditContactTableViewCell
            let data = viewModel?[indexPath]
            cell.updateView(withData: data)
            let rowValue = indexPath.row
            cell.editTextField.tag = rowValue
            cell.editTextField.accessibilityIdentifier = "editCellTextField_\(rowValue)"
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContactDetailViewController : TextDetailUpdateProtocol {
    func textUpdated(withText str : String?, index : Int) {
        viewModel?.updateModel(atIndex: IndexPath(row: index, section: 0), withData: str)
    }
}

extension ContactDetailViewController : UserUpdatedContactProtocol {
    func userUpdatedContact(status : Bool) {
        self.delegate?.contactUpdated(status: status)
        self.navigationController?.popViewController(animated: true)
    }
}

extension ContactDetailViewController : ContactDetailHeaderActionProtocol {
    func buttonTapped(withType buttonType : ButtonType, withStatus status : Bool) {
        
        switch buttonType {
        case .call:
            print("call Button")
            if let phone = viewModel?.selectedContact?.phone_number, let phoneCallURL = URL(string: "tel://\(phone)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        case .message:
            print("message Button")
            openMessage()
        case .email:
            print("email Button")
            openEmail()
        case .favorite:
            print("favorite Button")
            viewModel?.takeAction(withButtonType: buttonType, withStatus: status, withCompletion: { [weak self] (status, error) in
                self?.contactDetailTopHeader?.updateView(withData: self?.viewModel?.selectedContact, status: false)
                self?.delegate?.contactUpdated(status: status)
            })
        case .camera:
            print("camera Button")
            openCamera()
        }
    }
}

extension ContactDetailViewController {
    private struct TableConstants {
        static let tableViewCellID = "ContactDetailCellID"
        static let editTableViewCellID = "EditContactDetailCellID"
    }
    
    private func openMessage() {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = self
            let phoneNumber = viewModel?.selectedContact?.phone_number ?? ""
            controller.recipients = [phoneNumber]
            present(controller, animated: true, completion: nil)
        }
    }
    
    private func openEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            let email = viewModel?.selectedContact?.email ?? ""
            mail.setToRecipients([email])
            present(mail, animated: true)
        }
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imageVC = UIImagePickerController()
            imageVC.delegate = self
            imageVC.sourceType = .camera;
            imageVC.mediaTypes = [kUTTypeImage] as [String]
            imageVC.allowsEditing = false
            present(imageVC, animated: true, completion: nil)
        }
    }
    
    private func addKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyBoardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            let insetVal = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.contentInset = insetVal
            tableView.scrollIndicatorInsets = insetVal
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let insetVal = UIEdgeInsets.zero
            tableView.contentInset = insetVal
            tableView.scrollIndicatorInsets = insetVal
        }
    }
    
    @objc private func editbuttonTapped( sender : UIBarButtonItem) {
        if viewModel?.vmState == .detail {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController {
                vc.contactUpdateDelegate = self
                vc.viewModel = ContactDetailViewModel(withState: .edit, contact: viewModel?.selectedContact as? Contact)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            self.view.endEditing(true)
            if viewModel?.vmState == .edit {
                if let status = viewModel?.validateFields() , status {
                    showActivityIndicator()
                    viewModel?.updateContact(withCompletion: { [weak self] (status, error) in
                        self?.removeActivityIndicator()
                        let message = status ? "Contact updated successfully" : error?.errorMessage
                        Toast.shared().showToastMessage(message)
                        self?.contactUpdateDelegate?.userUpdatedContact(status: status)
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
            else {
                if let status = viewModel?.validateFields() , status {
                    showActivityIndicator()
                    viewModel?.addContact(withCompletion: { [weak self] (data, status, error) in
                        self?.removeActivityIndicator()
                        let message = status ? "Contact addedd successfully" : error?.errorMessage
                        Toast.shared().showToastMessage(message)
                        self?.delegate?.contactAdded(withContactResponse: data)
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    private func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.color = UIColor.init(white: 0.3, alpha: 1.0)
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.rightBarButtonItem = barButton
        activityIndicator.startAnimating()
    }
    
    private func removeActivityIndicator() {
        addRightBarButtonTiem()
    }
    
    private func addRightBarButtonTiem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: viewModel?.vmState == .detail ? .edit : .done , target: self, action: #selector(editbuttonTapped))
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = viewModel?.vmState == .detail ? "edit" : "done"
    }
    
    private func addSubLayer() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 0.28).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: contactDetailTopHeader?.bounds.size.height ?? 0)
        contactDetailTopHeader?.layer.insertSublayer(gradient, at: 0)
        self.gradient = gradient
    }
    
    private func addHeaderView() {
        let customView = Bundle.main.loadNibNamed("\(ContactDetailHeaderView.self)", owner: nil, options: nil)!.first as! ContactDetailHeaderView
        
        customView.initialSetup()
        
        customView.layoutIfNeeded()
        
        let containerView = UIView(frame: customView.bounds)
        containerView.addSubview(customView)
        
        contactDetailTopHeader = customView
        
        let status = viewModel?.vmState == .detail || viewModel?.vmState == .edit
        contactDetailTopHeader?.updateView(withData: viewModel?.selectedContact, status : status)
        contactDetailTopHeader?.delegate = self
        
        if viewModel?.vmState == .detail {
            tableView.register(UINib.init(nibName: "ContactDetailCellTableViewCell", bundle: nil), forCellReuseIdentifier: TableConstants.tableViewCellID)
        }
        else {
            contactDetailTopHeader?.toggleButtonsAndLabelVisibleState()
            tableView.register(UINib.init(nibName: "EditContactTableViewCell", bundle: nil), forCellReuseIdentifier: TableConstants.editTableViewCellID)
        }
        
        tableView.setTableHeaderView(headerView: containerView)
        tableView.updateHeaderViewFrame()
    }
    
    private func addFooterView() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        tableView.tableFooterView = footerView
    }
}

extension ContactDetailViewController : MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactDetailViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        contactDetailTopHeader?.userImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}

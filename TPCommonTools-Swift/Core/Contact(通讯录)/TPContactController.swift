//
//  TPContactController.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/27.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit

class TPContactController: TPViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    
    private func getData() {
        TPContactManager.shared.getLocalContacts { [weak self] (isSuccess) in
            if isSuccess {
                self?.reloadData()
            }
        }
    }
    
    private func reloadData() {
        self.tableView.reloadData()
    }
    
    @IBAction func refreshBtnClick(_ sender: Any) {
        self.getData()
    }
    
    @IBAction func addBtnClick(_ sender: Any) {
        var contact = TPContactEntity.init()
        contact.givenName = "testgivenName"
        contact.familyName = "testfamilyName"
        let phone = TPContactPhoneEntity.init(tag: "", phone: "123455")
        contact.phones.append(phone)
        TPContactManager.shared.creatContact(contactEntity: contact) { [weak self] (isSuccess) in
            if isSuccess {
                print("添加成功")
                self?.getData()
            }else{
                print("添加失败")
            }
        }
    }
    
}


// MARK: - Delegate
extension TPContactController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TPContactManager.shared.localContactsModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contact = TPContactManager.shared.localContactsModel.data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = contact.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = TPContactManager.shared.localContactsModel.data[indexPath.row]
        var phone = ""
        for phoneNum in contact.phones {
            phone = phone + "\n" + phoneNum.phone!
        }
        
        let alert = UIAlertController.init(title: contact.name, message: phone, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "关闭", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

//
//  TPContactManager.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/27.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit
import Foundation
import Contacts

class TPContactManager: NSObject {

    static let shared = TPContactManager.init()
    
    let contactStore = CNContactStore.init()
    var localContactsModel = TPContactModel.init()
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(localContactDidChange), name: Notification.Name.CNContactStoreDidChange, object: nil)
    }
    
    @objc private func localContactDidChange() {
        
    }
    
    
    /// 授权管理
    func authContact(complation: @escaping (Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: .contacts) { (grented, error) in
                if grented == true {
                    print("已授权")
                    complation(true)
                }else{
                    print("未授权")
                    complation(false)
                }
            }
        case .authorized:
            print("已授权")
            complation(true)
        case .restricted:
            fallthrough
        case .denied:
            fallthrough
        default:
            print("未授权")
            self.showNeedAuthAlert()
            complation(false)
        }
    }
    
    
    /// 鉴权并获取本地联系人
    func getLocalContacts(complation: @escaping (Bool) -> Void) {
        
        self.authContact { (isAuth) in
            if isAuth {
                self.getLocalContactsAction(complation: { (contactEntityArray, error) in
                    if contactEntityArray != nil {
                        self.localContactsModel.data = contactEntityArray!
                        complation(true)
                    }else{
                        print(error!)
                        complation(false)
                    }
                })
            }else{
                complation(false)
            }
        }
    }
    
    
    /// 获取本地联系人
    private func getLocalContactsAction(complation: @escaping ([TPContactEntity]?, Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey]
            let fetchRequest = CNContactFetchRequest.init(keysToFetch: keysToFetch as [CNKeyDescriptor])
            
            var contactEntityArray = [TPContactEntity]()
            do {
                try self.contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
                    (contact: CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    var contactEntity = TPContactEntity.init()
                    
                    contactEntity.familyName = contact.familyName
                    contactEntity.givenName = contact.givenName
                    contactEntity.name = String.init(format: "%@%@", contact.familyName, contact.givenName)
                    
                    for phone in contact.phoneNumbers {
                        let phoneModel = TPContactPhoneEntity.init(tag: phone.label, phone: phone.value.stringValue)
                        contactEntity.phones.append(phoneModel)
                    }
                    
                    for email in contact.emailAddresses {
                        let emailModel = TPContactEmailEntity.init(tag: email.label, email: email.value as String)
                        contactEntity.emails.append(emailModel)
                    }
                    
                    for address in contact.postalAddresses {
                        let fullAddr = String.init(format: "%@%@%@%@", address.value.country, address.value.state, address.value.city, address.value.street)
                        let addressModel = TPContactAddressEntity.init(tag: address.label, address: fullAddr)
                        contactEntity.addresses.append(addressModel)
                    }
                    
                    contactEntityArray.append(contactEntity)
                })
                DispatchQueue.main.async {
                    complation(contactEntityArray, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    complation(nil, error)
                }
            }
        }
    }
}


// MARK: - 增删查改
extension TPContactManager {
    
    /// 添加单个联系人
    func creatContact(contactEntity: TPContactEntity, complation: @escaping (Bool) -> Void) {
        
        DispatchQueue.global().async {
            let mContact = CNMutableContact.init()
            
            if contactEntity.familyName == nil && contactEntity.givenName == nil {
                mContact.familyName = contactEntity.name!
            }else{
                mContact.familyName = contactEntity.familyName!
                mContact.givenName = contactEntity.givenName!
            }
            
            for phoneEntity in contactEntity.phones {
                let phoneNum = phoneEntity.phone!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
                let phoneValue = CNLabeledValue.init(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber.init(stringValue: phoneNum))
                mContact.phoneNumbers.append(phoneValue)
            }
            
            for emailEntity in contactEntity.emails {
                let emailValue = CNLabeledValue.init(label: emailEntity.tag, value: emailEntity.email! as NSString)
                mContact.emailAddresses.append(emailValue)
            }
            
            for addressEntity in contactEntity.addresses {
                let postal = CNMutablePostalAddress.init()
                postal.street = addressEntity.address!
                let addressValue = CNLabeledValue.init(label: addressEntity.tag, value: postal)
                mContact.postalAddresses.append(addressValue as! CNLabeledValue<CNPostalAddress>)
            }
            
            
            let saveRequest = CNSaveRequest.init()
            saveRequest.add(mContact, toContainerWithIdentifier: nil)
            
            do {
                try self.contactStore.execute(saveRequest)
                DispatchQueue.main.async {
                    complation(true)
                }
            } catch {
                print(String.init(format: "添加联系人失败: %@ %@", contactEntity.name!, error as CVarArg))
                DispatchQueue.main.async {
                    complation(false)
                }
            }
        }
        
    }
    
    
    /// 添加联系人(批量)
    func creatContacts(contactEntityArray: [TPContactEntity], complation: @escaping (Bool) -> Void) {
        
        guard contactEntityArray.count > 0 else {
            complation(false)
            return
        }
        var contactCount = 0
        for contactEntity in contactEntityArray {
            self.creatContact(contactEntity: contactEntity) { (isSuccess) in
                //不管是否成功都继续
                contactCount = contactCount + 1
                if contactCount == contactEntityArray.count {
                    DispatchQueue.main.async {
                        complation(true)
                    }
                }
            }
        }
        
    }
    
    
    /// 删除联系人(根据姓名判断，批量)
    func deleteContacts(contactEntityArray: [TPContactEntity], complation: @escaping (Bool) -> Void) {
        
        DispatchQueue.global().async {
            
            let request = CNSaveRequest()
            var contactCount = 0
            
            let keys = [CNContactFamilyNameKey, CNContactGivenNameKey]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            do {
                try self.contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
                    (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    let mutableContact = contact.mutableCopy() as! CNMutableContact
                    
                    let familyName = mutableContact.familyName
                    let givenName = mutableContact.givenName
                    
                    for contactEntity in contactEntityArray {
                        
                        if familyName + givenName == contactEntity.name || (familyName == contactEntity.familyName && givenName == contactEntity.givenName) {
              
                            // 添加删除操作， 数量+1
                            request.delete(mutableContact)
                            contactCount = contactCount + 1
                            if contactCount == contactEntityArray.count {
                               stop.initialize(to: true)
                            }
                        }
                    }
                })
                
                try self.contactStore.execute(request)
                DispatchQueue.main.async {
                    complation(true)
                }
                
            } catch {
                print(String.init(format: "删除联系人失败 %@", error as CVarArg))
                DispatchQueue.main.async {
                    complation(false)
                }
            }
        }
    }
    
    
    //查找联系人（还是手机端自行操作比较方便，所以不做处理）
    func findContact(contactEntity: TPContactEntity, complation: @escaping (Bool) -> Void) {
        
    }
    
    
    //修改联系人（还是手机端自行操作比较方便，所以不做处理）
    func updateContact(contactEntity: TPContactEntity, complation: @escaping (Bool) -> Void) {
        
    }
}


// MARK: - 提示
extension TPContactManager {
    
    func showNeedAuthAlert() {
        let alert = UIAlertController.init(title: "提示", message: "因iOS系统限制，需要访问您的联系人信息才能同步电话本，联系人信息不会用作其他用途，请放心使用\n步骤：设置->隐私->通讯录", preferredStyle: .alert)
        let action1 = UIAlertAction.init(title: "去设置", style: .default) { (alertAction) in
            self.jumpToSetting()
        }
        let cancelAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(action1)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func jumpToSetting() {
        let settingUrl = URL.init(string: UIApplicationOpenSettingsURLString)!
        if UIApplication.shared.canOpenURL(settingUrl) {
            UIApplication.shared.openURL(settingUrl)
        }
    }
}


//
//  TPContactModel.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/29.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import Foundation

struct TPContactPhoneEntity {
    var tag: String?
    var phone: String?
}

struct TPContactEmailEntity {
    var tag: String?
    var email: String?
}

struct TPContactAddressEntity {
    var tag: String?
    var address: String?
}

struct TPContactEntity {
    var familyName: String?
    var givenName: String?
    var name: String? //姓名
    var phones: [TPContactPhoneEntity] = [] //手机
    var emails: [TPContactEmailEntity] = [] //email
    var addresses: [TPContactAddressEntity] = [] //地址
    var remark: String? //备注
}

struct TPContactModel {
    var data: [TPContactEntity] = []
}

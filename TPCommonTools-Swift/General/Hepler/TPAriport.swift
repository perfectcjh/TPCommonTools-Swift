//
//  TPAriport.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/27.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit

enum TPControllerType: String {
    case contact = "通讯录"
    case photo = "相册"
    case file = "本地文件管理"
}


class TPAriport: NSObject {

    static let shared = TPAriport.init()
    
    func makeFly(vcType: TPControllerType) {
        switch vcType {
        case .contact:
            print("")
        case .photo:
            print("")
        case .file:
            print("")
        }
    }
}

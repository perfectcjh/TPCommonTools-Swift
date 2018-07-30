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
    case filePreview = "文件预览"
}


class TPAriport: NSObject {

    static let shared = TPAriport.init()
    
    func makeFly(vcType: TPControllerType) {
        switch vcType {
        case .contact:
            let vc = TPContactController.init()
            self.pushToVC(controller: vc)
        case .photo:
            print("")
        case .file:
            print("")
        case .filePreview:
            let vc = TPFilePreviewController.init()
            self.pushToVC(controller: vc)
        }
    }
    
    
    func pushToVC(controller: UIViewController) {
        let rooVC = UIApplication.shared.keyWindow?.rootViewController
        if rooVC?.classForCoder == TPNavigationController.classForCoder() {
            let nav = rooVC as! TPNavigationController
            nav.pushViewController(controller, animated: true)
        }
    }
}

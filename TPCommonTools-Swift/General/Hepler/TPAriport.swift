//
//  TPAriport.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/27.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit

enum TPControllerType: String {
    case contact = "通讯录(Contacts)"
    case photo = "相册(Photos)"
    case file = "本地文件管理"
    case filePreview = "文件预览(QuickLook)"
}


class TPAriport: NSObject {

    static let shared = TPAriport.init()
    
    func makeFly(vcType: TPControllerType) {
        var vc: UIViewController = UIViewController.init()
        switch vcType {
        case .contact:
            vc = TPContactController.init()
        case .photo:
            vc = TPPhotoController.init()
        case .file:
            vc = TPLocalFileManagerController.init()
        case .filePreview:
            vc = TPFilePreviewController.init()
            
        }
        vc.title = vcType.rawValue
        self.pushToVC(controller: vc)
    }
    
    
    func pushToVC(controller: UIViewController) {
        let rooVC = UIApplication.shared.keyWindow?.rootViewController
        if rooVC?.classForCoder == TPNavigationController.classForCoder() {
            let nav = rooVC as! TPNavigationController
            nav.pushViewController(controller, animated: true)
        }
    }
}

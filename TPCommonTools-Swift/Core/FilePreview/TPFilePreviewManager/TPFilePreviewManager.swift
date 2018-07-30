//
//  TPFilePreviewManager.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/30.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit
import QuickLook

class TPFilePreviewManager: NSObject {

    var filePathArray = [String]()
    private var lastStatusBarStyle: UIStatusBarStyle!
    private var previewVC: QLPreviewController!
    private var previewItemArr = [QLPreviewItem]()
    
    convenience init(filePathArray: [String]) {
        self.init()
        
        self.lastStatusBarStyle = UIApplication.shared.statusBarStyle
        
        self.filePathArray = filePathArray
        for filePath in filePathArray {
            let url = URL.init(fileURLWithPath: filePath)
            let previewItem = url as QLPreviewItem
            if TPFilePreviewManager.canPreview(previewItem: previewItem) {
                self.previewItemArr.append(previewItem)
            }
        }
        
        self.previewVC = QLPreviewController.init()
        self.previewVC.delegate = self
        self.previewVC.dataSource = self
    }
    
    func showPreview(nav: UINavigationController? = nil) {
        if nav != nil {
            nav!.addChildViewController(self.previewVC)
            self.previewVC.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(rightBarBtnClick))
            UIApplication.shared.keyWindow?.rootViewController?.present(nav!, animated: true, completion: nil)
        }else{
            UIApplication.shared.statusBarStyle = .default
            UIApplication.shared.keyWindow?.rootViewController?.present(self.previewVC, animated: true, completion: nil)
        }
    }
    
    @objc private func rightBarBtnClick() {
        self.previewVC.dismiss(animated: true, completion: nil)
    }
    
    static func canPreview(previewItem: QLPreviewItem) -> Bool {
        return QLPreviewController.canPreview(previewItem)
    }
}


extension TPFilePreviewManager: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return self.previewItemArr.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItemArr[index]
    }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        UIApplication.shared.statusBarStyle = self.lastStatusBarStyle
    }
}

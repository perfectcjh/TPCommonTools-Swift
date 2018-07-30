//
//  TPFilePreviewController.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/30.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit

class TPFilePreviewController: TPViewController {
    
    var pathArr = [String]()
    var filePreview: TPFilePreviewManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "文件预览"
        
        let nameArr = ["test.docx", "test.pdf", "test.png"]
        for path in nameArr {
            let path = Bundle.main.path(forResource: path, ofType: "")
            self.pathArr.append(path!)
        }

        self.filePreview = TPFilePreviewManager.init(filePathArray: self.pathArr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func previewBtnClick(_ sender: Any) {
        let nav = TPNavigationController.init()
        self.filePreview.showPreview(nav: nav)
    }
    
}


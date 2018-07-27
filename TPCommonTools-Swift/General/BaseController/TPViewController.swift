//
//  TPViewController.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/27.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit

class TPViewController: UIViewController {
    
    class func getVCFromStoryBorad(_ name: String, identifier: String) -> UIViewController {
        
        let storyBoard = UIStoryboard.init(name: name, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

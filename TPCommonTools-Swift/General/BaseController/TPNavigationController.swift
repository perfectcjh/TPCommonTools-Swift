//
//  TPNavigationController.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/27.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit

class TPNavigationController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.edgesForExtendedLayout = UIRectEdge.all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.interactivePopGestureRecognizer?.delegate = self
        self.configNavigationBar()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            self.setBackBtn(viewController: viewController)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        self.configNavigationBar()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let popVC = super.popViewController(animated: animated)
        self.configNavigationBar()
        return popVC
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let popVCs = super.popToRootViewController(animated: animated)
        self.configNavigationBar()
        return popVCs
    }
    
    func configNavigationBar() {
        self.setRootNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}


// style
extension TPNavigationController {
    
    // 自定义返回按钮
    private func setBackBtn(viewController: UIViewController) {
        let backBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 30))
        backBtn.setImage(#imageLiteral(resourceName: "icon_nav_back"), for: .normal)
        backBtn.contentHorizontalAlignment = .left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
    }
    
    @objc func backBtnClick() {
        let resultVC = self.popViewController(animated: true)
        if resultVC != nil {
            
        }
    }
    
    func resetNavigationBar() {
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.backgroundColor = UIColor.white
        //        self.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationBar.subviews[0].subviews[0].isHidden = false;
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setRootNavigationBar() {
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = .orange
        self.navigationBar.backgroundColor = UIColor.white
        //        self.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.subviews[0].subviews[0].isHidden = true;
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
}


// UIGestureRecognizerDelegate
extension TPNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.childViewControllers.count == 1 {
            return false
        }
        return true
    }
}

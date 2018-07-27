//
//  TPTableViewCell.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/27.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit

class TPTableViewCell: UITableViewCell {

    class func xibCellWithTableView(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let className = NSStringFromClass(self.classForCoder())
        let nibName = className.components(separatedBy: ".").last
        let nib = UINib.init(nibName: nibName!, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: className)
        return tableView.dequeueReusableCell(withIdentifier: className, for: indexPath)
    }
    
    class func classCellWithTableView(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let className = NSStringFromClass(self.classForCoder())
        tableView.register(self.classForCoder(), forCellReuseIdentifier: className)
        return tableView.dequeueReusableCell(withIdentifier: className, for: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

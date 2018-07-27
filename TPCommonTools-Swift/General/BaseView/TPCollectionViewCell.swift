//
//  TPCollectionViewCell.swift
//  TPCommonTools-Swift
//
//  Created by chenjinheng on 2018/7/27.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import UIKit

class TPCollectionViewCell: UICollectionViewCell {
    
    class func xibCellWithCollectionView(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let className = NSStringFromClass(self.classForCoder())
        let nibName = className.components(separatedBy: ".").last
        let nib = UINib.init(nibName: nibName!, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: className)
        return collectionView.dequeueReusableCell(withReuseIdentifier: className, for: indexPath)
    }
    
    class func classCellWithCollectionView(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let className = NSStringFromClass(self.classForCoder())
        collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: className)
        return collectionView.dequeueReusableCell(withReuseIdentifier: className, for: indexPath)
    }
    
}

//
//  TPFileManager.swift
//  FreeNAS
//
//  Created by chenjinheng on 2018/7/14.
//  Copyright © 2018年 perfectcjh. All rights reserved.
//

import Foundation

// MARK: - 文件常用操作
struct TPFileManager {
    
    /// 判断文件夹是否存在
    static func isDirExists(dir: String) -> Bool {
        return FileManager.default.fileExists(atPath: dir)
    }
    
    /// 判断文件是否存在
    static func isFileExists(path: String) -> Bool{
        return self.isDirExists(dir: path)
    }
    
    /// 创建目录
    static func createDir(dir: String) -> Bool{
        do{
            try FileManager.default.createDirectory(at: NSURL(fileURLWithPath: dir, isDirectory: true) as URL, withIntermediateDirectories: true, attributes: nil)
            return true
        }catch{
            return false
        }
    }
    
    /// 删除文件 - 根据文件路径
    static func deleteFile(path: String) -> Bool{
        if(!isFileExists(path: path)){
            return true
        }
        do{
            try FileManager.default.removeItem(atPath: path)
            return true
        }catch{
            return false
        }
    }
    
    /// 清除所有的缓存
    static func deleteAllCache() -> Bool{
        let dir = self.cachePath()
        if !isDirExists(dir: dir){
            return true
        }
        do{
            try FileManager.default.removeItem(atPath: dir)
            return true
        }catch{
            return false
        }
    }
    
    /// 读取文件 -（根据路径）
    static func readFile(path: String) -> Data? {
        do{
            let pathUrl = URL.init(fileURLWithPath: path)
            let data = try Data.init(contentsOf: pathUrl, options: Data.ReadingOptions.mappedIfSafe)
             return data
        }catch{
            return nil
        }
    }
    
    /// 写文件
    static func writeFile(path: String, data: Data) -> Bool {
        do {
            let pathUrl = URL.init(fileURLWithPath: path)
            try data.write(to: pathUrl, options: Data.WritingOptions.atomic)
            return true
        }catch{
            return false
        }
    }
}


// MARK: - 目录
extension TPFileManager {
    
    /// Documents目录(homeDirectory + "/Documents") 苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包含此目录
    static func documentPath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentPath = documentPaths[0]
        return documentPath
    }
    
    /// Library目录(homeDirectory + "/Library")这个目录下有2个子目录：Caches缓存 , Preferences偏好设置,不应该直接创建偏好设置文件而使用NSUserDefaults类
    static func libraryPath() -> String {
        let libraryPaths =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let libraryPath = libraryPaths[0]
        return libraryPath
    }
    
    /// Cache目录(homeDirectory + "/Library/Caches")主要存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出时删除
    static func cachePath() -> String {
        let cachePaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cachePath = cachePaths[0]
        return cachePath
    }
    
    /// tmp目录(homeDirectory + "/tmp")用于存放临时文件，保持应用程序再次启动过程中不需要的信息，重启后清空
    static func temporaryPath() -> String {
        let temporaryPath = NSTemporaryDirectory()
        return temporaryPath
    }
}

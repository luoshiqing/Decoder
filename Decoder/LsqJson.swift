//
//  LsqJson.swift
//  Protocol
//
//  Created by lsq on 2017/12/18.
//  Copyright © 2017年 罗石清. All rights reserved.
//

import UIKit

protocol LsqJson: Codable {
    func toJsonString()->String?
    func toDictionary()->[String:Any]?
}

extension LsqJson{
    
    func toJsonString()->String?{
        if let encodeData = try? JSONEncoder().encode(self){
            return String(data: encodeData, encoding: .utf8)
        }
        return nil
    }
    func toDictionary()->[String:Any]?{
        if let encodeData = try? JSONEncoder().encode(self){
            let dic = try? JSONSerialization.jsonObject(with: encodeData, options: .mutableContainers)
            return dic as? [String:Any]
        }
        return nil
    }
}

enum LsqError: Error {

    case message(String)
    
}
protocol LsqDecode {
    static func decode<T>(_ type: T.Type, param: [String:Any]) throws -> T where T: Decodable
}
extension LsqDecode{
    static func decode<T>(_ type: T.Type, param: [String:Any]) throws -> T where T: Decodable{
        
        guard let jsonData = self.getJsonData(with: param) else {
            throw LsqError.message("转换data失败")
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            throw LsqError.message("转换模型失败")
        }
       return model
    }
    
    
    fileprivate static func getJsonData(with param: Any)->Data?{
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data

    }
}
class MyDecoder: NSObject {
    class func decode<T>(_ type: T.Type, param: [String:Any]) throws -> T where T: Decodable{
        guard let jsonData = self.getJsonData(with: param) else {
            throw LsqError.message("转换data失败")
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            throw LsqError.message("转换模型失败")
        }
        return model
    }
    class func decode<T>(_ type: T.Type, jsonString: String) throws -> T where T: Decodable{
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw LsqError.message("转换data失败")
        }
        guard let dic = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? [String:Any] else{
            throw LsqError.message("转换字典失败")
        }
        guard let model = try? self.decode(type, param: dic) else {
            throw LsqError.message("转换模型失败")
        }
        return model
    }
    
    fileprivate class func getJsonData(with param: Any)->Data?{
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
        
    }
}

//
//  ViewController.swift
//  Protocol
//
//  Created by lsq on 2017/12/18.
//  Copyright © 2017年 罗石清. All rights reserved.
//

import UIKit


class User: NSObject, LsqJson, LsqDecode {

    @objc var name: String? = ""
    var age: Int? = 0
    
    var att: TmpYY?
}

struct StLsq: Codable, LsqDecode, LsqJson {
    var name: String? = ""
    var age: Int? = 0
    var att: TmpYY?
}
struct TmpYY: Codable {
    var money: Double? = 0.0
    var sex: Int?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let user = User()
        user.name = "数量"
        user.age = 12
        //模型转字符串
        let json = user.toJsonString()
        print(json ?? "")
        
        let dic: [String:Any] = ["name":"李四",
                                 "age":45,
                                 "att":["money":100.2,"sex":1]]
        
        let dic2: [String:Any] = ["name":"李四",
                                  "age":45,
                                  "tmp":112]
        //字典转模型（协议转）
        if let model = try? User.decode(User.self, param: dic){
            print(model.name,model.age,model.att ?? "字典没有？")
        }
        
        do {
            let model2 = try User.decode(User.self, param: dic2)
            print(model2.att)
            print(model2)
        } catch  {
            print(error)
        }
        //字典转模型
        if let st = try? StLsq.decode(StLsq.self, param: dic){
            print(st)
        }
        
        //字典转模型（类方法转）
        if let msts = try? MyDecoder.decode(StLsq.self, param: dic){
            //模型转json字符串
            guard let jsonString = msts.toJsonString() else{
                return
            }
            //josn字符串转模型
            guard let abcd = try? MyDecoder.decode(StLsq.self, jsonString: jsonString) else{
                return
            }
            print(abcd)
            //模型转字典
            guard let dic = msts.toDictionary() else{
                return
            }
            print(dic)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


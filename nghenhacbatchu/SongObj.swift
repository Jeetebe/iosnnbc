//
//  TinhObj.swift
//  IOS8SwiftTabBarControllerTutorial
//
//  Created by MacBook on 4/30/17.
//  Copyright © 2017 Arthur Knopper. All rights reserved.
//

import Foundation
import SwiftyJSON

class SongObj
{
    var tonecode:String = ""
    var tonename:String = ""
    var singer:String = ""
    
    
    required init?(tonecode: String?, tonename: String?, singername: String?) {
        self.tonecode = tonecode!
        self.tonename=tonename!
        self.singer=singername!
        
        
    }
    
    //    func description() -> String {
    //        return "ID: \(self.id)" +
    //            "User ID: \(self.userId)" +
    //            "Title: \(self.title)\n" +
    //        "Completed: \(self.completed)\n"
    //    }
    required init?(json: SwiftyJSON.JSON) {
        self.tonecode = json["tonecode"].string!
        self.tonename = json["tonename"].string!
        self.singer = json["singer"].string!
        
          }
    
    convenience init?(json: [String: Any]) {
        guard let tonecode = json["tonecode"] as? String,
            let tonename = json["tonename"] as? String,
            let singer = json["singer"] as? String
                       else {
                return nil
        }
        
        self.init(tonecode: tonecode,tonename: tonename,singername: singer)    }
    
}

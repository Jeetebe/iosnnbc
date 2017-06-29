//
//  util.swift
//  nghenhacbatchu
//
//  Created by MacBook on 6/29/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit
import  Alamofire

class util
{
   
     static func convert(song:SongObj) -> String {
        var str:String=song.tonecode
        var kqu:String=""
        
        
        
        //str="601502000000000135"
        let index1 = str.index(str.startIndex, offsetBy: 3)
        let s0 = str.substring(to: index1)
        
        var start = str.index(str.startIndex, offsetBy: 3)
        var end = str.index(str.startIndex, offsetBy: 6)
        var range = start..<end
        let s1=str.substring(with: range)
        
        
        start = str.index(str.startIndex, offsetBy: 6)
        end = str.index(str.startIndex, offsetBy: 7)
        range = start..<end
        let s2 = str.substring(with: range)
        
        start = str.index(str.startIndex, offsetBy: 7)
        end = str.index(str.startIndex, offsetBy: 11)
        range = start..<end
        let s3 = str.substring(with: range)
        
        start = str.index(str.startIndex, offsetBy: 11)
        end = str.index(str.startIndex, offsetBy: 15)
        range = start..<end
        let s4 = str.substring(with: range)
        
        start = str.index(str.startIndex, offsetBy: 15)
        end = str.index(str.startIndex, offsetBy: 18)
        range = start..<end
        let s5 = str.substring(with: range)
        
        
        kqu=s0+"/"+s1+"/"+s2+"/"+s3+"/"+s4+"/"+s5
        //print("kqu \(kqu)")
        return kqu
    }
    static func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    static func getvalidURL(song:SongObj) -> String {
        var kq:String=""
        let str:String = convert(song: song)
        print("convert:\(str)")
        for char in "abcdefghijklmnopqrstuvwxyz".characters {
            print(char)
            kq="http://45.121.26.141/"+String(char)+"/colorring/al/"+str+".mp3"
            print("kqu \(kq)")
            if (verifyUrl(urlString: kq))
            {
                return kq
            }

            
        }
        return "ko tim thay"
    }
    static func fileExists(urlString : String!) -> Bool {

        var b:Bool = true
        Alamofire.request(urlString).responseString{
            
            response in
            print(response)
            guard response.result.error == nil else {
                print(response.result.error!)
                b=false
                return
            }
           
            
        }
        
        return b
    }
}

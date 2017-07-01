//
//  introViewController.swift
//  nghenhacbatchu
//
//  Created by MacBook on 7/1/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import  Alamofire

class introViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var list=[AlbumObj]()
    var solan=0


    @IBOutlet weak var collv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alamofireGetLog()
        
        //To retrieve from the key
        let userDefaults = UserDefaults.standard
        var device  = userDefaults.string(forKey: "device")
        print("device \(device)")

        if (device == nil)
        {
            device = randomStringWithLength(len: 10) as String
            userDefaults.set(device, forKey: "device")
            userDefaults.set(0, forKey: "solan")
            
        }
        else
        {
            
            device  = userDefaults.string(forKey: "device")
            solan  = userDefaults.integer(forKey: "solan")
        }
        
        
        print("solan \(solan)")
        
        alamofirePostLog2server(dev: device!,log: "login_NghenhacbatchuiOS_v1")

        // Do any additional setup after loading the view.
    }
    func alamofirePostLog2server(dev:String, log:String) {
        let newTodo: [String: Any] = ["device": dev,"log":log]
        Alamofire.request("http://123.30.100.126:8081/Restapi/rest/Musicquiz/postlog2server?logstr="+log+"&device="+dev, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.result.error!)
                    return
                }
                
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row%2 == 0
        {
            cell.backgroundColor = UIColor.gray
        }
        else
        {
            cell.backgroundColor = UIColor.brown
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let imgurl = list[indexPath.row].imgurl as! String
        //cell.imageView.image = UIImage(named: )
        //cell.imageView.image = UIImage(named: "smile")
        if let url = NSURL(string: imgurl) {
            if let data = NSData(contentsOf: url as URL) {
                cell.imageView.image = UIImage(data: data as Data)
            }
        }
        
        return cell
    }
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    
            return 4
        }
    
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    
            return 4
        }

    
    func alamofireGetLog() {
        let todoEndpoint: String = "http://123.30.100.126:8081/Restapi/rest/Musicquiz/getalbum/musicquiz"
        Alamofire.request(todoEndpoint)
            
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print(response.result.error!)
                    //completionHandler(.failure(response.result.error!))
                    return
                }
                
                // make sure we got JSON and it's an array of dictionaries
                guard let json = response.result.value as? [[String: AnyObject]] else {
                    print("didn't get todo objects as JSON from API")
                    //                    completionHandler(.failure(BackendError.objectSerialization(reason: "Did not get JSON array in response")))
                    return
                }
                
                // turn each item in JSON in to Todo object
                var todos:[AlbumObj] = []
                for element in json {
                    if let todoResult = AlbumObj(json: element) {
                        todos.append(todoResult)
                        self.list.append(todoResult)
                    }
                }
                print("out:\(self.list.count)")
                self.collv.reloadData()
                
                
        }
    }

    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for i in 0 ..< len {
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
  
}

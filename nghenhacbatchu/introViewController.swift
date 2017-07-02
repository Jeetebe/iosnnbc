//
//  introViewController.swift
//  nghenhacbatchu
//
//  Created by MacBook on 7/1/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import  Alamofire
import Social


class introViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var list=[AlbumObj]()
    var solan=0

    //let link:String="Ứng dụng Lịch cúp điện  http://itunes.apple.com/app/id1232657493"
    let link:String="Game Nghe nhạc bắt chữ  http://itunes.apple.com/app/id1254978556"
    

    @IBAction func share_app(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            controller?.setInitialText(link)
            //controller.addImage(captureScreen())
            self.present(controller!, animated:true, completion:nil)
        }
            
        else {
            print("no Facebook account found on device")
            var alert = UIAlertView(title: "Thông báo", message: "Bạn chưa đăng nhập facebook", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        

    }
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
            userDefaults.set(10, forKey: "coin")
            userDefaults.set(0, forKey: "point")
            
        }
        else
        {
            
            device  = userDefaults.string(forKey: "device")
            solan  = userDefaults.integer(forKey: "solan")
        }
        
        
        print("solan \(solan)")
        
        alamofirePostLog2server(dev: device!,log: "login_NghenhacbatchuiOS_v1")
        solan += 1
        userDefaults.set(solan, forKey: "solan")
        

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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath as IndexPath) {
            performSegue(withIdentifier: "showDetail", sender: cell)
            print("click:\(list[indexPath.row].nameid)")
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        var nameid:String="none"
        
         if segue.identifier == "showDetail" {
            if let indexPath = self.collv?.indexPath(for: sender as! UICollectionViewCell) {
           
                
                nameid = list[indexPath.row].nameid
                print("chon:\(nameid)")
                            }
        }
        else {
            // Error sender is not a cell or cell is not in collectionView.
        }
        let detailVC: ViewController = segue.destination as! ViewController
        detailVC.type1=nameid

        
    }

  
}

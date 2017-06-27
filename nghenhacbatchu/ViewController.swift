//
//  ViewController.swift
//  nghenhacbatchu
//
//  Created by MacBook on 6/26/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}
class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let songname:String="TROTYEU"
    var characters:[String]=[]
    var traloi:[String]=[]
    var traloiInt:[Int]=[]
    var lvisible:[Bool]=[]

    
    @IBOutlet weak var lbkqua: UILabel!
    

    @IBOutlet weak var collv1songname: UICollectionView!
    @IBOutlet weak var collv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        repare(songname: songname.replacingOccurrences(of: " ", with: ""))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view.
        if (collectionView==self.collv)
        {
        return 18
        }
        else
        {
            return songname.lengthOfBytes(using: .ascii)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView==self.collv)
        {
            let cell = collv.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! Mycell
            // Do any custom modifications you your cell, referencing the outlets you defined in the Custom cell file.
            cell.backgroundColor = UIColor.white
            cell.lb.text = characters[indexPath.item]
            if (lvisible[indexPath.row])
            {
                cell.lb.isHidden=false
            }
            else
            {
                cell.lb.isHidden=true
            }
            return cell
        }
        else{
            let cell = collv1songname.dequeueReusableCell(withReuseIdentifier: "mycellsongname", for: indexPath) as! Mycell1
            // Do any custom modifications you your cell, referencing the outlets you defined in the Custom cell file.
            cell.backgroundColor = UIColor.white
            var str:String=""
            //print("size:\(traloi.count)")
            if (indexPath.row<=traloi.count-1)
            {
                str=traloi[indexPath.item]
                //cell.backgroundColor = UIColor.blue
            }
            
            cell.lbsongname.text = str
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView==self.collv)
        {
            //xli gridview 2
   
            lvisible[indexPath.row]=false
            
            traloi.append(characters[indexPath.item])
            traloiInt.append(indexPath.row)
            
            
            //collectionView.reloadData()
        }
        else
        {
            //xli grid 1
            if traloi.count>0
            {
            traloi.removeLast()
            lvisible[traloiInt[indexPath.row]]=true
            traloiInt.removeLast()
            }
            
            
        }
        self.collv1songname.reloadData()
        self.collv.reloadData()
        //print("\(lvisible)")
        
        if (traloi.count==songname.lengthOfBytes(using: .ascii))
        {
            //check kqua
            let strdapan=traloi.flatMap({$0}).joined()
            print("dapan:\(strdapan)")
             print("songname:\(songname)")
            if (strdapan==songname)
            {
                lbkqua.text="dung"
            }
            else
            {
                lbkqua.text="sai"
            }
        }

    }
    
    
    
    
    func repare(songname:String) -> Void {
        let l=songname.lengthOfBytes(using: .ascii)
        let randstr=randomString(length: 18-l) + songname.uppercased()
        
        characters = randstr.characters.map { String($0) }
        print(characters)
        characters.shuffle()
        print(characters)
        for i in 0...17
            {
                lvisible.append(true)
        }
    
    }
    
    
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        
//        return 4
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        
//        return 4
//    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
       
        if (collectionView==self.collv)
        {
            let s=(screenWidth-32-4*6-50)/6

            
        let cellSize = CGSize(width:s , height:s)
        return cellSize
        }
        else
        {
            let s=(screenWidth-32-4*6-50)/9

            let cellSize = CGSize(width:s , height:s)
            return cellSize
        }
    }
    
    
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

}


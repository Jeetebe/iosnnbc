//
//  ViewController.swift
//  nghenhacbatchu
//
//  Created by MacBook on 6/26/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import  GoogleMobileAds
import AVFoundation

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}
class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, CAAnimationDelegate, UICollectionViewDelegateFlowLayout,AVAudioPlayerDelegate {
    
    var songname:String="TROTYEU"
    //tonecode":"601502000000000135","tonename":"DE GIO CUON DI","singer":"PHAN DINH TUNG"
    let currsong = SongObj(tonecode: "601785000000001388", tonename: "DE GIO CUON DI", singername: "PHAN DINH TUNG")
    
    var characters:[String]=[]
    var traloi:[String]=[]
    var traloiInt:[Int]=[]
    var lvisible:[Bool]=[]

    @IBOutlet weak var disk: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var btnplay: UIButton!
    
    @IBOutlet weak var lbkqua: UILabel!
    
    var isRotating = false
    var shouldStopRotating = false
    
    var audioPlayer:AVAudioPlayer! = nil

    
    var isplaying:Bool=false
    
    @IBAction func btnplay_click(_ sender: Any) {
        if (!audioPlayer.isPlaying)
        
        {
            self.disk.rotate360Degrees(completionDelegate: self)
            self.isRotating = true
            btnplay.setImage(#imageLiteral(resourceName: "ic_pause_circle_filled_48pt"), for: .normal)
            
            playAudio()
        }
        else
        {
             self.shouldStopRotating = true
            btnplay.setImage(#imageLiteral(resourceName: "ic_play_circle_filled_48pt"), for: .normal)
            audioPlayer.pause()

        }
        
    }
    func prepareAudio()
    {
        //setCurrentAudioPath()
        do {
            //keep alive audio at background
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let soundUrl: String = "http://45.121.26.141/w/colorring/al/601/514/0/0000/0004/738.mp3"
        
        do {
            let fileURL = NSURL(string:soundUrl)
            let soundData = NSData(contentsOf:fileURL! as URL)
            self.audioPlayer = try AVAudioPlayer(data: soundData! as Data)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.delegate = self
            //audioLength = audioPlayer.duration
//            playerProgressSlider.maximumValue = CFloat(audioPlayer.duration)
//            playerProgressSlider.minimumValue = 0.0
//            playerProgressSlider.value = 0.0
            //audioPlayer.play()
            
            
            //progressTimerLabel.text = "00:00"
            
            
        } catch {
            print("Error getting the audio file")
        }
    }
    func  playAudio(){
        audioPlayer.play()
        //startTimer()
    }

    @IBOutlet weak var collv1songname: UICollectionView!
    @IBOutlet weak var collv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        songname=(currsong?.tonename.replacingOccurrences(of: " ", with: ""))!
        repare(songname: songname)
    
        prepareAudio()
        
        var c2=fileExists(soundUrl: "http://45.121.26.141/w/colorring/al/601/514/0/0000/0004/738.mp3")
        print("c2\(c2)")
 
        var c1=fileExists(soundUrl: "http://45.121.26.141/w/colorring/al/502/0/0000/0000/135.mp3")
        print("c1\(c1)")
        
        var kqu=getvalidURL(song: currsong!)
        print("hople: \(kqu)")
        
        
        
        
        //ads
        //bannerView.adSize=kGADAdSizeSmartBannerPortrait
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-8623108209004118/3364165189"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
             print("songname:\(currsong?.tonename)")
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
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.shouldStopRotating == false {
            self.disk.rotate360Degrees(completionDelegate: self)
        } else {
            self.reset()
        }
    }
    
    func reset() {
        self.isRotating = false
        self.shouldStopRotating = false
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
    
    func fileExists(soundUrl : String!) -> Bool {
        var b:Bool=true
        do {
            let fileURL = NSURL(string:soundUrl)
            let soundData = NSData(contentsOf:fileURL! as URL)
            if (soundData==nil)
            {
                print("nil")
                b = false
            }
            else
            {
                print("not nil")
                b = true
            }
//            try self.audioPlayer =  AVAudioPlayer(data: soundData! as Data)
//            audioPlayer.prepareToPlay()
//            audioPlayer.volume = 1.0
//            audioPlayer.delegate = self
                  }
        catch {
            print("Error getting the audio file")
                    b = false
        }
        return b
    }
    
    func getvalidURL(song:SongObj) -> String {
        var kq:String=""
        let str:String = util.convert(song: song)
        print("convert:\(str)")
        for char in "abcdefghijklmnopqrstuvwxyz".characters {
            print(char)
            kq="http://45.121.26.141/"+String(char)+"/colorring/al/"+str+".mp3"
            print("kqu \(kq)")
            if (fileExists(soundUrl:kq))
            {
                return kq
            }
            
            
        }
        return "ko tim thay"
    }


}


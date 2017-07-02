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
//import KDCircularProgress
import Alamofire
import PopupDialog
import MediaPlayer

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}
class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, CAAnimationDelegate, UICollectionViewDelegateFlowLayout,AVAudioPlayerDelegate, GADRewardBasedVideoAdDelegate {
   @IBOutlet weak var progress: KDCircularProgress!
    
    var songname:String="TROTYEU"
    //tonecode":"601502000000000135","tonename":"DE GIO CUON DI","singer":"PHAN DINH TUNG"
    var currsong = SongObj(tonecode: "601785000000001388", tonename: "DE GIO CUON DI", singername: "PHAN DINH TUNG")
    
    var characters:[String]=[]
    var traloi:[String]=[]
    var traloiInt:[Int]=[]
    var lvisible:[Bool]=[]
    
    var list=[SongObj]()
    var currInt=0;
    var num = 0
    var coin=10
    var point=0
    var type1:String!
    var device:String!
    
    /// The reward-based video ad.
    var rewardBasedVideo: GADRewardBasedVideoAd?
    
    /// Is an ad being loaded.
    var adRequestInProgress = false


    @IBOutlet weak var playerProgressSlider: UISlider!

    @IBOutlet weak var lbcoin: UILabel!
    @IBOutlet weak var disk: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var btnplay: UIButton!
    //var progress: KDCircularProgress!
    
    @IBOutlet weak var lbpint: UILabel!

    
    var isRotating = false
    var shouldStopRotating = false
    
    var timer:Timer!
     var audioLength = 0.0

    @IBAction func back_click(_ sender: Any) {
        
        if (audioPlayer.isPlaying)
        {
            audioPlayer.stop()
        }
        
         //show_ads()
        let userDefaults = UserDefaults.standard

        userDefaults.set(coin, forKey: "coin")
        userDefaults.set(point, forKey: "point")

        self.dismiss(animated: true, completion: nil)
        
       
    }
       var audioPlayer:AVAudioPlayer! = nil
    @IBAction func help_click(_ sender: Any) {
        let len=songname.lengthOfBytes(using: .ascii)-1
        traloi.removeAll()
        traloiInt.removeAll()
        for j in 0...len{
            var start = songname.index(songname.startIndex, offsetBy: j)
            var end = songname.index(songname.startIndex, offsetBy: j+1)
            var range = start..<end
            let s1=songname.substring(with: range)
            traloi.append(s1)

            let i=characters.index(of: s1)!
            //print("i:\(i)")
            traloiInt.append(i)
            lvisible[i]=false
            
            collv.reloadData()
            collv1songname.reloadData()
            collv.isUserInteractionEnabled = false
            collv1songname.isUserInteractionEnabled = false
            
            show_ads()
        }
    }

    func show_ads() -> Void {
        
        if rewardBasedVideo?.isReady == true {
            rewardBasedVideo?.present(fromRootViewController: self)
        } else {
//            UIAlertView(title: "Reward based video not ready",
//                        message: "The reward based video didn't finish loading or failed to load",
//                        delegate: self,
//                        cancelButtonTitle: "Drat").show()
        }

    }
    @IBAction func next_click(_ sender: Any) {
        playnext()
    }
    @IBAction func info_click(_ sender: Any) {
        let len=traloi.count
        //let dice1 = arc4random_uniform(UInt32(len));
        print("len:\(len)")
        
        var start = songname.index(songname.startIndex, offsetBy: len)
        var end = songname.index(songname.startIndex, offsetBy: len+1)
        var range = start..<end
        let s1=songname.substring(with: range)
        traloi.append(s1)
        let i=characters.index(of: s1)!
        //print("i:\(i)")
        traloiInt.append(i)
        lvisible[i]=false
        
        collv.reloadData()
        collv1songname.reloadData()
        
        
        if (coin>0)
        {
            coin = coin - 1
            //lbcoin.text = String(coin)
        }
        else
        {
            //self.show_popup()
            show_ads()
            coin = coin + 10
            //lbcoin.text = String(coin)
        }
        update_label()
    }

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
        var kqu=getvalidURL(song: currsong!)
        print("hople: \(kqu)")
        if (kqu == "notfound")
        {
            playnext()

        }
        else
        {
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
            
            //let soundUrl: String = "http://45.121.26.141/w/colorring/al/601/514/0/0000/0004/738.mp3"
            let soundUrl: String = kqu
            
            do {
                let fileURL = NSURL(string:soundUrl)
                let soundData = NSData(contentsOf:fileURL! as URL)
                self.audioPlayer = try AVAudioPlayer(data: soundData! as Data)
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 1.0
                audioPlayer.delegate = self
                
//                 let item = AVPlayerItem(url: fileURL as! URL)
//                NotificationCenter.default.addObserver(self, selector: Selector("playerDidFinishPlaying:"), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
//
                audioPlayer.delegate = self
                
                audioLength = audioPlayer.duration
                            playerProgressSlider.maximumValue = CFloat(audioPlayer.duration)
                            playerProgressSlider.minimumValue = 0.0
                            playerProgressSlider.value = 0.0
                //audioPlayer.play()
                
                
                //progressTimerLabel.text = "00:00"
                
                
            } catch {
                print("Error getting the audio file")
            }
            
        }

        
    }
    func  playAudio(){
        audioPlayer.play()
        startTimer()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // ...
        print("playing finish")
        playnext()

    }

    @IBOutlet weak var collv1songname: UICollectionView!
    @IBOutlet weak var collv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("type1:\(type1)")
        let userDefaults = UserDefaults.standard
        coin  = userDefaults.integer(forKey: "coin")
        point  = userDefaults.integer(forKey: "point")
        device  = userDefaults.string(forKey: "device")

        alamofireGetLog()
        
        self.disk.rotate360Degrees(completionDelegate: self)
        self.isRotating = true
        btnplay.setImage(#imageLiteral(resourceName: "ic_pause_circle_filled_48pt"), for: .normal)

        
        update_label()
       
        
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        
        if !adRequestInProgress && rewardBasedVideo?.isReady == false {
            rewardBasedVideo?.load(GADRequest(),
                                   withAdUnitID: "ca-app-pub-8623108209004118/1717478389")
            adRequestInProgress = true
        }

        //ads
        bannerView.adSize=kGADAdSizeSmartBannerPortrait
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-8623108209004118/3364165189"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    func update_label() -> Void {
        lbpint.text = String(point)
        lbcoin.text = String(coin)
    }
    func  playnext() -> Void {
        
        
        //?????
        alamofireGetLog()
        
        
        
    }
    func setupgame() -> Void {
        self.num=18;
        traloiInt.removeAll()
        traloi.removeAll()
        lvisible.removeAll()
       
        currInt=0 //fix
        currsong = list[currInt]
        songname=(currsong?.tonename.replacingOccurrences(of: " ", with: ""))!
        print("song:\(songname)")
        
        //songname=(currsong?.tonename.replacingOccurrences(of: " ", with: ""))!
        repare(songname: songname)
        
        prepareAudio()
        playAudio()
        
        
        collv1songname.isUserInteractionEnabled = true
        collv.isUserInteractionEnabled = true
        collv1songname.reloadData()
        collv.reloadData()
        currInt += 1

    }
    func show_congrate() -> Void {
        // Prepare the popup assets
        let title = ""
        let message = ""
        let image = UIImage(named: "congra")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Chơi tiếp") {
            //print("You canceled the car dialog.")
            self.playnext()
        }
        
       
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    func  show_playVideo() -> Void {
        let title = "Xem video"
        let message = "This is the message section of the popup dialog default view"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
            print("Completed")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL") {
            //self.label.text = "You canceled the default dialog"
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "OK") {
            //self.label.text = "You ok'd the default dialog"
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
        
        
          }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view.
        if (collectionView==self.collv)
        {
        return num
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
            cell.backgroundColor = UIColor .clear
            if (lvisible[indexPath.row])
            {
                //cell.lb.isHidden=false
                cell.isHidden = false
                
            }
            else
            {
                //cell.lb.isHidden=true
                cell.isHidden = true
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
            cell.backgroundColor = UIColor .clear
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
                               show_congrate()
                point += 1
                coin += 1
                update_label()
            }
            else
            {
                
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
        collv1songname.reloadData()
        collv.reloadData()
    
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
            //print(char)
            kq="http://45.121.26.141/"+String(char)+"/colorring/al/"+str+".mp3"
            //String url="http://45.121.26.141/"+alphabet+"/colorring/al/"+path+".mp3";

            
            //print("kqu \(kq)")
            if (fileExists(soundUrl:kq))
            {
                return kq
            }
            
            
        }
        return "notfound"
    }
    
    func alamofireGetLog() {
        print("get 1song")
        //let todoEndpoint: String = "http://123.30.100.126:8081/Restapi/rest/Musicquiz/get5song?level=1"
        let todoEndpoint: String = "http://123.30.100.126:8081/Restapi/rest/Musicquiz/get1song?level="
            + String(point) + "&device=" + device + "&chude=" + type1
        print("url\(todoEndpoint)")
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
                var todos:[SongObj] = []
                self.list.removeAll()
                for element in json {
                    if let todoResult = SongObj(json: element) {
                        todos.append(todoResult)
                        self.list.append(todoResult)
                    }
                }
                print("out:\(self.list.count)")
               
               
                 //self.playnext()
                self.setupgame()
               
                
        }
    }
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update(_:)), userInfo: nil,repeats: true)
            timer.fire()
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        
    }
    func newAngle() -> Double {
        return Double(360 * (playerProgressSlider.value / playerProgressSlider.maximumValue))
    }
    
    func update(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
        //progressTimerLabel.text  = "\(time.minute):\(time.second)"
        playerProgressSlider.value = CFloat(audioPlayer.currentTime)
        UserDefaults.standard.set(playerProgressSlider.value , forKey: "playerProgressSliderValue")
        
        
        progress.angle=Double(newAngle())
        
    }
    
    func retrievePlayerProgressSliderValue(){
        let playerProgressSliderValue =  UserDefaults.standard.float(forKey: "playerProgressSliderValue")
        if playerProgressSliderValue != 0 {
            playerProgressSlider.value  = playerProgressSliderValue
            audioPlayer.currentTime = TimeInterval(playerProgressSliderValue)
            
            let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
            //progressTimerLabel.text  = "\(time.minute):\(time.second)"
            playerProgressSlider.value = CFloat(audioPlayer.currentTime)
            
        }else{
            playerProgressSlider.value = 0.0
            audioPlayer.currentTime = 0.0
            //progressTimerLabel.text = "00:00:00"
        }
    }
    //This returns song length
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        // let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
    
    
    func calculateSongLength(){
        let time = calculateTimeFromNSTimeInterval(audioLength)
        //totalLengthOfAudio = "\(time.minute):\(time.second)"
    }


    
    // MARK: GADRewardBasedVideoAdDelegate implementation
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        adRequestInProgress = false
        print("Reward based video ad failed to load: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adRequestInProgress = false
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        //earnCoins(NSInteger(reward.amount))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }


}


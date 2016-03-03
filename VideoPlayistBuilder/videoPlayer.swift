//
//  videoPlayer.swift
//  VideoPlayistBuilder
//
//  Created by Catherine Zhao on 2016-02-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AVKit
import MediaPlayer

enum AVPlayerActionAtItemEnd : Int {
    case Advance
    case Pause
    case None
}

enum currentAmblum : Int {
    case Playist
    case Singer
    case All
    case NotInit
}

enum videoPlayerState: Int{
    case Singer_Rotate
    case Mutiple_Rotate
    case Random_Rotate
    case NotInit
}

class videoPlayer: AVPlayerViewController{
    
    // Singleton
    static let sharedInstance = videoPlayer()
    
    //video player
    private var timer:NSTimer = NSTimer()
    private var videoObserver:NSObjectProtocol! = nil
    
    
    // Video Player Data
    private var currentPathName:String = String()
    private var currentDirectoryName:String = String()
    
    // Video Player State
    private var currentState:videoPlayerState = videoPlayerState.NotInit
    private var currentPlayMode:currentAmblum = currentAmblum.NotInit
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func setVideoData(currentPlay:currentAmblum,currentPath:String,currentDirectory:String){
        
        if(currentState == videoPlayerState.NotInit){
            playerViewController.sharedInstance.view.hidden = false
            self.addObserverForVideo()
        }
        
        self.currentPlayMode = currentPlay
        self.currentPathName = currentPath
        self.currentDirectoryName = currentDirectory
        
        if(playerViewController.sharedInstance.segmentController.selectedSegmentIndex == 0){
            self.currentState = videoPlayerState.Mutiple_Rotate
        }else if(playerViewController.sharedInstance.segmentController.selectedSegmentIndex == 1){
            self.currentState = videoPlayerState.Singer_Rotate
        }else if(playerViewController.sharedInstance.segmentController.selectedSegmentIndex == 2){
            self.currentState = videoPlayerState.Random_Rotate
        }
        
        self.playVideo()
        self.addObserver((self.view.superview?.nextResponder())!, forKeyPath: "videoBounds", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    private func playVideo(){
        let currentDic:OrderedDictionary = getCurrentFolder()
        let finalpath:NSURL = NSURL(string:currentDic[currentPathName]!)!
        player = AVPlayer(URL: finalpath)
        player?.play()
    }
    
    private func addObserverForVideo(){
        if((videoObserver) != nil){
           NSNotificationCenter.defaultCenter().removeObserver(videoObserver)
        }
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        videoObserver = notificationCenter.addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: nil, queue: mainQueue) { _ in
            self.playNextSong()
        }
    }
    
    func playPrevSong() {
        if( self.currentState == videoPlayerState.Mutiple_Rotate){
            let currentDic:OrderedDictionary = self.getCurrentFolder()
            if(currentDic.count == 0){
                let alert:UIAlertView = UIAlertView(title: "Playlist that does not exit", message: "The playlist you are playing does not exit anymore. Please play another", delegate: self, cancelButtonTitle: "OK")
                self.clear()
                alert.show()
                return
            }
            
            var currentIndex:NSInteger = 0
            if(currentDic.array.contains(self.currentPathName)){
                currentIndex = currentDic.indexOfKey(self.currentPathName)
            }else if(currentDic.count == 0){
                let alert:UIAlertView = UIAlertView(title: "No Video", message: "There is no more video left in this playlist. Please add some videos.", delegate: self, cancelButtonTitle: "OK")
                self.clear()
                alert.show()
                return
            }
            
            var newIndex:NSInteger = currentIndex - 1
            if( newIndex < 0){
                newIndex = currentDic.count - 1
            }
            self.currentPathName = currentDic[newIndex].0
            self.playVideo()
        }else{
            self.playNextSong()
        }
    }
    
    func playNextSong() {
        if( self.currentState == videoPlayerState.Mutiple_Rotate){
            let currentDic:OrderedDictionary = self.getCurrentFolder()
            if(currentDic.count == 0){
                let alert:UIAlertView = UIAlertView(title: "Playlist that does not exit", message: "The playlist you are playing does not exit anymore. Please play another", delegate: self, cancelButtonTitle: "OK")
                self.clear()
                alert.show()
                return
            }
            
            var currentIndex:NSInteger = 0
            if(currentDic.array.contains(self.currentPathName)){
                currentIndex = currentDic.indexOfKey(self.currentPathName)
            }else if(currentDic.count == 0){
                let alert:UIAlertView = UIAlertView(title: "No Video", message: "There is no more video left in this playlist. Please add some videos.", delegate: self, cancelButtonTitle: "OK")
                self.clear()
                alert.show()
                return
            }
            
            var newIndex:NSInteger = currentIndex + 1
            if( newIndex >= currentDic.count){
                newIndex = 0
            }
            self.currentPathName = currentDic[newIndex].0
            self.playVideo()
        }else if(self.currentState == videoPlayerState.Singer_Rotate){
            let currentDic:OrderedDictionary = self.getCurrentFolder()
            if(currentDic.count == 0){
                let alert:UIAlertView = UIAlertView(title: "Playlist Error", message: "There is no more video left in the playist or the playist doesn't exist anymore.", delegate: self, cancelButtonTitle: "OK")
                self.clear()
                alert.show()
                return
            }
            
            if(currentDic.array.contains(self.currentPathName)){
                self.playVideo()
            }else{
                let alert:UIAlertView = UIAlertView(title: "Video does not exit", message: "The video you are playing does not exit anymore. Please play another", delegate: self, cancelButtonTitle: "OK")
                self.clear()
                alert.show()
                return
            }
        }else if(self.currentState == videoPlayerState.Random_Rotate){
            let currentDic:OrderedDictionary = self.getCurrentFolder()
            if(currentDic.count == 0){
                let alert:UIAlertView = UIAlertView(title: "Playlist Error", message: "There is no more video left in the playist or the playist doesn't exist anymore.", delegate: self, cancelButtonTitle: "OK")
                self.clear()
                alert.show()
                return
            }
            if( currentDic.count == 0){
                let alert:UIAlertView = UIAlertView(title: "No Video", message: "There is no more video left in this playlist. Please add some videos.", delegate: self, cancelButtonTitle: "OK")
                self.clear()
                alert.show()
                return
            }
            let newIndex:NSInteger =  NSInteger(arc4random_uniform(UInt32(currentDic.count)))
            self.currentPathName = currentDic[newIndex].0
            self.playVideo()
        }
    }
    
    private func getCurrentFolder() -> OrderedDictionary{
        switch(currentPlayMode){
        case currentAmblum.All:
            return Helper.sharedInstance.allAmblum
        case currentAmblum.Singer:
            if(!Array(Helper.sharedInstance.singerAmblum.keys).contains(currentDirectoryName)){
                return OrderedDictionary()
            }
            return Helper.sharedInstance.singerAmblum[currentDirectoryName]!
        case currentAmblum.Playist:
            if(!Array(Helper.sharedInstance.playistAmblum.keys).contains(currentDirectoryName)){
                return OrderedDictionary()
            }
            return Helper.sharedInstance.playistAmblum[currentDirectoryName]!
        default:
            return OrderedDictionary()
        }
    }
    
    func setCurrentState(state:videoPlayerState){
        currentState = state
    }
    
    func setCurrentPlayMode(mode:currentAmblum){
        currentPlayMode = mode
    }
    
    func clear(){
        if((videoObserver) != nil){
            NSNotificationCenter.defaultCenter().removeObserver(videoObserver)
        }
        self.view.superview?.hidden = true
        self.removeObserver((self.view.superview?.nextResponder())!, forKeyPath: "videoBounds")
        player?.replaceCurrentItemWithPlayerItem(nil)
        currentState = videoPlayerState.NotInit
        currentPlayMode = currentAmblum.NotInit
    }
    
    func applicationDidEnterBackground(notification:NSNotification){
        self.performSelector("playInBackground", withObject: nil, afterDelay: 0.01)
    }

    func playInBackground(){
        self.player?.play()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.player?.pause()
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        switch (event!.subtype){
        case UIEventSubtype.RemoteControlTogglePlayPause:
            if(self.player?.rate == 0){
                player?.play()
            }else{
                player?.pause()
            }
            break
        case UIEventSubtype.RemoteControlPlay:
            player?.play()
            break
        case UIEventSubtype.RemoteControlPause:
            player?.pause()
            break
        case UIEventSubtype.RemoteControlNextTrack:
            self.playNextSong()
            break
        case UIEventSubtype.RemoteControlPreviousTrack:
            self.playPrevSong()
            break
        default:
            break
        }
    }
}

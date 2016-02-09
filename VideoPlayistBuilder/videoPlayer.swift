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
    }
    
    func setVideoData(currentPlay:currentAmblum,currentPath:String,currentDirectory:String){
        
        if(currentState == videoPlayerState.NotInit){
            playerViewController.sharedInstance.view.hidden = false
            self.addObserverForVideo()
        }
        
        self.currentPlayMode = currentPlay
        self.currentPathName = currentPath
        self.currentDirectoryName = currentDirectory
        self.currentState = videoPlayerState.Mutiple_Rotate
        self.playVideo()
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
            
            if( self.currentState == videoPlayerState.Mutiple_Rotate){
                let currentDic:OrderedDictionary = self.getCurrentFolder()
                
                var currentIndex:NSInteger = 0
                if(currentDic.array.contains(self.currentPathName)){
                    currentIndex = currentDic.indexOfKey(self.currentPathName)
                }
            
                var newIndex:NSInteger = currentIndex + 1
                if( newIndex >= currentDic.count){
                    newIndex = 0
                }
                self.currentPathName = currentDic[newIndex].0
                self.playVideo()
            }else if(self.currentState == videoPlayerState.Singer_Rotate){
                self.playVideo()
            }else if(self.currentState == videoPlayerState.Random_Rotate){
                let currentDic:OrderedDictionary = self.getCurrentFolder()
                let newIndex:NSInteger =  NSInteger(arc4random_uniform(UInt32(currentDic.count)))
                self.currentPathName = currentDic[newIndex].0
                self.playVideo()
            }
            
        }
    }
    
    private func getCurrentFolder() -> OrderedDictionary{
        switch(currentPlayMode){
        case currentAmblum.All:
            return Helper.sharedInstance.allAmblum
        case currentAmblum.Singer:
            return Helper.sharedInstance.singerAmblum[currentDirectoryName]!
        case currentAmblum.Playist:
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
        player?.replaceCurrentItemWithPlayerItem(nil)
        currentState = videoPlayerState.NotInit
        currentPlayMode = currentAmblum.NotInit
    }
}

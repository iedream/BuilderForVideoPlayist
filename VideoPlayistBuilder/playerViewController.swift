//
//  playerViewController.swift
//  VideoPlayistBuilder
//
//  Created by Catherine Zhao on 2016-02-08.
//  Copyright © 2016 Catherine. All rights reserved.
//

import Foundation
import UIKit

class playerViewController: UIViewController {
    
    // Singleton
    static let sharedInstance = playerViewController()
    
    var min:Bool = true
    
    let segmentController:UISegmentedControl = UISegmentedControl.init(items: ["Multi","Single","Shuffle"])
    var tabBarControllerViewFrame:CGRect = CGRectMake(0, 0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set View Controller and Video Player Size to Minimize Mode
        self.view.frame = CGRectMake(tabBarControllerViewFrame.width-120,0,120,120)
        self.view.backgroundColor = UIColor.whiteColor()
        videoPlayer.sharedInstance.view.frame = CGRectMake(0,0,self.view.frame.width,self.view.frame.height)
        self.view.addSubview(videoPlayer.sharedInstance.view)
        
        // Init Segment Controller
        segmentController.selectedSegmentIndex = 0
        self.segmentController.frame.origin = CGPointMake(tabBarControllerViewFrame.width*0.1, tabBarControllerViewFrame.height-tabBarControllerViewFrame.height*0.25+20)
        self.segmentController.hidden = true
        self.view.addSubview(segmentController)
        
        // Add Target for Segment Controller
        segmentController.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Hide All View At Beginning
        segmentController.hidden = true
        self.view.hidden = true
        
        // Init gesture recognizer
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeUp:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeLeft:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeDown)
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    // MARK: - Set Up Floating Player View -
    
    func respondToSwipeUp(gesture:UIGestureRecognizer){
        self.adjustSize(true, animated: true)
    }
    
    func respondToSwipeDown(gesture:UIGestureRecognizer){
        self.adjustSize(false, animated: true)
    }
    
    func respondToSwipeLeft(gesture:UIGestureRecognizer){
        videoPlayer.sharedInstance.clear()
        self.view.hidden = true
    }
    
    func adjustSize(min:Bool,animated:Bool){
        if(min == true){
            UIView.animateWithDuration(0.5, animations: {
                self.view.frame = CGRectMake(self.tabBarControllerViewFrame.width-120,0,120,120)
                self.segmentController.hidden = true
                videoPlayer.sharedInstance.view.frame = CGRectMake(0,0,self.view.frame.width,self.view.frame.height)
                 //UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
                self.min = true
            })
            
        }else{
            UIView.animateWithDuration(0.5, animations: {
                let wFullSize:CGFloat = self.tabBarControllerViewFrame.width-(self.tabBarControllerViewFrame.width*0.2)
                let hFullSize:CGFloat = self.tabBarControllerViewFrame.height-30-self.tabBarControllerViewFrame.height*0.25
                self.view.frame = CGRectMake(0, 0,self.tabBarControllerViewFrame.width,self.tabBarControllerViewFrame.height)
                self.segmentController.hidden = false
                videoPlayer.sharedInstance.view.frame = CGRectMake(self.tabBarControllerViewFrame.width*0.1, 30, wFullSize, hFullSize)
                self.min = false
            })
        }
        
    }
    
    func segmentChanged(sender:UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            videoPlayer.sharedInstance.setCurrentState(videoPlayerState.Mutiple_Rotate)
        case 1:
            videoPlayer.sharedInstance.setCurrentState(videoPlayerState.Singer_Rotate)
        case 2:
            videoPlayer.sharedInstance.setCurrentState(videoPlayerState.Random_Rotate)
        default:
            videoPlayer.sharedInstance.setCurrentState(videoPlayerState.NotInit)
        }
    }

    func restrictRotation(restriction:Bool){
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.restrictRotation = restriction
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "videoBounds"){
            if(videoPlayer.sharedInstance.videoBounds.width >= tabBarControllerViewFrame.width ){
                NSLog("YEY")
                self.restrictRotation(false)
            }else if(videoPlayer.sharedInstance.videoBounds.width != 0){
                self.restrictRotation(true)
                 UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
                self.adjustSize(min, animated: true)
            }
        }
    }
}

//
//  FirstViewController.swift
//  VideoPlayistBuilder
//
//  Created by Catherine Zhao on 2016-02-02.
//  Copyright © 2016 Catherine. All rights reserved.
//
import UIKit
import MediaPlayer

class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //@IBOutlet weak var containerView: UIView!
    let achoiceTableView:UITableView = UITableView.init()
    @IBOutlet weak var mainTableView: UITableView!
    
    let playerviewController:UIViewController = UIViewController()
    var videoImageDic:[String:UIImage] = [String:UIImage]()
    var localVideoDic:[String:String] = [String:String]()
    var titleArray:[String] = [String]()
    var currentVideoFile:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localVideoDic = Helper.sharedInstance.localAmblum
        videoImageDic = Helper.sharedInstance.localImageDic
        
        // Set Up player View
        playerviewController.view.frame = CGRectMake(self.tabBarController!.view.frame.width-120,0,120,120)
        videoPlayer.sharedInstance.view.frame = CGRectMake(0,0,playerviewController.view.frame.width,playerviewController.view.frame.height)
        playerviewController.view.backgroundColor = UIColor.clearColor()
        playerviewController.view.addSubview(videoPlayer.sharedInstance.view)
        self.tabBarController!.view.addSubview(playerviewController.view)
        
        // Init gesture recognizer
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeUp:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.tabBarController?.view.addGestureRecognizer(swipeDown)
        self.tabBarController!.view.addGestureRecognizer(swipeUp)
        
        // set up table view
        mainTableView.backgroundColor = UIColor.grayColor()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.allowsSelection = false
        
        achoiceTableView.backgroundColor = UIColor.whiteColor()
        achoiceTableView.delegate = self
        achoiceTableView.dataSource = self
        achoiceTableView.hidden = true
        achoiceTableView.registerClass(choiceCell.classForCoder(), forCellReuseIdentifier: "choiceCell")
        self.view.addSubview(achoiceTableView)
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Set Up Floating Player View -
    
    func respondToSwipeUp(gesture:UIGestureRecognizer){
        self.adjustSize(true, animated: true)
    }
    
    func respondToSwipeDown(gesture:UIGestureRecognizer){
        self.adjustSize(false, animated: true)
    }
    
    func adjustSize(min:Bool,animated:Bool){
        if(min == true){
            UIView.animateWithDuration(0.5, animations: {
                 self.playerviewController.view.frame = CGRectMake(self.tabBarController!.view.frame.width-120,0,120,120)
                 self.playerviewController.view.backgroundColor = UIColor.clearColor()
                 videoPlayer.sharedInstance.view.frame = CGRectMake(0,0,self.playerviewController.view.frame.width,self.playerviewController.view.frame.height)
                
            })
            
        }else{
            UIView.animateWithDuration(0.5, animations: {
                let wFullSize:CGFloat = (self.tabBarController?.view.frame.width)!-((self.tabBarController?.view.frame.width)!*0.2)
                let hFullSize:CGFloat = (self.tabBarController?.view.frame.height)!-30-(self.tabBarController?.view.frame.height)!*0.25
                self.playerviewController.view.frame = CGRectMake(0, 0, (self.tabBarController?.view.frame.width)!, (self.tabBarController?.view.frame.height)!)
                self.playerviewController.view.backgroundColor = UIColor.greenColor()
                videoPlayer.sharedInstance.view.frame = CGRectMake((self.tabBarController?.view.frame.width)!*0.1, 30, wFullSize, hFullSize)
            })
        }
            
    }
    
    
    // MARK: -Populate Table Methods -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == mainTableView){
            return localVideoDic.count
        }else{
            return titleArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == mainTableView){
            let cell = mainTableView.dequeueReusableCellWithIdentifier("IpodLibraryCell", forIndexPath: indexPath) as UITableViewCell
        
            let title:String = Array(localVideoDic.keys)[indexPath.row]
        
            cell.textLabel?.text = title
            
            if((videoImageDic[title]) != nil){
                cell.imageView?.image = videoImageDic[title]
            }
            return cell
        }else{
            let cell = achoiceTableView.dequeueReusableCellWithIdentifier("choiceCell", forIndexPath: indexPath) as UITableViewCell
            
            let title:String = titleArray[indexPath.row]
            
            cell.textLabel?.text = title
            return cell
        }
    }
    
    // MARK: - Actions When Table View Cell Selected -
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView != mainTableView){
            achoiceTableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            let folderName:String = titleArray[indexPath.row]
            Helper.sharedInstance.addVideo(currentVideoFile[0], folderName: folderName, videoFile: currentVideoFile[2], fileName: currentVideoFile[1])
            
            if(currentVideoFile[0] == "Playist"){
                 (self.tabBarController?.viewControllers![1] as! SecondViewController).getData()
            }else{
                 (self.tabBarController?.viewControllers![2] as! ThirdViewController).getData()
            }
            (self.tabBarController?.viewControllers![3] as! FourthViewController).getData()
            
            achoiceTableView.hidden = true

        }

    }

    func initSubTableView(title:String,cell:UITableViewCell,buttonTitle:String){
        let newTitleArray:[String] = Helper.sharedInstance.getChosenArray(title)
        
        if(achoiceTableView.hidden == true || titleArray != newTitleArray){
            
            var frame:CGRect = mainTableView.convertRect(cell.frame, toView: nil)
            
            let startY = frame.origin.y + frame.height
            
            let viewWidth20 = self.view.frame.width*0.2
            let viewWidth60 = self.view.frame.width*0.6
            let viewHeight40 = self.view.frame.height*0.4
        
            if(self.view.frame.height-startY > self.view.frame.height*0.5){
                frame = CGRectMake(viewWidth60, startY, viewWidth20*2-5,viewHeight40)
            }else{
                frame = CGRectMake(viewWidth60, frame.origin.y+5-viewHeight40, viewWidth20*2-5,viewHeight40)
            }
            
            
            currentVideoFile.insert(buttonTitle, atIndex: 0)
            currentVideoFile.insert((cell.textLabel?.text)!, atIndex: 1)
            currentVideoFile.insert(localVideoDic[(cell.textLabel?.text!)!]!, atIndex: 2)
            
            achoiceTableView.frame = frame
            achoiceTableView.contentSize = CGSize(width: viewWidth20*2-5, height: self.view.frame.height*0.85-startY)
            titleArray = newTitleArray
            achoiceTableView.reloadData()
            achoiceTableView.hidden = false
        }else{
            achoiceTableView.hidden = true
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == mainTableView){
            achoiceTableView.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


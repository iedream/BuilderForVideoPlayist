//
//  SecondViewController.swift
//  VideoPlayistBuilder
//
//  Created by Catherine Zhao on 2016-02-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playistTableView: UITableView!
    let alert:UIAlertController = UIAlertController.init(title: "New Playlist", message: "Add a New Playlist", preferredStyle: UIAlertControllerStyle.Alert)
    
    var playistAmblum:[String:OrderedDictionary] = Helper.sharedInstance.playistAmblum
    var sectionTitle:String = ""
    var videoImaDic:NSMutableDictionary = NSMutableDictionary()

    let cancelAction:UIAlertAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{(action) in
        
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Up player View
        playerViewController.sharedInstance.tabBarControllerViewFrame = (self.tabBarController?.view.frame)!
        self.tabBarController!.view.addSubview(playerViewController.sharedInstance.view)
        
        self.getData()
        
        alert.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Playist Name"
            textField.clearsOnBeginEditing = true
        })
        let addAction:UIAlertAction = UIAlertAction.init(title: "Add", style: UIAlertActionStyle.Default, handler: {(action) in
            Helper.sharedInstance.writeToFolder("Playist", key:(self.alert.textFields?.first?.text)!)
            (self.tabBarController?.viewControllers![0] as! FirstViewController).getData()
            self.getData()
            
        })
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        playistTableView.delegate = self
        playistTableView.dataSource = self
        playistTableView.backgroundColor = UIColor.grayColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getData(){
        self.videoImaDic = Helper.sharedInstance.localImageDic
        self.playistAmblum = Helper.sharedInstance.playistAmblum
        if(playistTableView != nil){
            playistTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(sectionTitle == ""){
            backButton.hidden = true
            return playistAmblum.count
        }else{
            backButton.hidden = false
            return (playistAmblum[sectionTitle]?.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = playistTableView.dequeueReusableCellWithIdentifier("playistTableCell", forIndexPath: indexPath) as UITableViewCell
        let name:String!
        if(sectionTitle == ""){
            name = Array(playistAmblum.keys)[indexPath.row]
        }else{
            name = playistAmblum[sectionTitle]![indexPath.row].0
        }
        cell.textLabel?.text = name
        if((videoImaDic[name]) != nil){
            cell.imageView?.image = videoImaDic[name] as? UIImage
        }else{
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        playistTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(sectionTitle == ""){
            sectionTitle = Array(playistAmblum.keys)[indexPath.row]
            playistTableView.reloadData()
        }else{
            let name:String = (playistAmblum[sectionTitle]![indexPath.row].0)
            videoPlayer.sharedInstance.setVideoData(currentAmblum.Playist, currentPath: name, currentDirectory: sectionTitle)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            if( sectionTitle == ""){
                 Helper.sharedInstance.removeFolder("Playist", folderName: Array(playistAmblum.keys)[indexPath.row])
                (self.tabBarController?.viewControllers![0] as! FirstViewController).getData()
            }else{
                Helper.sharedInstance.removeVideo("Playist", folderName: sectionTitle, fileName: (playistAmblum[sectionTitle]![indexPath.row].0))
            }
            self.playistAmblum = Helper.sharedInstance.playistAmblum
            playistTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            (self.tabBarController?.viewControllers![3] as! FourthViewController).getData()
        }
    }
 
    @IBAction func back(sender: AnyObject) {
        sectionTitle = ""
        playistTableView.reloadData()
    }
    @IBAction func addToPlayist(sender: AnyObject) {
        self.presentViewController(alert, animated: true, completion: nil)
    }
}


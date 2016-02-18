//
//  ThirdViewController.swift
//  VideoPlayistBuilder
//
//  Created by Catherine Zhao on 2016-02-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

import Foundation
import UIKit

class ThirdViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var singerTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    let alert:UIAlertController = UIAlertController.init(title: "New Singer", message: "Add a New Singer", preferredStyle: UIAlertControllerStyle.Alert)
    
    var singerAmblum:[String:OrderedDictionary] = Helper.sharedInstance.singerAmblum
    var sectionTitle:String = ""
    var videoImaDic:[String:UIImage] = [String:UIImage]()
    
    let cancelAction:UIAlertAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{(action) in
        
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        
        alert.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Singer Name"
            textField.clearsOnBeginEditing = true
        })
        let addAction:UIAlertAction = UIAlertAction.init(title: "Add", style: UIAlertActionStyle.Default, handler: {(action) in
            Helper.sharedInstance.writeToFolder("Singer", key:(self.alert.textFields?.first?.text)!)
            (self.tabBarController?.viewControllers![0] as! FirstViewController).getData()
            self.getData()
            
        })
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        singerTableView.delegate = self
        singerTableView.dataSource = self
        singerTableView.backgroundColor = UIColor.grayColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getData(){
        self.videoImaDic.removeAll()
        self.videoImaDic = Helper.sharedInstance.getVideoImage("Singer")
        self.singerAmblum = Helper.sharedInstance.singerAmblum
        if(singerTableView != nil){
            singerTableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(sectionTitle == ""){
            backButton.hidden = true
            return singerAmblum.count
        }else{
            backButton.hidden = false
            return (singerAmblum[sectionTitle]?.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = singerTableView.dequeueReusableCellWithIdentifier("singerTableCell", forIndexPath: indexPath) as UITableViewCell
        let name:String!
        if(sectionTitle == ""){
            name = Array(singerAmblum.keys)[indexPath.row]
        }else{
            name = singerAmblum[sectionTitle]![indexPath.row].0
        }
        cell.textLabel?.text = name
        if((videoImaDic[name]) != nil){
            cell.imageView?.image = videoImaDic[name]
        }else{
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(sectionTitle == ""){
            sectionTitle = Array(singerAmblum.keys)[indexPath.row]
            singerTableView.reloadData()
        }else{
            let name:String = (singerAmblum[sectionTitle]![indexPath.row].0)
            videoPlayer.sharedInstance.setVideoData(currentAmblum.Singer, currentPath: name, currentDirectory: sectionTitle)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            if( sectionTitle == ""){
                Helper.sharedInstance.removeFolder("Singer", folderName: Array(singerAmblum.keys)[indexPath.row])
                (self.tabBarController?.viewControllers![0] as! FirstViewController).getData()
            }else{
                Helper.sharedInstance.removeVideo("Singer", folderName: sectionTitle, fileName: (singerAmblum[sectionTitle]![indexPath.row].0))
            }
            self.singerAmblum = Helper.sharedInstance.singerAmblum
            singerTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            (self.tabBarController?.viewControllers![3] as! FourthViewController).getData()
        }
    }

    
    @IBAction func addToSinger(sender: AnyObject) {
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func back(sender: AnyObject) {
        sectionTitle = ""
        singerTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
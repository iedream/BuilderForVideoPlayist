//
//  FourthViewController.swift
//  VideoPlayistBuilder
//
//  Created by Catherine Zhao on 2016-02-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

import Foundation
import UIKit

class FourthViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var allTableView: UITableView!
    var allAmblum:OrderedDictionary = Helper.sharedInstance.allAmblum
    var videoImaDic:[String:UIImage] = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        
        allTableView.delegate = self
        allTableView.dataSource = self
        allTableView.backgroundColor = UIColor.grayColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getData(){
        self.videoImaDic.removeAll()
        self.videoImaDic = Helper.sharedInstance.getVideoImage("All")
        self.allAmblum = Helper.sharedInstance.allAmblum
        allTableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAmblum.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = allTableView.dequeueReusableCellWithIdentifier("allTableCell", forIndexPath: indexPath) as! viewControllerCell
        let name:String = allAmblum[indexPath.row].0

        cell.textLabel?.text = name
        if((videoImaDic[name]) != nil){
            cell.imageView?.image = videoImaDic[name]
        }else{
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let name:String = allAmblum[indexPath.row].0
        videoPlayer.sharedInstance.setVideoData(currentAmblum.All, currentPath: name, currentDirectory: "")
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            Helper.sharedInstance.removeVideo("All", folderName: "", fileName: (allAmblum[indexPath.row].0))
            self.allAmblum = Helper.sharedInstance.allAmblum
            allTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            (self.tabBarController?.viewControllers![1] as! SecondViewController).getData()
            (self.tabBarController?.viewControllers![2] as! ThirdViewController).getData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
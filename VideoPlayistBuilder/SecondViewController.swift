//
//  SecondViewController.swift
//  VideoPlayistBuilder
//
//  Created by Catherine Zhao on 2016-02-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var playistTableView: UITableView!
    let alert:UIAlertController = UIAlertController.init(title: "New Playist", message: "Add a New Playist", preferredStyle: UIAlertControllerStyle.Alert)
    
    var playistAmblum:[String:OrderedDictionary<String,String>] = Helper.sharedInstance.playistAmblum
    var sectionTitle:String = ""
    var videoImaDic:[String:UIImage] = [String:UIImage]()

    let cancelAction:UIAlertAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{(action) in
        
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        
        alert.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Playist Name"
        })
        let addAction:UIAlertAction = UIAlertAction.init(title: "Add", style: UIAlertActionStyle.Default, handler: {(action) in
            Helper.sharedInstance.writeToFolder("Playist", key:(self.alert.textFields?.first?.text)!)
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
        self.videoImaDic = Helper.sharedInstance.getVideoImage("Playist")
        self.playistAmblum = Helper.sharedInstance.playistAmblum
        playistTableView.reloadData()
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
            return playistAmblum.count
        }else{
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
            name = playistAmblum[sectionTitle]?.array[indexPath.row]
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
            sectionTitle = Array(playistAmblum.keys)[indexPath.row]
            playistTableView.reloadData()
        }else{
            let name:String = (playistAmblum[sectionTitle]?.array[indexPath.row])!
            videoPlayer.sharedInstance.setVideoData(currentAmblum.Playist, currentPath: name, currentDirectory: sectionTitle)
            sectionTitle = ""
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


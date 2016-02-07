//
//  IpodLibraryCell.swift
//  VideoPlayistBuilder
//
//  Created by Catherine Zhao on 2016-02-04.
//  Copyright © 2016 Catherine. All rights reserved.
//

import Foundation
import UIKit

public class viewControllerCell: UITableViewCell{
    public override func layoutSubviews() {
        super.layoutSubviews()
        let viewWidth20 = self.frame.width*0.2
        let viewWidth70 = self.frame.width*0.7
        self.backgroundColor = UIColor.clearColor()
        self.textLabel?.frame = CGRectMake(viewWidth20+5, 0,viewWidth70 ,self.frame.height)
        self.imageView?.frame = CGRectMake(0, 0, viewWidth20,self.frame.height)
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
    }
}

public class choiceCell: UITableViewCell{
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
    }
}


public class IpodLibraryCell: UITableViewCell{
  
    public override func layoutSubviews() {
        let viewWidth20 = self.frame.width*0.2
        let viewWidth60 = self.frame.width*0.6
        
        let addSingerButton:UIButton = UIButton.init(frame: CGRectMake(viewWidth60,5,viewWidth20-5 ,self.frame.height-5))
        addSingerButton.setTitle("Singer", forState: UIControlState.Normal)
        addSingerButton.backgroundColor = UIColor.yellowColor()
        addSingerButton.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(addSingerButton)
        
        let addPlayistButton:UIButton = UIButton.init(frame: CGRectMake(viewWidth60+viewWidth20, 5, viewWidth20-5, self.frame.height-5))
        addPlayistButton.setTitle("Playist", forState: UIControlState.Normal)
        addPlayistButton.backgroundColor = UIColor.yellowColor()
        addPlayistButton.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(addPlayistButton)
        
        super.layoutSubviews()
        
        self.textLabel?.frame = CGRectMake(viewWidth20+5, 0,viewWidth20*2-5 ,self.frame.height)
        self.imageView?.frame = CGRectMake(0, 0, viewWidth20,self.frame.height)
        
        self.textLabel?.adjustsFontSizeToFitWidth = true
        self.backgroundColor = UIColor.clearColor()
        self.textLabel?.textColor = UIColor.whiteColor()
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.contentView.superview?.clipsToBounds = false
    }
    
    // MARK: - Add Buttons Method -
    func buttonPressed(sender:UIButton){
        
        (self.superview?.superview?.superview?.nextResponder() as! FirstViewController).initSubTableView((sender.titleLabel?.text)!, cell: self, buttonTitle: (sender.titleLabel?.text)!)
        
    }
    
}


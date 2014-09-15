//
//  PullToRefresh1SampleViewController.swift
//  swift-layout
//
//  Created by grachro on 2014/09/15.
//  Copyright (c) 2014年 grachro. All rights reserved.
//

import UIKit

class PullToRefresh1SampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let puller = ScrollViewPuller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maxHeight100:CGFloat = 100
        let autolayoutPullArea = AutolayoutPullArea(minHeight:0,maxHeight:maxHeight100,superview: self.tableView)
        autolayoutPullArea.layout
            .backgroundColor(UIColor(red:1.00,green:0.98,blue:0.80,alpha:1.0))
        
        let text = UILabel()
        text.text = "中央"
        Layout.regist(text, container: autolayoutPullArea.view)
            .horizontalCenterInContainer()
            .verticalCenterInContainer()
        
        var topBarConstraint:NSLayoutConstraint?
        let topBar = UIView()
        Layout.regist(topBar, container: autolayoutPullArea.view)
            .rightIsSameContainer()
            .leftIsSameContainer()
            .height(20).lastConstraint(&topBarConstraint)
            .topIsSameContainer()
            .backgroundColor(UIColor(red:0.50,green:0.50,blue:0.50,alpha:1.0))
        
        
        var bar1HeightConstraint:NSLayoutConstraint?
        let bar1 = UIView()
        Layout.regist(bar1, container: autolayoutPullArea.view)
            .width(50)
            .bottomIsSameContainer()
            .height(70).lastConstraint(&bar1HeightConstraint)
            .left(40).fromContainerLeft()
            .backgroundColor(UIColor(red:0.82,green:0.71,blue:0.55,alpha:1.0))
        
        var bar2HeightConstraint:NSLayoutConstraint?
        let bar2 = UIView()
        Layout.regist(bar2, container: autolayoutPullArea.view)
            .width(50)
            .bottomIsSameContainer()
            .height(50).lastConstraint(&bar2HeightConstraint)
            .right(40).fromContainerRight()
            .backgroundColor(UIColor(red:0.82,green:0.71,blue:0.55,alpha:1.0))
        
        
        
        autolayoutPullArea.pullCallback = {(areaHeight: CGFloat, pullAreaHeight: CGFloat) in
            text.hidden = areaHeight < 20
            
            if areaHeight < 40 {
                topBarConstraint?.constant = 20 - (40 - areaHeight) / 2
            } else {
                topBarConstraint?.constant = 20
            }
            
            let percent = areaHeight / maxHeight100
            bar1HeightConstraint?.constant = 70 * percent
            bar2HeightConstraint?.constant = 50 * percent
        }
        
        puller.begin(self.tableView, pullArea:autolayoutPullArea)
        
        createBaseView()
    }
    
    func createBaseView() {
        
        let header = UIView()
        Layout.regist(header, container: self.view)
            .leftIsSameContainer()
            .rightIsSameContainer()
            .topIsSameContainer()
            .height(50)
            .backgroundColor(UIColor(red:0.94,green:0.50,blue:0.50,alpha:1.0))
        
        let footer = Layout.createSystemTypeBtn("return")
        Layout.regist(footer, container: self.view)
            .leftIsSameContainer()
            .rightIsSameContainer()
            .bottomIsSameContainer()
            .height(50)
            .backgroundColor(UIColor(red:0.94,green:0.50,blue:0.50,alpha:1.0))
            .textColor(UIColor.whiteColor())
        
        Layout.regist(tableView, container: self.view)
            .leftIsSameContainer()
            .rightIsSameContainer()
            .top(0).fromBottom(header)
            .bottom(0).fromTop(footer)
            .backgroundColor(UIColor.lightGrayColor())
        
        
        footer.addTarget(self, action: "goview2", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    //UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if indexPath.row == 0 {
            cell.textLabel?.text = "下に引っ張る"
        } else {
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    
    //スクロール開始
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        self.puller.beginDragScroll(scrollView)
    }
    
    //スクロール終了
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        self.puller.endDragScroll(scrollView, willDecelerate: decelerate)
    }
    
    //
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!)  {
        self.puller.endScroll(scrollView)
    }
    
    //スクロール中
    //UITableViewDelegate:UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        self.puller.dragScroll(scrollView)
    }
    
    
    func goview2() {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}


//
//  NewVersionViewController.swift
//  Flower
//
//  Created by victoria on 16/6/30.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

// Scrolling state.
enum ScrollingState:Int {
    case ScrollingStateAuto   //手动
    case ScrollingStateManual //自动
    case ScrollingStateLooping//循环
};

class NewVersionViewController: UIViewController,UIScrollViewDelegate {
    var frontLayerView:UIImageView!
    var backLayerView:UIImageView!
    var gradientView:UIImageView!
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var button:UIButton!
    
    var pages:[String]?
    var currentPageIndex = 0
    var nextPageIndex = 0
    var currentState:ScrollingState = .ScrollingStateAuto
    var autoScrollEnabled:Bool = true

    init(pages:[String]){
        self.pages = pages
        super.init(nibName: nil, bundle: nil)
        
        self.frontLayerView = UIImageView()
        self.backLayerView = UIImageView()
        self.gradientView = UIImageView()
        self.scrollView = UIScrollView()
        self.pageControl = UIPageControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor()
        self.setViewController()
        self.setOriginLayersState()
    }
    
    func setViewController() {
        self.frontLayerView.frame = self.view.bounds
        self.backLayerView.frame = self.view.bounds
        
        // Decoration装饰
        self.gradientView.image = UIImage(named: "background-gradient" )
        
        // ScrollView configuration--ScrollView布局
        self.scrollView.frame = self.view.bounds
        self.scrollView.delegate = self
        self.scrollView.pagingEnabled = true
        
        self.scrollView.contentSize = CGSizeMake(CGFloat(self.numberOfPages())*self.view.frame.size.width, self.scrollView.contentSize.height)
        
        // PageControl configuration.
        self.pageControl.numberOfPages = self.numberOfPages()
        self.pageControl.currentPage = 0
        self.pageControl.addTarget(self, action: #selector(NewVersionViewController.didClickOnPageControl), forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(self.frontLayerView)
        self.view.addSubview(self.backLayerView)
        self.view.addSubview(self.gradientView)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(pageControl)
        
        self.button = UIButton(type:.Custom)
        self.button.addTarget(self, action: #selector(NewVersionViewController.goToMain), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.button)
        self.addAllConstraints()
    }
    
    func goToMain() {
        let tab = TabBarViewController()
        self.presentViewController(tab, animated: true) { 
            
        }
    }
    
    func addAllConstraints() {
        self.frontLayerView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
        self.backLayerView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint.init(item: self.button, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 140))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.button, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -20))
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint.init(item: self.pageControl, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.pageControl, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.pageControl, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 32))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -60))
        
        let views:[String:AnyObject] = ["gradientView":self.gradientView,"superView":self.view]
        var constraints:[String]=[]

        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append("V:[gradientView(==200)]-0-|")
        constraints.append("H:|-0-[gradientView]-0-|")
        
        for string:String in constraints {
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(string, options:.AlignAllCenterY, metrics: nil, views: views))
        }
    }
    
    func numberOfPages() -> Int {
        if self.pages != nil{
            return self.pages!.count
        }else{
            return 0
        }
    }
    
    @objc func didClickOnPageControl(sender:UIPageControl){
        self.stopScrolling()
        self.scrollingToNextPageWithOffset(CGFloat(sender.currentPage))
    }
    
    func animateScrolling() {
        if self.currentState == .ScrollingStateManual {
            return
        }
        
        //跳转下一页
        var nextPage = self.currentPageIndex + 1
        if nextPage == self.numberOfPages() {
            //停止自动滚动
            if self.autoScrollEnabled==false {
                self.currentState = .ScrollingStateManual
                return
            }
            
            //跳转第一页
            nextPage = 0
            self.currentState = .ScrollingStateLooping
            self.setOriginLayerAlpha()
            self.setBackLayerPictureWithPageIndex(-1)
        }else{
            self.currentState = .ScrollingStateAuto
        }
        
        // Make the scrollView animation.
        self.scrollToNextPageIndex(nextPage)
        // Call the next animation after X seconds.
        self.autoScrollToNextPage()
    }
    
    // Call the next animation after X seconds.
    func autoScrollToNextPage(){
        if self.autoScrollEnabled == true {
            self.performSelector(#selector(NewVersionViewController.animateScrolling),withObject: nil,afterDelay: 3.0)
        }
    }
    
    func scrollToNextPageIndex(nextPageIndex:Int){
        // Make the scrollView animation.
        self.scrollView.setContentOffset(CGPointMake(CGFloat(nextPageIndex) * self.view.frame.size.width, 0), animated: true)
        // Set the PageControl on the right page.
        self.pageControl.currentPage = nextPageIndex
    }
    
    //Run it.
    func startScrolling()  {
        self.autoScrollToNextPage()
    }
    
    //Manually stop the scrolling
    func stopScrolling(){
        self.currentState = ScrollingState.ScrollingStateManual
    }
    
    func setBackLayerPictureWithPageIndex(index:Int) {
        self.setBackgroundImage(self.backLayerView, index: index + 1)
    }
    
    func setFrontLayerPictureWithPageIndex(index:Int){
        self.setBackgroundImage(self.frontLayerView, index: index)
    }
    
    func setBackgroundImage(imageView:UIImageView,index:Int) {
        if index >= self.pages?.count {
            imageView.image = nil
            return
        }
        if self.pages == nil {
            imageView.image = nil
            return
        }else{
            imageView.image = UIImage(named: self.pages![index])
        }
    }
    
    func setOriginLayerAlpha(){
        self.frontLayerView.alpha = 1
        self.backLayerView.alpha = 0;
    }
    
    func setOriginLayersState(){
        self.currentState = .ScrollingStateAuto
        self.backLayerView.backgroundColor = UIColor.blackColor()
        self.frontLayerView.backgroundColor = UIColor.blackColor()
        self.setLayersPicturesWithIndex(0)
    }
    
    func setLayersPicturesWithIndex(index:Int){
        self.currentPageIndex = index
        self.setOriginLayerAlpha()
        self.setFrontLayerPictureWithPageIndex(index)
        self.setBackLayerPictureWithPageIndex(index)
    }
    
    func disolveBackgroundWithContentOffset(offset:CGFloat){
        if self.currentState == ScrollingState.ScrollingStateLooping {
            self.scrollingToFirstPageWithOffset(offset)
        }else{
            self.scrollingToNextPageWithOffset(offset)
        }
    }
    
    func scrollingToFirstPageWithOffset(offset:CGFloat){
        let offsetReplace = (offset * self.view.frame.size.width) / (self.view.frame.size.width * CGFloat(self.numberOfPages()))
        let backLayerAlpha:CGFloat = (1.0 - offsetReplace)
        let frontLayerAlpha:CGFloat = offsetReplace
        self.backLayerView.alpha = backLayerAlpha
        self.frontLayerView.alpha = frontLayerAlpha
    }
    
    func scrollingToNextPageWithOffset(offset:CGFloat) {
        let nextPage:Int = Int(offset)
        let alphaValue:CGFloat = offset - CGFloat(nextPage)
        if (alphaValue < 0) && self.currentPageIndex == 0 {
            self.backLayerView.image = nil
            self.frontLayerView.alpha = 1.0 + alphaValue
            return
        }
        if nextPage != self.currentPageIndex || ((nextPage == self.currentPageIndex) && (0.0 < offset) && (offset < 1.0)) {
            self.setLayersPicturesWithIndex(nextPage)
        }
        let backLayerAlpha = alphaValue
        let frontLayerAlpha = (1.0 - alphaValue)
        
        self.backLayerView.alpha = backLayerAlpha
        self.frontLayerView.alpha = frontLayerAlpha
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollingPosition:CGFloat = scrollView.contentOffset.x / self.view.frame.size.width
        var nextPageIndex0 = Int(scrollingPosition)
        if self.currentState == ScrollingState.ScrollingStateLooping {
            nextPageIndex0 = 0
        }
        if nextPageIndex0 != self.nextPageIndex {
            self.nextPageIndex = nextPageIndex0
        }
        if self.nextPageIndex == (self.numberOfPages() - 1) {
            
        }
        
        self.disolveBackgroundWithContentOffset(scrollingPosition)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.scrollView.tracking {
            self.stopScrolling()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageControl.currentPage = self.currentPageIndex
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

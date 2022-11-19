//
//  ContainerViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

open class TabBarPagerController : UIViewController, UIScrollViewDelegate {
    
    ///  controller's view safeAreaLayoutGuide.topAnchor to bottomAnchor
    public var bottomViewFrameLayoutGuide: UILayoutGuide!
    
    private var containerScrollView: UIScrollView! //contains headerVC + bottomVC
    private var overlayScrollView: UIScrollView! //handles whole scroll logic
    private var panViews: [Int: UIView] = [:] {// bottom view(s)/scrollView(s)
        didSet{
            if let scrollView = panViews[currentIndex] as? UIScrollView{
                scrollView.panGestureRecognizer.require(toFail: overlayScrollView.panGestureRecognizer)
                scrollView.donotAdjustContentInset()
                scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
            }
        }
    }

    private var currentIndex: Int = 0
    
    private var pagerTabHeight: CGFloat{
        return bottomVC.pagerTabHeight ?? 44
    }
    
    weak open var dataSource: TabBarPagerControllerDataSource!
    weak open var delegate: TabBarPagerControllerDelegate?
    
    private var headerView: UIView!{
        return headerVC.view
    }
    
    private var bottomView: UIView!{
        return bottomVC.view
    }
    
    private var headerVC: UIViewController!
    private var bottomVC: (UIViewController & TabBarPageViewController)!

    private var contentOffsets: [Int: CGFloat] = [:]
    
    
    deinit {
        self.panViews.forEach({ (arg0) in
            let (_, value) = arg0
            if let scrollView = value as? UIScrollView{
                scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
            }
        })
    }
    
    open override func loadView() {
        // add bottom view layout guide
        bottomViewFrameLayoutGuide = UILayoutGuide()
        bottomViewFrameLayoutGuide.identifier = "ignore the safe top area"
        
        ///add container scroll view and put headerVC and  bottomPagerVC inside. content size will be superview height + header height.
        containerScrollView = UIScrollView()
        containerScrollView.scrollsToTop = false
        containerScrollView.showsVerticalScrollIndicator = false
        
        ///add overlay scroll view for handling content offsets. content size will be superview height + bottom view contentSize (if UIScrollView) or height (if UIView)
        overlayScrollView = UIScrollView()
        overlayScrollView.showsVerticalScrollIndicator = false
        overlayScrollView.backgroundColor = UIColor.clear

        ///wrap all in a UIView
        let view = UIView()
        view.addLayoutGuide(bottomViewFrameLayoutGuide)
        view.addSubview(overlayScrollView)
        view.addSubview(containerScrollView)
        self.view = view
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        /// Configure bottom controller‘s frame
        NSLayoutConstraint.activate([
            bottomViewFrameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomViewFrameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomViewFrameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomViewFrameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        ///Configure overlay scroll
        overlayScrollView.delegate = self
        overlayScrollView.layer.zPosition = CGFloat.greatestFiniteMagnitude
        overlayScrollView.donotAdjustContentInset()
        overlayScrollView.pinEdges(to: self.view)

        ///Configure container scroll
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        containerScrollView.donotAdjustContentInset()
        containerScrollView.pinEdges(to: self.view)
        
        ///Add header view controller
        headerVC = dataSource.headerViewController()
        add(headerVC, to: containerScrollView)
        headerView.constraint(to: containerScrollView, attribute: .leading, secondAttribute: .leading)
        headerView.constraint(to: containerScrollView, attribute: .trailing, secondAttribute: .trailing)
        headerView.constraint(to: containerScrollView, attribute: .top, secondAttribute: .top)
        headerView.constraint(to: containerScrollView, attribute: .width, secondAttribute: .width)
        
        ///Add bottom view controller
        bottomVC = dataSource.bottomViewController()
        bottomVC.tabBarPageViewDelegate = self
        add(bottomVC, to: containerScrollView)
        if let vc = bottomVC.currentViewController{
            self.panViews[currentIndex] = vc.panView()
        }
        bottomView.constraint(to: containerScrollView, attribute: .leading, secondAttribute: .leading)
        bottomView.constraint(to: containerScrollView, attribute: .trailing, secondAttribute: .trailing)
        bottomView.constraint(to: containerScrollView, attribute: .bottom, secondAttribute: .bottom)
        bottomView.constraint(to: headerView, attribute: .top, secondAttribute: .bottom)
        bottomView.constraint(to: containerScrollView, attribute: .width, secondAttribute: .width)
        bottomView.heightAnchor.constraint(equalTo: bottomViewFrameLayoutGuide.heightAnchor).isActive = true
        
        ///let know others scroll view configuration is done
        delegate?.tabBarPagerController(self, didScroll: overlayScrollView)
    }
    
    private func updateOverlayScrollContentSize(with bottomView: UIView){
        self.overlayScrollView.contentSize = getContentSize(for: bottomView)
    }
    
    private func getContentSize(for bottomView: UIView) -> CGSize{
        if let scroll = bottomView as? UIScrollView{
            let bottomHeight = max(scroll.contentSize.height, self.view.frame.height - dataSource.minHeaderHeight() - pagerTabHeight - bottomInset)
            return CGSize(width: scroll.contentSize.width,
                          height: bottomHeight + headerView.frame.height + pagerTabHeight + bottomInset)
        }else{
            let bottomHeight = self.view.frame.height - dataSource.minHeaderHeight() - pagerTabHeight
            return CGSize(width: bottomView.frame.width,
                          height: bottomHeight + headerView.frame.height + pagerTabHeight + bottomInset)
        }
        
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UIScrollView,
            keyPath == #keyPath(UIScrollView.contentSize) {
            if let scroll = self.panViews[currentIndex] as? UIScrollView, obj == scroll {
                updateOverlayScrollContentSize(with: scroll)
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsets[currentIndex] = scrollView.contentOffset.y
        let topHeight = bottomView.frame.minY - dataSource.minHeaderHeight()
        
        if scrollView.contentOffset.y < topHeight{
            self.containerScrollView.contentOffset.y = scrollView.contentOffset.y
            self.panViews.forEach({ (arg0) in
                let (_, value) = arg0
                (value as? UIScrollView)?.contentOffset.y = 0
            })
            contentOffsets.removeAll()
        }else{
            self.containerScrollView.contentOffset.y = topHeight
            (self.panViews[currentIndex] as? UIScrollView)?.contentOffset.y = scrollView.contentOffset.y - self.containerScrollView.contentOffset.y
            
        }
        
        let progress = self.containerScrollView.contentOffset.y / topHeight
        
        self.delegate?.tabBarPagerController(self, scrollView: self.containerScrollView, didUpdate: progress)
    }
}

//MARK: BottomPageDelegate
extension TabBarPagerController : TabBarPageViewDelegate {

    public func pageViewController(_ currentViewController: UIViewController?, didSelectPageAt index: Int) {
        currentIndex = index

        if let offset = contentOffsets[index]{
            self.overlayScrollView.contentOffset.y = offset
        }else{
            self.overlayScrollView.contentOffset.y = self.containerScrollView.contentOffset.y
        }
        
        if let vc = currentViewController, self.panViews[currentIndex] == nil{
            self.panViews[currentIndex] = vc.panView()
        }
        
        
        if let panView = self.panViews[currentIndex]{
            updateOverlayScrollContentSize(with: panView)
        }
    }

}

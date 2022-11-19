//
//  ViewController.swift
//  TabBarPager
//
//  Created by ilumanxi on 11/19/2022.
//  Copyright (c) 2022 ilumanxi. All rights reserved.
//

import UIKit
import TabBarPager
import Tabman
import Pageboy

class ViewController: UIViewController, TabBarPagerControllerDelegate, TabBarPagerControllerDataSource {
   
    
    
    
    func headerViewController() -> UIViewController {
        headerVC
    }
    
    
    func bottomViewController() -> UIViewController & TabBarPager.TabBarPageViewController {
            bottomPageVC
    }
    
    func minHeaderHeight() -> CGFloat {
        return view.safeAreaInsets.top
    }
    
    func tabBarPagerController(_ tabBarPagerController: TabBarPager.TabBarPagerController, scrollView: UIScrollView, didUpdate progress: CGFloat) {
        
    }
    
    func tabBarPagerController(_ tabBarPagerController: TabBarPager.TabBarPagerController, didScroll scrollView: UIScrollView) {
        
    }
    
    
    
    let headerVC = HeaderViewController()
    let bottomPageVC = ButtonBarExampleViewController()
    
    let tabBarPagerController = TabBarPagerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addTabBarPagerController()
        
    }
    
    
    private func addTabBarPagerController() {
        tabBarPagerController.delegate = self
        tabBarPagerController.dataSource = self
        addChild(tabBarPagerController)
        tabBarPagerController.view.frame = view.bounds
        tabBarPagerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tabBarPagerController.view)
        tabBarPagerController.didMove(toParent: self)
    }

}

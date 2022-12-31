//
//  TabBarPagerControllerDelegate.swift
//  TabBarPager
//
//  Created by 风起兮 on 12/22/2022.
//  Copyright (c) 2019 风起兮. All rights reserved.
//

import UIKit

public protocol TabBarPagerControllerDelegate: AnyObject{
    
    func tabBarPagerController(_ tabBarPagerController: TabBarPagerController, scrollView: UIScrollView, didUpdate progress: CGFloat)
    
    func tabBarPagerController(_ tabBarPagerController: TabBarPagerController, didScroll scrollView: UIScrollView)
}




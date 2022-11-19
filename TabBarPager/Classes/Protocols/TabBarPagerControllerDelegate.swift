//
//  TPProgressDelegate.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

public protocol TabBarPagerControllerDelegate: AnyObject{
    
    func tabBarPagerController(_ tabBarPagerController: TabBarPagerController, scrollView: UIScrollView, didUpdate progress: CGFloat)
    
    func tabBarPagerController(_ tabBarPagerController: TabBarPagerController, didScroll scrollView: UIScrollView)
}




//
//  TabBarPagerControllerDataSource.swift
//  TabBarPager
//
//  Created by 风起兮 on 12/22/2022.
//  Copyright (c) 2019 风起兮. All rights reserved.
//

import UIKit

public protocol TabBarPagerControllerDataSource: AnyObject {
    func headerViewController() -> UIViewController
    func bottomViewController() -> UIViewController & TabBarPageViewController
    func minHeaderHeight() -> CGFloat //stop scrolling headerView at this point
}

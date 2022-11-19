//
//  TPDataSource.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

public protocol TabBarPagerControllerDataSource: AnyObject {
    func headerViewController() -> UIViewController
    func bottomViewController() -> UIViewController & TabBarPageViewController
    func minHeaderHeight() -> CGFloat //stop scrolling headerView at this point
}

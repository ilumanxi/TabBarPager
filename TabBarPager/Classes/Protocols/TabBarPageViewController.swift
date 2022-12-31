//
//  TabBarPageViewController.swift
//  TabBarPager
//
//  Created by 风起兮 on 12/22/2022.
//  Copyright (c) 2019 风起兮. All rights reserved.
//

import UIKit

public protocol TabBarPageViewController: AnyObject {
    var tabBarPageViewDelegate: TabBarPageViewDelegate? {get set}
    var currentViewController: UIViewController? {get}
    var pagerTabHeight: CGFloat? {get}
}

//
//  TabBarPageViewDelegate.swift
//  TabBarPager
//
//  Created by 风起兮 on 12/22/2022.
//  Copyright (c) 2019 风起兮. All rights reserved.
//

import UIKit

public protocol TabBarPageViewDelegate: AnyObject {
    func pageViewController(_ currentViewController: UIViewController?, didSelectPageAt index: Int)
}

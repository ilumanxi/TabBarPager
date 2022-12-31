//
//  TabBarPagePannableView.swift
//  TabBarPager
//
//  Created by 风起兮 on 12/22/2022.
//  Copyright (c) 2019 风起兮. All rights reserved.
//

import UIKit

public protocol TabBarPagePannableView {
    func panView() -> UIView
}

extension UIViewController: TabBarPagePannableView{
    @objc open func panView() -> UIView{
        if let scroll = self.view.subviews.first(where: {$0 is UIScrollView}){
            return scroll
        }else{
            return self.view
        }
    }
}

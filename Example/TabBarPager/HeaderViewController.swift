//
//  HeaderViewController.swift
//  TabBarPager_Example
//
//  Created by 帆帆  on 2022/11/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import TabBarPager

class HeaderViewController: UIViewController {
    
    
    let textView  = UITextView()
    
    override func loadView() {
        super.loadView()
        view.addSubview(textView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
        textView.text = """
        From the first day of the SwiftUI framework, we have primary layout containers like VStack, HStack, and ZStack. The current iteration of the SwiftUI framework brings another layout container allowing us to place views in a grid. But the most important addition was the Layout protocol that all layout containers conform to. It also allows us to build our super-custom layout containers from scratch. This week we will learn the basics of the Layout protocol in SwiftUI and how to build conditional layouts using AnyLayout type.
        """
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

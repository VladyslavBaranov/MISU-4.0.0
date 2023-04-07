//
//  MainTabBarStructEnum.swift
//  CoronaVirTracker
//
//  Created by WH ak on 15.05.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import UIKit
import SwiftUI

enum MainTabBarItem: Int, CaseIterable {
    
    case profile = 0
    case assistance = 1
    case watch = 2
    
    var viewController: UIViewController {
        switch self {
        case .profile:
            let _vc = MenuMainHostingController.createInstance()
            _vc.tabBarItem = tabBarItem
            return _vc
        case .assistance:
            let _vc = MainAssistanceHostingController.createInstance()
            _vc.tabBarItem = tabBarItem
            return _vc
        default:
			let _vc = WatchMainPageHostingController(rootView: .init())
			let navController = UINavigationController(rootViewController: _vc)
            
			navController.tabBarItem = tabBarItem
            return navController
        }
    }
    
    private var tabBarItem: UITabBarItem {
        let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        item.tag = rawValue
        item.setTitleTextAttributes([NSAttributedString.Key.font: CustomFonts.createUIInter(weight: .regular, size: 11)], for: .normal)
        return item
    }
    
    private var image: UIImage? {
        return UIImage(named: imageName)
    }
    
    private var selectedImage: UIImage? {
        return UIImage(named: selectedImageName)
    }
    
    private var imageName: String {
        switch self {
        case .assistance:
            return "misuIconUnSelect"
        case .watch:
            return "deviceIconUnSelect"
        case .profile:
            return "deskIconUnSelect"
        }
    }
    
    private var selectedImageName: String {
        switch self {
        case .assistance:
            return "misuIconSelect"
        case .watch:
            return "deviceIconSelect"
        case .profile:
            return "deskIconSelect"
        }
    }
    
    private var title: String {
        switch self {
        case .assistance:
            return locStr("mah_str_5")
        case .watch:
            return locStr("mah_str_20")
        case .profile:
            return locStr("mah_str_19")
        }
    }
    
    private var localized: String {
        switch self {
        case .assistance:
            return NSLocalizedString("Assistance", comment: "")
        case .watch:
            return NSLocalizedString("Watch", comment: "")
        case .profile:
            return NSLocalizedString("Medical ID", comment: "")
        }
    }
}

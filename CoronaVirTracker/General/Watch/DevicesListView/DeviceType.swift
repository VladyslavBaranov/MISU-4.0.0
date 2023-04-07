//
//  DeviceType.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 21.10.2021.
//  Copyright © 2021 CVTCompany. All rights reserved.
//

import Foundation
import UIKit

enum DeviceType: Int, CaseIterable, EnumKit {
    case TrusangZHJBT = 0
    case AppleHK = 1
    case YCProduct = 2
    
    var manager: WatchManager {
        switch self {
        case .TrusangZHJBT:
            return TrusangManager.shared
        case .AppleHK:
            return HealthKitAssistant.shared
        case .YCProduct:
            return YCProductManager.shared
        }
    }
    
    static var basetHeight: CGFloat {
        return UIFont.systemFont(ofSize: 16).lineHeight*2.5
    }
        
    var defaultHeight: CGFloat {
        switch self {
        case .TrusangZHJBT:
            return DeviceType.basetHeight
        default:
            return DeviceType.basetHeight/2
        }
    }
}

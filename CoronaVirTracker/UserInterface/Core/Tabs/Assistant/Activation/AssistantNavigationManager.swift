//
//  AssistantNavigationManager.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 29.06.2022.
//

import UIKit

protocol AssistanceNavigation {
    var navId: String { get set }
}

class AssistantNavigationManager {
    static func popToID(id: String, navController: UINavigationController) {
        let viewControllers = navController.viewControllers
        
        let targetVC = viewControllers.first { controller in
            (controller as? AssistanceNavigation)?.navId == id
        }
        
        guard let targetVC = targetVC else {
            return
        }
        
        navController.popToViewController(targetVC, animated: true)
    }
}

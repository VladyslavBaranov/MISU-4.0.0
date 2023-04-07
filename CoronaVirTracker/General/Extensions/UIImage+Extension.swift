//
//  UIImage+Extension.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 11.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        let aspect = self.size.width / self.size.height
        let rect: CGRect
        if size.width / aspect > size.height {
            let height = size.width / aspect
            rect = CGRect(x: 0, y: (size.height - height) / 2,
                          width: size.width, height: height)
        } else {
            let width = size.height * aspect
            rect = CGRect(x: (size.width - width) / 2, y: 0,
                          width: width, height: size.height)
        }
        draw(in: rect)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
}

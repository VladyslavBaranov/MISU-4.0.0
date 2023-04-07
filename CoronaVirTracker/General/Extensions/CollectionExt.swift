//
//  CollectionExt.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 25.11.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

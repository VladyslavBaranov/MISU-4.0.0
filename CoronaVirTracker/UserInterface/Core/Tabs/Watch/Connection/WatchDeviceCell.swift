//
//  WatchDeviceCell.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 18.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct WatchDeviceCell: View {
    
    let device: AbstractWatch
    
    @State var isConnecting = false
    
    @State var isConnected = false
    
    var didConnect: ((Bool) -> ())?
    
    var body: some View {
        HStack {
            Text(device.getName())
                .font(CustomFonts.createInter(weight: .regular, size: 16))
            Spacer()
            if isConnecting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text(device.isConnected() ? locStr("wm_str_1") : locStr("wc_str_3"))
                    .foregroundColor(.gray)
                    .font(CustomFonts.createInter(weight: .regular, size: 15))
            }
        }
    }
    
    func didConnect(_ completion: @escaping (Bool) -> ()) -> WatchDeviceCell {
        var copy = self
        copy.didConnect = completion
        return copy
    }
}

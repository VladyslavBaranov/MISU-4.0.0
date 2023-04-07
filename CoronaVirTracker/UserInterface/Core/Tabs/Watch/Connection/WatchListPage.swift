//
//  WatchListPage.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 09.07.2022.
//

import SwiftUI
import CoreBluetooth
import WatchConnectivity

class WatchListState: ObservableObject, WatchConnectionManagerDelegate {
    
    var timer: Timer!

    @Published var isSearching = false
    @Published var foundDevices: [AbstractWatch] = []
    
    var manager = WatchConnectionManager.shared
    
    init() {
        manager.delegate = self
        if !foundDevices.contains(where: { $0 is AppleWatch }) {
            foundDevices.append(AppleWatch())
        }
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { [weak self] _ in
            self?.scan()
        })
    }
    
    func didDiscoverDevices(_ devices: [AbstractWatch]) {
        for device in devices {
            if !foundDevices.contains(where: { $0.getName() == device.getName() }) {
                withAnimation {
                    foundDevices.append(device)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            self?.isSearching = false
        }
    }
    
    func scan() {
        isSearching = true
        manager.scan()
    }
    
    deinit {
        timer.invalidate()
    }
    
}

struct WatchListPage: View {
    
    @ObservedObject var state = WatchListState()
    
    var shouldDismiss: (() -> ())?
    var didConnectWatch: ((AbstractWatch?) -> ())?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    ZStack {
                        HStack {
                            Spacer()
                            Button {
                                shouldDismiss?()
                            } label: {
                                Text(locStr("wc_str_4"))
                                    .foregroundColor(Color(Style.TextColors.mainRed))
                                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                            }
                        }
                        Text(locStr("wc_str_1"))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }
                    .padding()
                    
                    HStack(spacing: 10) {
                        Text(locStr("wc_str_2"))
                            .foregroundColor(.gray)
                            .font(CustomFonts.createInter(weight: .regular, size: 15))
                        Spacer()
                        if state.isSearching {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                    .frame(height: 30)
                    .padding(16)
                
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<state.foundDevices.count, id: \.self) { index in
                            WatchDeviceCell(device: state.foundDevices[index])
                                .onTapGesture {
                                    state.foundDevices[index].connect(using: state.manager)
                                }
                            Color(red: 0.89, green: 0.94, blue: 1)
                                .frame(height: 0.6)
                        }
                    
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    
                    
                }
                .navigationBarHidden(true)
                .onAppear {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        state.scan()
                    }
                    
                }
                .onReceive(
                    NotificationCenter.default.publisher(for: NotificationManager.shared.notificationName(for: .didConnectWatch))
                ) { notification in
                    didConnectWatch?(notification.object as? AbstractWatch)
                }
            }
        }
    }
}

protocol WatchListHostingControllerDelegate: AnyObject {
    func shouldPresentWatchDataReading(_ fromWatch: AbstractWatch)
}

class WatchListHostingController: UIHostingController<WatchListPage> {
    
    weak var delegate: WatchListHostingControllerDelegate?
    
    override init(rootView: WatchListPage) {
        super.init(rootView: rootView)
        self.rootView.shouldDismiss = { [weak self] in
            self?.shouldDismiss()
        }
        self.rootView.didConnectWatch = { [weak self] watch in
            self?.dismiss(animated: true) { [weak self] in
                if let watch = watch {
                    self?.delegate?.shouldPresentWatchDataReading(watch)
                }
            }
        }
    }
    
    func shouldDismiss() {
        dismiss(animated: true)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

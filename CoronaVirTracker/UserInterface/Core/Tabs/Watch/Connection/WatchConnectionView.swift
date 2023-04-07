//
//  WatchConnectionView.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 08.07.2022.
//

import SwiftUI

class WatchConnectionState: ObservableObject {
    
    var isAppleWatch = false
    
    @Published var currentWatch = WatchConnectionManager.shared.currentWatch()
    var timer: Timer!
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in
            self?.currentWatch = WatchConnectionManager.shared.currentWatch()
        })
        
        isAppleWatch = currentWatch is AppleWatch
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didConnectWatch),
            name: NotificationManager.shared.notificationName(for: .didConnectWatch),
            object: nil
        )
    }
    
    @objc func didConnectWatch() {
        currentWatch = WatchConnectionManager.shared.currentWatch()
    }
    
}


struct WatchConnectionView: View {
    
    var onTap: (() -> ())
    var shouldPresentMonitoring: () -> ()
    
    @State var didToggle: Bool = WatchFakeVPNManager.shared.isConnected
    
    @ObservedObject var state = WatchConnectionState()
    
    @State var xOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.38, green: 0.65, blue: 1),
                    Color(red: 0.31, green: 0.49, blue: 0.95)
                ],
                startPoint: .init(x: 0.5, y: 0),
                endPoint: .init(x: 0.5, y: 1)
            )
            .cornerRadius(12)
            
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 13) {
                        HStack {
                            Text(getPairedStateString())
                                .font(
                                    CustomFonts.createInter(weight: .semiBold, size: 15)
                                )
                                .foregroundColor(.white)
                            Image("Bluetooth")
                            Spacer()
                            if !state.isAppleWatch {
                                Text("\(getBatteryLevel())%")
                                    .font(
                                        CustomFonts.createInter(weight: .medium, size: 18)
                                    )
                                    .foregroundColor(.white)
                                
                                Image(systemName: getBatteryIconName())
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding([.leading, .top, .trailing], 16)
                        Group {
                            if getWatchName().isEmpty {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                GeometryReader { geometry in
                                    let size = geometry.size.width / 4
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 0) {
                                            
                                            Text(getWatchName())
                                                .frame(width: geometry.size.width)
                                            Text(getWatchName())
                                                .frame(width: geometry.size.width)
                                            
                                        }
                                        .offset(x: xOffset, y: 0)
                                        .foregroundColor(.white)
                                        .font(CustomFonts.createInter(weight: .bold, size: 20))
                                    }
                                    .disabled(true)
                                    .onAppear {
                                        withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                                            xOffset = -size * 4
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 40)
                    }
                    // .padding(16)
                    .onTapGesture {
                        onTap()
                    }
                    
                    if !state.isAppleWatch {
                        Color(red: 0.56, green: 0.72, blue: 1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    
                    if !(state.currentWatch is AppleWatch) {
                        // if !watchName.isEmpty {
                        HStack {
                            Text(locStr("wm_str_2"))
                                .font(
                                    CustomFonts.createInter(weight: .semiBold, size: 15)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            
                            _IntensiveMinitoringToggle(isOn: $didToggle) { isOn in
                                if isOn {
                                    shouldPresentMonitoring()
                                }
                            }
                            .onReceive(
                                NotificationCenter.default.publisher(for: NotificationManager.shared.notificationName(for: .didForceIntensiveMonitoringToStop))
                            ) { _ in
                                didToggle = false
                            }
                        }.padding(16)
                    }
                }
            }
        }
        .padding([.leading, .trailing, .top], 16)
        .onAppear {
            didToggle = WatchFakeVPNManager.shared.isConnected
        }
    }
    
    func getPairedStateString() -> String {
        guard let currentWatch = state.currentWatch else {
            return "Not Paired"
        }
        if !currentWatch.getName().isEmpty {
            return locStr("wm_str_1")
        }
        return "Not Paired"
    }
    
    func getWatchName() -> String {
        guard let currentWatch = state.currentWatch else {
            return ""
        }
        return currentWatch.getName()
    }
    
    func getBatteryLevel() -> Int {
        guard let currentWatch = state.currentWatch else {
            return 0
        }
        return currentWatch.getBatteryLevel()
    }
    
    func getBatteryIconName() -> String {
        let lvl = getBatteryLevel()
        switch lvl {
        case 0..<5:
            return "battery.0"
        case 6..<35:
            return "battery.25"
        case 35..<65:
            return "battery.50"
        case 65..<80:
            return "battery.75"
        default:
            return "battery.100"
        }
    }
}

fileprivate struct _IntensiveMinitoringToggle: UIViewRepresentable {
    
    @Binding var isOn: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    let didChange: (Bool) -> ()
    
    class Coordinator {
        
        var parent: _IntensiveMinitoringToggle
        
        init(parent: _IntensiveMinitoringToggle) {
            self.parent = parent
        }
        
        @objc func didToggle(_ sender: UISwitch) {
            parent.didChange(sender.isOn)
        }
        func setup(_ view: UISwitch) {
            view.addTarget(self, action: #selector(didToggle(_:)), for: .valueChanged)
        }
    }
    
    func makeUIView(context: Context) -> UISwitch {
        let uiSwitch = UISwitch()
        uiSwitch.tintColor = UIColor(white: 1, alpha: 0.32)
        uiSwitch.backgroundColor = UIColor(white: 1, alpha: 0.32)
        uiSwitch.layer.cornerRadius = uiSwitch.bounds.height / 2.0
        uiSwitch.onTintColor = UIColor(red: 0.26, green: 0.89, blue: 0.73, alpha: 1)
        uiSwitch.clipsToBounds = true
        context.coordinator.setup(uiSwitch)
        return uiSwitch
    }
    
    func updateUIView(_ uiView: UISwitch, context: Context) {
        uiView.isOn = isOn
    }
    
    typealias UIViewType = UISwitch
}

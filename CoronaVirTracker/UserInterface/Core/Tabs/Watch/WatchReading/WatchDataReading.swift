//
//  WatchDataReading.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 12.07.2022.
//

import SwiftUI

class WatchDataReadingState: ObservableObject {
    
    fileprivate var didFinishFakePercentUpdating = false
    
    @Published var didLoad = false
    @Published var loadingPercent: Int = 0
    
}

struct WatchDataReading: View {
    
    @ObservedObject var state = WatchDataReadingState()
    
    var didLoadData: (([HealthIndicatorViewModel]) -> ())?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Image("WatchReadingWoman")
                    .padding(30)
                VStack {
                    HStack {
                        Text(locStr("wr_str_1"))
                        Spacer()
                        Text("\(state.loadingPercent)%")
                    }
                    .font(CustomFonts.createInter(weight: .bold, size: 16))
                    .foregroundColor(Color(Style.TextColors.commonText))
                    
                    ProggressView(proggress: $state.loadingPercent)
                        .frame(height: 16)
                    
                    
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 36, trailing: 16))
            }
            .background(Color(red: 0.95, green: 0.97, blue: 1))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .circular)
                    .stroke(Color.blue, lineWidth: 0.6)
            )
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                state.loadingPercent = 33
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                state.loadingPercent = 66
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                state.loadingPercent = 100
                state.didFinishFakePercentUpdating = true
                if state.didFinishFakePercentUpdating {
                    didLoadData?([])
                }
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: NotificationManager.shared.notificationName(for: .didFinishReadingHealthData)), perform: { _ in
                if state.didFinishFakePercentUpdating {
                    didLoadData?([])
                }
        })
        .navigationBarHidden(true)
    }
}

protocol WatchDataReadingHostingControllerDelegate: AnyObject {
    func didLoadDataFromWatch(_ models: [HealthIndicatorViewModel])
}

class WatchDataReadingHostingController: UIHostingController<WatchDataReading> {
    
    weak var delegate: WatchDataReadingHostingControllerDelegate!
    
    override init(rootView: WatchDataReading) {
        super.init(rootView: rootView)
        self.rootView.didLoadData = { [weak self] models in
            self?.didLoadData(models)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didLoadData(_ models: [HealthIndicatorViewModel]) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) { [weak self] in
            self?.dismiss(animated: true)
            self?.delegate?.didLoadDataFromWatch(models)
        }
    }
}

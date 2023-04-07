//
//  SleepIndicatorPage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 26.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

class SleepIndicatorState: ObservableObject {
    
    private var currentIndex = 0
    private var allSleepRecordings = RealmSleepIndicator.getAll()
    
    @Published var dateString: String = ""
    @Published var currentSleepRecording: RealmSleepIndicator!
    
    var sleepPhases: [SleepPhaseItem] = [
        .init(icon: "deep-sleep", durationString: "2h 40 min", title: "Глибокий сон"),
        .init(icon: "light-sleep", durationString: "5h 00 min", title: "Легкий сон"),
        .init(icon: "fast-sleep", durationString: "20 min", title: "Швидкий сон"),
        .init(icon: "awake", durationString: "1 time", title: "Пробудження")
    ]
    
    var sleepInfo: [SleepInfoItem] = [
        .init(icon: "sleep-quality", info: "Якість сну:"),
        .init(icon: "sleep-sleep", info: "Засинання:", normInfo: "Норма: 22:00 - 23:00"),
        .init(icon: "sleep-awakening", info: "Пробудження:", normInfo: "Норма: 1 - 2 рази"),
        .init(icon: "sleep-duration", info: "Тривалість сну:", normInfo: "Норма: 6 - 10 годин")
    ]
    
    init() {
        currentSleepRecording = allSleepRecordings.last
        currentIndex = allSleepRecordings.count - 1
        setIndicator()
    }
    
    func moveBack() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        currentSleepRecording = allSleepRecordings[currentIndex]
        setIndicator()
    }
    
    func moveForward() {
        guard currentIndex < allSleepRecordings.count - 1 else { return }
        currentIndex += 1
        currentSleepRecording = allSleepRecordings[currentIndex]
        setIndicator()
    }
    
    func getCurrentSleepModelDurationString() -> String {
        guard let current = currentSleepRecording else { return "--" }
        return current.getDurationString()
    }
    
    func getCurrentSleepModelTimeString() -> String {
        guard let current = currentSleepRecording else { return "--" }
        let start = current.startDate
        let end = current.endDate
        
        let startHour = start.hour > 9 ? "\(start.hour)" : "0\(start.hour)"
        let startMin = start.minute > 9 ? "\(start.minute)" : "0\(start.minute)"
        
        let endHour = end.hour > 9 ? "\(end.hour)" : "0\(end.hour)"
        let endMin = end.minute > 9 ? "\(end.minute)" : "0\(end.minute)"
        
        return "\(startHour):\(startMin)-\(endHour):\(endMin)"
    }
    
    private func setIndicator() {
        guard let currentSleepRecording = currentSleepRecording else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d LLLL"
        dateString = formatter.string(from: currentSleepRecording.startDate)
        
        let phases = currentSleepRecording.getPhases()
        
        let deepDuration = phases.filter { $0.type == 0 }.map { $0.duration }
        let deepIntDuration = Int(deepDuration.reduce(0, +))
        sleepPhases[0].durationString = deepIntDuration.getDurationString()
        
        let lightDuration = phases.filter { $0.type == 1 }.map { $0.duration }
        let lightIntDuration = Int(lightDuration.reduce(0, +))
        sleepPhases[1].durationString = lightIntDuration.getDurationString()
        
        sleepPhases[2].durationString = currentSleepRecording.getDurationFor(phaseType: .rem).getDurationString()
        sleepPhases[3].durationString = "\(currentSleepRecording.getAwakeCounts()) time"
        
        sleepInfo[0].value = "Задовільна"
        sleepInfo[1].value = currentSleepRecording.startDate.toTime()
        sleepInfo[2].value = currentSleepRecording.endDate.toTime()
        sleepInfo[3].value = currentSleepRecording.getDurationString()
        
        objectWillChange.send()
    }
}

struct SleepIndicatorPage: View {
	
	@Environment(\.presentationMode) var mode
	
	var onRead: ((SleepCardItem) -> ())?
	
	let columns: [GridItem] = [
		.init(.flexible()), .init(.flexible())
	]
	
	let sleepCardItems = SleepCardItem.getItems()
	
	@State var currentPage = 0
    
    @State var graphOpacity: CGFloat = 0.0
	
    @ObservedObject var state = SleepIndicatorState()
    
	var body: some View {
		VStack(spacing: 0) {
			Color.clear
				.frame(height: 30)
			ZStack {
				HStack {
					Button {
						mode.wrappedValue.dismiss()
					} label: {
						Image("orange_back")
							.font(.system(size: 24))
					}
					Spacer()
				}
				Text("Сон")
					.font(CustomFonts.createInter(weight: .semiBold, size: 16))
					.multilineTextAlignment(.center)
					.foregroundColor(Color(Style.TextColors.commonText))
			}
			.padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
			.background(Color.white)
			.foregroundColor(.black)
			
			ScrollView {
				
				ZStack {
					VStack(alignment: .leading, spacing: 40) {
                        
                        VStack(alignment: .center) {
                            SleepTimeLineView(dateString: $state.dateString, onBack: {
                                state.moveBack()
                            }, onForward: {
                                state.moveForward()
                            })
                            .padding([.top, .bottom], 16)
                            HStack {
                                Text(state.getCurrentSleepModelDurationString())
                                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                                Spacer()
                                Text(state.getCurrentSleepModelTimeString())
                                    .font(CustomFonts.createInter(weight: .medium, size: 18))
                                    .foregroundColor(Color(Style.TextColors.gray))
                            }
                            .padding([.leading, .trailing], 16)
                            
                            ZStack {
                                HypnogramChart(phases: $state.currentSleepRecording)
                                // SleepGraphView()
                                    .frame(height: 250)
                                    .padding([.leading, .trailing], 16)
                                    .opacity(graphOpacity)
                                if graphOpacity == 0 {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                            }
                            
                        }
                        
						LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(state.sleepPhases, id: \.icon) { phase in
								SleepPhaseView(phase: phase)
							}
						}
						.padding(16)
						
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(sleepCardItems, id: \.icon) { item in
                                    SleepCardView(item: item) {
                                        onRead?(item)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 130)
                                    .cornerRadius(12)
                                }
                            }
                            .padding([.leading, .trailing], 15)
                        }
                        .frame(height: 130)
						
						ZStack {
							RoundedRectangle(cornerRadius: 12)
								.stroke(Color(red: 0.89, green: 0.94, blue: 1), lineWidth: 1)
							VStack(alignment: .leading, spacing: 10) {
                                ForEach(state.sleepInfo, id: \.icon) { info in
									SleepInfoView(info: info)
									if info.icon != "sleep-duration" {
										Color(red: 0.89, green: 0.94, blue: 1)
											.frame(height: 1)
									}
								}
							}
							.padding(16)
						}
						.padding(16)
					}
				}
				
				VStack(alignment: .leading) {
                    
                }
				.background(Color(red: 0.98, green: 0.99, blue: 1))
				Color.clear
					.frame(height: 110)
			}
			.ignoresSafeArea()
		}
		.navigationBarHidden(true)
		.ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                withAnimation {
                    graphOpacity = 1
                }
            }
        }
	}
}

final class SleepIndicatorHostingController: UIHostingController<SleepIndicatorPage> {
	
	override init(rootView: SleepIndicatorPage) {
		super.init(rootView: rootView)
		self.rootView.onRead = { [weak self] item in
			self?.pushDescriptionPage(for: item)
		}
	}
	
	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func pushDescriptionPage(for item: SleepCardItem) {
		let vc = UIHostingController(rootView: SleepCardDescriptionPage(item: item))
		navigationController?.pushViewController(vc, animated: true)
	}
}

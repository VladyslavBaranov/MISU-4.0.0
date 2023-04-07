//
//  BloodPressureCharacteristicPage.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 12.07.2022.
//

import SwiftUI

private class GenericIndicatorPageState: ObservableObject {
    
    var selectedDate: Date?
    
    @Published var selectedValue1: Double = -1
    
    @Published var indicators: [RealmIndicator] = []
    
    func load(for type: __HealthIndicatorType) {
        indicators = RealmIndicator.getIndicators(for: type)
        // RealmIndicator.log(for: type)
    }
}

struct GenericIndicatorPage: View {
	
	let indicator: __HealthIndicatorType
	
	var onNewIndicatorTapped: ((__HealthIndicatorType) -> ())?
    
    var onCalibration: (() -> ())?
    
    @Environment(\.presentationMode) var mode
    
    var cards: [IllnessData.Card]
	
	@State var index: Int = 0
    
    @ObservedObject private var state = GenericIndicatorPageState()
    
    @State var dateUsesDate = false
    
	init(loaderName: String, indicator: __HealthIndicatorType) {
		self.indicator = indicator
        let loader = HealthStateDescriptionLoader(illness: loaderName)
        if let cards = loader.illnessData?.cards {
            self.cards = cards
        } else {
            self.cards = []
        }
    }
    
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
					Button {
						onNewIndicatorTapped?(indicator)
					} label: {
						Image("add-health-record")
							.resizable()
							.frame(width: 24, height: 24)
					}
                }
				Text(indicator.stringValue())
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(Style.TextColors.commonText))
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            ScrollView {
                
                VStack(alignment: .leading) {
					VStack(alignment: .leading, spacing: 10) {
						
                        IndicatorsTimeLineView(selectedOptionIndex: $index)
							.frame(height: 40)
							.padding([.top, .bottom], 5)
                            .onChange(of: index) { newValue in
                                NotificationManager.shared.post(.didSelectNewPeriodForGraph, object: newValue)
                            }
						
						Text(getTimeString())
							.font(CustomFonts.createInter(weight: .semiBold, size: 15))
							.foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
                        HStack {
                            Text(getValue())
                                .font(CustomFonts.createInter(weight: .bold, size: 22))
                            if state.selectedDate != nil {
                                Spacer()
                                Button {
                                    dateUsesDate.toggle()
                                } label: {
                                    Text(getDateString(state.selectedDate!))
                                        .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                        .foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
                                }
                            }
                        }
		
					}
					.padding([.leading, .trailing, .top], 16)
					
                    
                    IndicatorsLineChart(type: indicator) { entry in
                        state.selectedDate = Date(timeIntervalSinceReferenceDate: entry.x)
                        state.selectedValue1 = entry.y
                    }
                    .frame(height: 250)
                    .padding(4)
                    
                    if indicator == .pressure {
                        Button {
                            onCalibration?()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 27, style: .continuous)
                                    .fill(Color(red: 1, green: 0.37, blue: 0.37))
                                    .frame(height: 54)
                                Text("Калібрувати")
                                    .foregroundColor(.white)
                                    .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                            }
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                        }
                    }
                    // IndicatorGraphView(indicatorType: indicator, mode: $index)
						
                    
                    ForEach(0..<cards.count, id: \.self) { i in
                        VStack(alignment: .leading) {
							
							if cards[i].style != 1 {
								Text(locStr(cards[i].title))
									.font(CustomFonts.createInter(weight: .bold, size: 22))
							}
							HealthStateCardView(card: cards[i])
							
                        }
                        .padding()
                    }
                    
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
            state.load(for: indicator)
        }
    }
	
	private func getTimeString() -> String {
		switch index {
		case 0:
			return locStr("datetime_today")
		case 1:
            guard let week = Date().getStartEndOfWeek() else {
                return locStr("datetime_week")
            }
            let day1 = week.start.day
            let day2 = week.end.day
            let month = week.end.monthString()
            let year = week.end.year
			return "\(day1)-\(day2) \(month) \(year)"
		case 2:
            let date = Date()
            return "\(date.monthString()) \(date.year)"
		default:
            let date = Date()
            return "\(date.year)"
		}
	}
    
    private func getValue() -> String {
        
        if state.selectedValue1 > -1 {
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.decimalSeparator = ","
            
            let num = formatter.string(from: .init(floatLiteral: state.selectedValue1)) ?? "-"
            return "\(num) \(indicator.unitString())"
            
        } else {
            var indicators: [RealmIndicator] = []
            switch index {
            case 0:
                indicators = state.indicators.filtered(with: Date().getDayStartEnd())
            case 1:
                indicators = state.indicators.filtered(with: Date().getStartEndOfWeek()!)
            case 2:
                indicators = state.indicators.filtered(with: Date().getMonthStartEnd())
            default:
                return "No Data"
            }
            guard !indicators.isEmpty else {
                return "No Data"
            }
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.decimalSeparator = ","
            
            let avg = indicators.averageValue()
            
            let num = formatter.string(from: .init(floatLiteral: avg)) ?? "-"
            return "\(num) \(indicator.unitString())"
        }
    }
    
    private func getDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateUsesDate ? "HH:mm:ss dd.MM.yyyy" : "ZZZZ"
        return formatter.string(from: date)
    }
}

final class GenericIndicatorHostingController: UIHostingController<GenericIndicatorPage> {
	
	override init(rootView: GenericIndicatorPage) {
		super.init(rootView: rootView)
		self.rootView.onNewIndicatorTapped = { [weak self] indicator in
			self?.onNewIndicatorTapped(indicator)
		}
        self.rootView.onCalibration = { [weak self] in
            self?.onPressureCalibration()
        }
	}
	
	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static func createInstance(loaderName: String, indicator: __HealthIndicatorType) -> UIViewController {
		let vc = GenericIndicatorHostingController(rootView: .init(loaderName: loaderName, indicator: indicator))
		return vc
	}
	
	func onNewIndicatorTapped(_ indicator: __HealthIndicatorType) {
		let vc = NewIndicatorHostingController.createInstance(indicator)
		present(vc, animated: true)
	}
    
    func onPressureCalibration() {
        let vc = PressureCalibrationStartController(rootView: PressureCalibrationStartPage())
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

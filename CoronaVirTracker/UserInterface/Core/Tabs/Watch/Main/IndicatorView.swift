//
//  IndicatorView.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 29.06.2022.
//

import SwiftUI

struct HealthData {
    var dataEntityName: String
    var value: String
    var unit: String
    
    var colors: [Color]
}

struct AssistanceHealthDataCard: View {
    
    var data: HealthData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: RoundedCornerStyle.continuous)
                .fill(
                    LinearGradient(
                        colors: data.colors,
                        startPoint: .init(x: 0.5, y: 0),
                        endPoint: .init(x: 0.5, y: 1)
                    )
                )
            
            VStack {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 24, style: RoundedCornerStyle.continuous)
                        .rotation(.degrees(45), anchor: .center)
                        .fill(Color(white: 1, opacity: 0.3))
                        .frame(width: 90, height: 90)
                        .offset(x: 30, y: -30)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(data.dataEntityName)
                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    Spacer()
                }
                Spacer()
                Text(data.value)
                    .font(CustomFonts.createInter(weight: .bold, size: 24))
                Text(data.unit)
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct IndicatorView: View {
    
	let indicators: [RealmIndicator]
    let type: __HealthIndicatorType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: RoundedCornerStyle.continuous)
                .fill(
                    LinearGradient(
						colors: getGradientColors(),
                        startPoint: .init(x: 0.5, y: 0),
                        endPoint: .init(x: 0.5, y: 1)
                    )
                )
            
            VStack {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 24, style: RoundedCornerStyle.continuous)
                        .rotation(.degrees(45), anchor: .center)
                        .fill(Color(white: 1, opacity: 0.3))
                        .frame(width: 90, height: 90)
                        .offset(x: 30, y: -30)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading) {
                HStack {
					Text(type.stringValue())
                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    Spacer()
                }
                Spacer()
                Text(getLatestValueString())
                    .font(CustomFonts.createInter(weight: .bold, size: 24))
                Text(getUnitString())
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
            }
            .foregroundColor(.white)
            .padding()
        }
        .frame(width: 150)
    }
	
	private func getLatestValueString() -> String {
        guard let value = indicators.last?.value else {
            return "No data"
        }
		if type == .pressure {
			let additional = indicators.last?.additionalValue ?? 0.0
			return "\(Int(value))/\(Int(additional))"
		}
		let formatter = NumberFormatter()
		formatter.decimalSeparator = ","
		formatter.maximumFractionDigits = 1
		let str = formatter.string(from: .init(floatLiteral: value)) ?? "--"
		if type == .temperature {
			return "\(str) °C"
		}
		return str
	}
	
	private func getUnitString() -> String {
		let value = type.unitString()
		return value
	}
	
	private func getGradientColors() -> [Color] {
		switch type {
		case .sleep:
			return []
		case .activity:
			return []
		case .pressure:
			return [Color(red: 1, green: 0.55, blue: 0.55), Color(red: 1, green: 0.37, blue: 0.37)]
		case .sugar:
			return [Color(red: 0.48, green: 0.71, blue: 1), Color(red: 0.29, green: 0.6, blue: 1)]
		case .heartrate:
			return [Color(red: 1, green: 0.5, blue: 0.53), Color(red: 1, green: 0.41, blue: 0.44)]
		case .oxygen:
			return [Color(red: 0.38, green: 0.65, blue: 1), Color(red: 0.31, green: 0.49, blue: 0.95)]
		case .temperature:
			return [Color(red: 1, green: 0.74, blue: 0.65), Color(red: 1, green: 0.671, blue: 0.56)]
		default:
			fatalError("getGradientColors Does NOT defined for: insuline")
		}
	}
}

//
//  AssistanceHowItWorksPage.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 02.07.2022.
//

import SwiftUI

struct AssistanceHowItWorksPage: View {
    
    @Environment(\.presentationMode) var mode
	
	@State var backButtonOpacity: CGFloat = 0.0
	@State var navigationOpacity: CGFloat = 0.0
    
    var body: some View {
		ZStack {
			
			OffsettableScrollView(showsIndicator: false) { point in
				
				let absY = abs(point.y)
				let threshHold = UIScreen.main.bounds.width * 0.7 + 16
				
				if absY > 0 {
					if backButtonOpacity == 0 && absY < threshHold {
						withAnimation {
							backButtonOpacity = 1
						}
					}
				} else {
					if backButtonOpacity == 1 {
						withAnimation {
							backButtonOpacity = 0
						}
					}
				}
				
				if absY > threshHold {
					if navigationOpacity == 0 {
						withAnimation {
							backButtonOpacity = 0
							navigationOpacity = 1
						}
					}
				} else {
					if navigationOpacity == 1 {
						withAnimation {
							backButtonOpacity = 1
							navigationOpacity = 0
						}
					}
				}
				
				
				
			} content: {
				
				VStack(alignment: .leading) {
					
					Color.clear
						.frame(height: 100)
					
					ZStack {
						Image("HowItWorksHeader")
							.resizable()
							.scaledToFit()
							.padding(.top, 35)
					}
					.frame(maxWidth: .infinity)
					.frame(height: UIScreen.main.bounds.width * 0.7)
					.background(
						RadialGradient(
							gradient: Gradient(colors: [
								Color(red: 0.38, green: 0.65, blue: 1),
								Color(red: 0.31, green: 0.49, blue: 0.95)
							]),
							center: .center,
							startRadius: 0,
							endRadius: 200)
					)
					.cornerRadius(14)
					.padding(16)
					
					VStack(alignment: .leading, spacing: 16) {
						Group {
							Text(locStr("ahw_str_1"))
								.font(CustomFonts.createInter(weight: .bold, size: 22))
							Text(locStr("ahw_str_2"))
								.multilineTextAlignment(.leading)
								.font(CustomFonts.createInter(weight: .regular, size: 16))
                            
                            if _getUserCountry() == "pl" {
                                buildFeature("Підтримка онлайн", bold: true)
                                buildFeature("Запис на консультацію до лікаря", bold: true)
                                buildFeature("Скерування до лікарів — спеціалістів", bold: true)
                                buildFeature("Рецепти", bold: true)
                            } else {
                                buildFeature(locStr("ahw_str_3"))
                                buildFeature(locStr("ahw_str_4"))
                                buildFeature(locStr("ahw_str_5"))
                                buildFeature(locStr("ahw_str_6"))
                            }
                            
							Text(locStr("ahw_str_7"))
								.font(CustomFonts.createInter(weight: .regular, size: 14))
								.foregroundColor(.gray)
						}
						.foregroundColor(Color(Style.TextColors.commonText))
						Color.clear
							.frame(height: 15)
						Group {
							Text(locStr("ahw_str_8"))
								.font(CustomFonts.createInter(weight: .bold, size: 22))
							buildTutorialPoint(index: 1, text: locStr("ahw_str_9"))
							buildTutorialPoint(index: 2, text: locStr("ahw_str_10"))
							buildTutorialPoint(index: 3, text: locStr("ahw_str_11"))
							buildTutorialPoint(index: 4, text: locStr("ahw_str_12"))
						}
						.font(CustomFonts.createInter(weight: .regular, size: 16))
						.foregroundColor(Color(Style.TextColors.commonText))
					}
					.padding()
					Color.clear
						.frame(height: 60)
				}
				
			}
			.ignoresSafeArea()
			.background(Color(red: 0.98, green: 0.98, blue: 1))
			.navigationBarHidden(true)
			
			VStack {
			
				ZStack {
					HStack {
						Button {
							mode.wrappedValue.dismiss()
						} label: {
							ZStack {
								BlurView()
									.opacity(backButtonOpacity)
								Image("orange_back")
									.font(.system(size: 24))
							}
							.frame(width: 40, height: 40)
							.cornerRadius(20)
						}
						Spacer()
					}
				}
				.padding(EdgeInsets(top: 70, leading: 16, bottom: 20, trailing: 16))
				.background(
					ZStack {
						BlurView()
							.opacity(navigationOpacity)
					}
				)
				.foregroundColor(.black)
				
				Spacer()
			}
			.ignoresSafeArea(.all)
		}
		.ignoresSafeArea()
    }
    
    func buildFeature(_ text: String, bold: Bool = false) -> some View {
        ZStack {
            HStack {
                Color.clear
                    .frame(width: 10, height: 7)
                Text(text)
                    .multilineTextAlignment(.leading)
                    .font(CustomFonts.createInter(weight: bold ? .semiBold : .regular, size: 16))
                Spacer()
            }
            VStack {
                Circle()
                    .fill(Color(red: 0.36, green: 0.61, blue: 0.97, opacity: 0.5))
                    .frame(width: 7, height: 7)
                    .offset(x: -UIScreen.main.bounds.midX + 20, y: 6)
                Spacer()
            }
        }
    }
    
    func buildTutorialPoint(index: Int, text: String) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Image("ASTHowPoint")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text("\(index)")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
            }
            Text(text)
                .font(.system(size: 16))
        }
    }
    
    private func _getUserCountry() -> String {
        guard let country = KeyStore.getStringValue(for: .userCountry) else {
            return "other"
        }
        return country
    }
}



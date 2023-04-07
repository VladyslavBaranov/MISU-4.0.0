//
//  IllnessDescriptionPage.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 02.07.2022.
//

import SwiftUI

enum HealthState {
	case covid, heart
}

struct HealthStateCardView: View {
    
    let lineHeight = UIFont.systemFont(ofSize: 16).lineHeight
    
    var card: IllnessData.Card
    
    var body: some View {
        ZStack {
			if card.style == 1 {
				VStack {
					HStack {
						Spacer()
						Image("reminder-hand")
					}
					.offset(x: 0, y: 16)
					Spacer()
				}
			}
            HStack {
                VStack(alignment: .leading, spacing: 12) {
					if card.style == 1 {
						Color.clear
							.frame(height: 8)
						Text(card.title)
							.font(CustomFonts.createInter(weight: .medium, size: 18))
					}
                    ForEach(0..<card.content.count, id: \.self) { i in
                        let paragraph = card.content[i]
                        if paragraph.paragraphType == 0 {
							HStack {
								Text(locStr(paragraph.text))
									.multilineTextAlignment(.leading)
									.font(.system(size: 16))
								Spacer()
							}
                            
						} else if paragraph.paragraphType == 2 {
							Text(locStr(paragraph.text))
								.font(CustomFonts.createInter(weight: .medium, size: 18))
								.padding(.top, i == 0 ? 0 : 10)
						} else {
                            HStack {
                                VStack {
                                    Circle()
                                        .fill(Color(red: 0.36, green: 0.61, blue: 0.97, opacity: 0.5))
                                        .frame(width: 7, height: 7, alignment: .top)
                                        .offset(x: 0, y: 6)
                                    Spacer()
                                }
                                
                                Text(locStr(paragraph.text))
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 16))
                                Spacer()
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            
                        }
                    }
                    if let footer = card.footer {
                        Text(locStr(footer.title))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                        Text(locStr(footer.text))
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
            }.padding(15)
            
        }
        .frame(maxWidth: .infinity)
		.background(card.style == 1 ? Color(red: 0.95, green: 0.97, blue: 1) : Color(red: 0.98, green: 0.98, blue: 1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .circular)
				.stroke(card.style == 1 ? Color(Style.Stroke.blue) : Color(.systemGray4), lineWidth: 0.5)
        )
    }
}

struct HealthStateDescriptionPage: View {
    
    var illness: String = ""
    
    var backButtonTapped: (() -> ())?
	
	var onStartTapped: (() -> ())?
    
    var cards: [IllnessData.Card]
	
	var state: HealthState = .covid
    
	init(state: HealthState) {
		self.state = state
		let loaderName: String
		switch state {
		case .covid:
			loaderName = "Covid19"
		case .heart:
			loaderName = "Heart"
		}
		
        let loader = HealthStateDescriptionLoader(illness: loaderName)
		
        if let cards = loader.illnessData?.cards {
            self.cards = cards
        } else {
            self.cards = []
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.white
                    .frame(height: 30)
                ZStack {
                    HStack {
                        Button {
                            backButtonTapped?()
                        } label: {
                            Image("orange_back")
                                .font(.system(size: 24))
                        }
                        Spacer()
                    }
                    Text(getTitle())
                        .bold()
                }
                .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
                .background(Color.white)
                .foregroundColor(.black)
                
                ScrollView {
                    ForEach(0..<cards.count, id: \.self) { i in
                        VStack(alignment: .leading) {
                            Text(locStr(cards[i].title))
                                .font(.system(size: 22, weight: .bold))
                            HealthStateCardView(card: cards[i])
                            
                        }
                        .padding()
                    }
                    Color.clear
                        .frame(height: 120)
                }.frame(maxWidth: .infinity)
            }
            .ignoresSafeArea()
            .background(Color(red: 0.98, green: 0.98, blue: 1))
            .navigationBarHidden(true)
            VStack {
                Spacer()
                VStack {
                    Button {
						onStartTapped?()
                    } label: {
                        Text("Визначити рівень ризику")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                            .background(
                                Capsule(style: .circular)
                                    .fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
                            )
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                    
                    Color.white
                        .frame(height: 20)
                }.background(Color.white)
            }.ignoresSafeArea()
        }
    }
	
	func getTitle() -> String {
		switch state {
		case .covid:
			return "Covid-19"
		case .heart:
			return "Хвороби серця"
		}
	}
}

class HealthStateDescriptionHostingController: UIHostingController<HealthStateDescriptionPage> {
    
	var healthState: HealthState = .covid
	
	private var test: Test!
    
    override init(rootView: HealthStateDescriptionPage) {
        super.init(rootView: rootView)
		self.rootView.backButtonTapped = { [weak self] in
			self?.backButtonTapped()
		}
		self.rootView.onStartTapped = { [weak self] in
			self?.startTest()
		}
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
	
	static func createInstance(_ healthState: HealthState) -> UIViewController {
		let vc = HealthStateDescriptionHostingController(rootView: .init(state: healthState))
		vc.healthState = healthState
		return vc
	}
	
	func startTest() {
		switch healthState {
		case .covid:
			test = CovidTest()
		case .heart:
			test = HeartTest()
		}
		test.sourceViewController = self
		test.start()
	}
}

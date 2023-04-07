//
//  WelcomePage.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 12.06.2022.
//

import SwiftUI

struct AssistanceWelcomeCard: View {
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Image("Logo")
                    .frame(width: 70, height: 70, alignment: .center)
                    .padding()
                Text(locStr("was_str_1"))
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                Text(locStr("was_str_2"))
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                Color.clear
                    .frame(height: 10)
                VStack(alignment: .leading, spacing: 25) {
                    HStack {
                        Image("Icon247")
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(25)
                        Text(locStr("was_str_3"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                    }
                    HStack {
                        Image("IconPhone")
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(25)
                        Text(locStr("was_str_4"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                    }
                    HStack {
                        Image("IconRisk")
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(25)
                        Text(locStr("was_str_5"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                    }
                    HStack {
                        Image("IconStat")
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(25)
                        Text(locStr("was_str_6"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                    }
                }
                .padding(.bottom, 20)
            }
            .foregroundColor(Color(Style.TextColors.commonText))
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(red: 0.95, green: 0.97, blue: 1, alpha: 1)))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(Style.Stroke.lightGray), lineWidth: 1)
        )
        .cornerRadius(16)
        .padding([.trailing, .leading], 16)
    }
}

struct AssistanceSavedLifeCard: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                Text(locStr("was_str_10"))
                    .multilineTextAlignment(.center)
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .padding([.top, .bottom], 15)
                VStack(alignment: .leading, spacing: 25) {
                    HStack(spacing: 16) {
                        Image("checkCircle")
                            .frame(width: 26, height: 26, alignment: .center)
                            .cornerRadius(13)
                        Text(locStr("was_str_11"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack(spacing: 16) {
                        Image("checkCircle")
                            .frame(width: 26, height: 26, alignment: .center)
                            .cornerRadius(13)
                        Text(locStr("was_str_12"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack(spacing: 16) {
                        Image("checkCircle")
                            .frame(width: 26, height: 26, alignment: .center)
                            .cornerRadius(13)
                        Text(locStr("was_str_13"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack(spacing: 16) {
                        Image("checkCircle")
                            .frame(width: 26, height: 26, alignment: .center)
                            .cornerRadius(13)
                        Text(locStr("was_str_14"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.bottom, 20)
            }
            .foregroundColor(Color(Style.TextColors.commonText))
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(red: 0.95, green: 0.95, blue: 1, alpha: 1)))
        .cornerRadius(16)
        .padding(16)
    }
}

struct AssistanceEuropeCard: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    HStack {
                        Image(systemName: "globe")
                        Text(locStr("gen_world"))
                            .font(CustomFonts.createInter(weight: .regular, size: 14))
                        Text("53 \(locStr("unit_thousand"))")
                            .font(.system(size: 15, weight: .semibold))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 14))
                    }
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15))
                    .background(
                        Capsule(style: .circular).fill(Color(red: 0.36, green: 0.61, blue: 0.97))
                    )
                    
                    Spacer()
                }
                
                Image("planet&MISU")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: UIScreen.main.bounds.width - 70
                    )
                    .frame(maxHeight: 300)
                    .padding(.bottom, 20)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.width)
        .background(Color(UIColor(red: 0.95, green: 0.95, blue: 1, alpha: 1)))
        .cornerRadius(16)
        .padding()
    }
}

struct HealingCard: View {
    var body: some View {
        VStack(spacing: 15) {
            Text(locStr("was_str_18"))
                .multilineTextAlignment(.center)
                .font(CustomFonts.createInter(weight: .bold, size: 22))
                .foregroundColor(Color(Style.TextColors.commonText))
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("43054")
                        .font(CustomFonts.createInter(weight: .bold, size: 20))
                    Text(locStr("was_str_19"))
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                }
                .foregroundColor(.white)
                .padding()
                Spacer()
                Image("LogoLight")
                    .frame(width: 50, height: 50)
                    .padding()
            }
            .frame(height: 80)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.38, green: 0.65, blue: 1),
                        Color(red: 0.31, green: 0.49, blue: 0.95)
                    ],
                    startPoint: UnitPoint(x: 0, y: 0),
                    endPoint: UnitPoint(x: 1, y: 1)
                )
                .cornerRadius(12)
            )
            HStack {
                VStack(alignment: .leading) {
                    Text("12033")
                        .font(CustomFonts.createInter(weight: .bold, size: 20))
                    Text(locStr("was_str_20"))
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                }
                .foregroundColor(.white)
                .padding()
                .frame(height: 80)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 1, green: 0.55, blue: 0.55),
                            Color(red: 1, green: 0.37, blue: 0.37)
                        ],
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1, y: 1)
                    )
                    .cornerRadius(12)
                )
                Spacer()
            }
            
        }
        .padding(16)
    }
}

struct BraceletActivationCardItem: View {
    
    var item: BraceletActivationCard.Item
    
    var body: some View {
        
        ZStack {
            HStack(spacing: 0) {
                ZStack {
                    LinearGradient(
                        colors: item.gradient,
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1, y: 1)
                    )
                    .cornerRadius(12)
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(item.title)
                                .multilineTextAlignment(.leading)
                                .font(CustomFonts.createInter(weight: .bold, size: 22))
                            Text(item.description)
                                .multilineTextAlignment(.leading)
                                .font(CustomFonts.createInter(weight: .regular, size: 14))
                            Button {
                                guard let url = URL(string: "https://misu.in.ua/watches/air") else { return }
                                guard UIApplication.shared.canOpenURL(url) else { return }
                                UIApplication.shared.open(url)
                            } label: {
                                Text(locStr("was_str_24"))
                                    .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                    .foregroundColor(item.gradient.first ?? .blue)
                                    .frame(width: 100, height: 40)
                                    .background(
                                        Capsule(style: .circular).fill(Color.white)
                                    )
                            }
                        
                        }
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 50))
                        Spacer()
                    }
                }
                Color.white
                    .frame(width: 70)
            }
            
            HStack {
                Spacer()
                if item.imagePlacement == .topRight {
                    VStack {
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .offset(x: -15, y: 18)
                        Spacer()
                    }
                } else {
                    Image(item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .offset(x: -18, y: 0)
                }
            }
                
        }
        //.frame(height: 250)
        .foregroundColor(.white)
        
    }
}

struct BraceletActivationCard: View {
    
    struct Item {
        
        enum ImagePlacement {
            case side, topRight
        }
        
        var title: String
        var description: String
        var image: String
        var gradient: [Color]
        var imagePlacement: ImagePlacement
    }
    
    let items: [Item] = [
        .init(
            title: locStr("was_str_8"),
            description: locStr("was_str_9"),
            image: "misu-watch",
            gradient: [
                Color(red: 0.38, green: 0.65, blue: 1),
                Color(red: 0.31, green: 0.49, blue: 0.95)
            ], imagePlacement: .side
        )
    ]
    
    @State var currentPage = 0
    
    var body: some View {
        VStack {
            Text(locStr("was_str_7"))
                .multilineTextAlignment(.center)
                .font(CustomFonts.createInter(weight: .bold, size: 22))
                .foregroundColor(Color(Style.TextColors.commonText))
                .padding()
            // ConfigurableTabView(config: .init(margin: 0, spacing: 0), page: $currentPage) {
            BraceletActivationCardItem(item: items[0])
                .frame(height: UIScreen.main.bounds.width * 0.5)
                .padding(.leading, 22)
        }
        .padding([.top, .bottom], 16)
    }
}

struct GraphsCard: View {
    
    @State var currentPage = 0
    
    var body: some View {
        VStack {
            Text(locStr("was_str_21"))
                .foregroundColor(Color(Style.TextColors.commonText))
                .multilineTextAlignment(.center)
                .font(.system(size: 25, weight: .semibold))
                .padding()
            ConfigurableTabView(config: .init(margin: 20, spacing: 10), page: $currentPage) {
                Image("Graph1")
                    .resizable()
                Image("Graph2")
                    .resizable()
                Image("Graph3")
                    .resizable()
                Image("Graph4")
                    .resizable()
                Image("Graph5")
                    .resizable()
            }
            .frame(height: UIScreen.main.bounds.width * 0.56)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            HStack {
                Text(locStr("was_str_22"))
                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.leading, 16)
            PageControl(pageCount: 5, page: $currentPage)
        }
        .padding([.top, .bottom], 16)
    }
}

struct WelcomingAssistancePage: View {
	
    var crossTapped: (() -> ())?
    var onActivate: (() -> ())?
    
    var body: some View {
        ZStack {
            ScrollView {
                
                ZStack {
                    HStack {
                        Spacer()
                        Button {
                            crossTapped?()
                        } label: {
                            Image(systemName: "multiply")
                                .font(.system(size: 27, weight: .light))
                                .foregroundColor(.black)
                        }
                    }
                    Text("Активація\nАсистента")
                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                        .foregroundColor(Color(Style.TextColors.commonText))
                        .multilineTextAlignment(.center)
                }
                .frame(height: 50)
                .padding(16)
                
                AssistanceWelcomeCard()
                BraceletActivationCard()
                AssistanceSavedLifeCard()
                AlphaInsuranceView()
                Text(locStr("was_str_15"))
                    .multilineTextAlignment(.center)
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .foregroundColor(Color(Style.TextColors.commonText))
                
                AssistanceEuropeCard()
                HealingCard()
                GraphsCard()
                Color.clear
                    .frame(height: 110)
            }
            
            AppRedButtonTabView(title: locStr("was_str_23")) {
                onActivate?()
            }
        }
        .background(
            Color.white
        )
        .navigationBarHidden(true)
    }
}

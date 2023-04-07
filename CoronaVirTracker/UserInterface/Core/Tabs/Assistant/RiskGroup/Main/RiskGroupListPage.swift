//
//  RiskGroupPage.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 02.07.2022.
//

import SwiftUI

struct RiskGroupItem {
	let state: HealthState
    let title: String
    let imageName: String
}

struct RiskGroupCard: View {
    
    var item: RiskGroupItem
    
    var body: some View {
        VStack(spacing: 12) {
            Image(item.imageName)
                .resizable()
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 2, trailing: 8))
                .scaledToFit()
            Text(item.title)
                .font(.system(size: 15, weight: .bold))
                .padding(.bottom, 12)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 220)
        .background(Color(UIColor(red: 0.96, green: 0.97, blue: 1, alpha: 1)))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .stroke(Color(.systemGray4), lineWidth: 0.5)
        )
    }
}

struct RiskGroupListPage: View {
    
    var backButtonTapped: (() -> ())?
    
    var healthStateTapped: ((HealthState) -> ())?
    
    let items: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    let riskItems: [RiskGroupItem] = [
		.init(state: .covid, title: "Covid-19", imageName: "RiskCovid19"),
		// .init(state: .heart, title: "Хвороби серця", imageName: "HeartDiseases")
    ]
    
    var body: some View {
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
                Text("Група ризику")
                    .bold()
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            ScrollView {
                Color.clear
                    .frame(height: 20)
                LazyVGrid(columns: items, spacing: 10) {
                    ForEach(0..<riskItems.count, id: \.self) { index in
                        RiskGroupCard(item: riskItems[index])
                            .onTapGesture {
								healthStateTapped?(riskItems[index].state)
                            }
                    }
                    
                }.padding([.leading, .trailing], 16)
            }.ignoresSafeArea()
        }
        .ignoresSafeArea()
        .background(Color(red: 0.98, green: 0.98, blue: 1))
        .navigationBarHidden(true)
        
    }
}

class RiskGroupHostingController: UIHostingController<RiskGroupListPage> {
    
    override init(rootView: RiskGroupListPage) {
        super.init(rootView: rootView)
		self.rootView.backButtonTapped = { [weak self] in
			self?.backButtonTapped()
		}
		self.rootView.healthStateTapped = { [weak self] state in
			self?.healthStateTapped(state)
		}
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
	func healthStateTapped(_ state: HealthState) {
		let vc = HealthStateDescriptionHostingController.createInstance(state)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

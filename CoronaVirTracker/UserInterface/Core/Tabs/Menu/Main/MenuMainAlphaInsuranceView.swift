//
//  MenuAlphaInsuranceView.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 11.07.2022.
//

import SwiftUI

private struct MenuPartnerView: View {
    
    let partner: MISUPartner
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                Image(getImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
                
                Text(partner.text)
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                Button {
                    if let url = URL(string: partner.link) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                } label: {
                    Text(locStr("Read more"))
                        .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                        .foregroundColor(Color(Style.TextColors.mainRed))
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                        .overlay(
                            Capsule()
                                .stroke(Color(Style.TextColors.mainRed), lineWidth: 1)
                                
                        )
                    
                }

            }
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.89, green: 0.94, blue: 1), lineWidth: 1)
                .background(Color(red: 0.97, green: 0.98, blue: 1))
        )
        .padding(16)
        
    }
    
    func getImage() -> String {
        if partner.link.contains("oranta") {
            return "opanta"
        } else if partner.link.contains("vuso") {
            return "vuso"
        }
        return ""
    }
}

struct MenuAlphaInsurancePage: View {
    
    @Environment(\.presentationMode) var mode
    
    @State var partners: [MISUPartner] = []
    
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 0) {
            Color.white
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
                HStack(spacing: 10) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    Text(locStr("Partners"))
                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                }
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            ForEach(partners, id: \.id) { partner in
                MenuPartnerView(partner: partner)
            }
            
            Spacer()
            
        }
        .navigationBarHidden(true)
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .ignoresSafeArea()
        .onAppear {
            fetchPartners()
        }
    }
    
    private func fetchPartners() {
        if let data = RealmJSON.retreive(for: .partners) {
            if let partners = try? JSONDecoder().decode([MISUPartner].self, from: data) {
                self.partners = partners
            }
        }
        VariousEndpointManager.shared.fetchMembers { partners in
            guard let partners = partners else { return }
            DispatchQueue.main.async {
                isLoading = false
                self.partners = partners
                if let data = try? JSONEncoder().encode(partners) {
                    RealmJSON.write(data, for: .partners)
                }
            }
        }
    }
}

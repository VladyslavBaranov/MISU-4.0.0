//
//  ViewController.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 08.06.2022.
//

import SwiftUI

struct OnlineDoctorPage: View {
    
    struct DoctorSpeciality {
        var name: String
        var isSelected = false
    }
    
    let rows = [GridItem(.flexible(minimum: 100, maximum: 200))]
    
    @State var doctorCategories: [DoctorSpeciality] = [
        .init(name: locStr("dl_str_1"), isSelected: false),
        .init(name: locStr("dl_str_2"), isSelected: false),
        .init(name: locStr("dl_str_3"), isSelected: false)
    ]
    
    @ObservedObject
    var loader = DoctorsLoader()
    
    var backButtonTapped: (() -> ())?
    var didTapDoctor: ((Doctor) -> ())?
    
    @State var isPresented = false
    
    @State var topScrollViewOpacity: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            /*
            OffsettableScrollView(axes: .vertical, showsIndicator: true) { p in
                
                if p.y < 0 {
                    let opacity = 1 - abs(p.y) / 35
                    topScrollViewOpacity = opacity < 0 ? 0 : opacity
                } else {
                    topScrollViewOpacity = 1.0
                }
                
            } content: {
                
                Color.clear.frame(height: 152)
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                    if !loader.filteredDoctors.isEmpty {
                        ForEach(loader.filteredDoctors) { doctor in
                            DoctorPage(doctor: doctor)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                .onTapGesture {
                                    didTapDoctor?(doctor)
                                }
                                .foregroundColor(.black)
                        }
                    }
                }
                Color.clear
                    .frame(height: 100)
                 
            }
            .background(
                Color(UIColor(red: 0.985, green: 0.985, blue: 1, alpha: 1))
                    .cornerRadius(14)
            )
            */
            VStack(spacing: 0) {
                Color.white
                    .frame(height: 40)
                ZStack {
                    HStack {
                        Button {
                            backButtonTapped?()
                        } label: {
                            Image("orange_back")
                        }
                        Spacer()
                    }.padding(20)
                    Text(locStr("mah_str_14"))
                        .font(CustomFonts.createInter(weight: .semiBold, size: 17))
                        .foregroundColor(Color(Style.TextColors.commonText))
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows) {
                        Color.clear
                            .frame(width: 15)
                        ForEach(0..<doctorCategories.count, id: \.self) { index in
                            SelectableCapsuleButton(
                                isSelected: $doctorCategories[index].isSelected,
                                text: doctorCategories[index].name
                            ) { isSelected, key in
                                if isSelected {
                                    loader.add(key: key)
                                } else {
                                    loader.remove(key: key)
                                }
                            }
                            .disabled(true)
                            .opacity(0.8)
                        }
                    }
                }
                
                // .opacity(topScrollViewOpacity)
                .frame(height: 70)
                .background(Color(white: 1, opacity: 1 - topScrollViewOpacity))
                
                
                Spacer()
            }
            .onAppear {
            }
            
            VStack(spacing: 20) {
                Color.clear
                    .frame(height: 40)
                Image("onlineDoc")
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .trailing], 80)
                Text("Лікар Онлайн буде доступний незабаром!")
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 16)
                Text("Вже зовсім скоро наші лікарі зможуть надавати консультації онлайн")
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 16)
            }
            
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    backButtonTapped?()
                } label: {
                    Image("orange_back")
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .listStyle(PlainListStyle())
        .navigationBarHidden(true)
        
    }
}

class OnlineDoctorHostingController: UIHostingController<OnlineDoctorPage> {
    override init(rootView: OnlineDoctorPage) {
        super.init(rootView: rootView)
        self.rootView.backButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.rootView.didTapDoctor = didTapDoctor
        view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
    }
    
    func didTapDoctor(_ doctor: Doctor) {
        let hostingVC = UIHostingController(rootView: DoctorDetailsPage(doctor: doctor))
        hostingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hostingVC, animated: true)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

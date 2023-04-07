//
//  ReportGraphView.swift
//  ProjectForTesting
//
//  Created by Vladyslav Baranov on 11.02.2023.
//

import SwiftUI

struct ReportGraphView: View {
    
    let values: [Int]
    
    var body: some View {
        VStack (spacing: 0){
            HStack(spacing: 10) {
                ForEach(0..<values.count, id: \.self) { index in
                    VStack {
                        Spacer()
                        ZStack {
                            if index == 0 || index == 6 {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white)
                                    .frame(height: 28)
                            } else {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.5))
                                    .frame(height: 28)
                            }
                            Text("\(values[index])")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.blue)
                        }
                        if index == 0 || index == 6 {
                            Color.white
                                .clipShape(TopRoundRect())
                                .frame(height: getHeightForSegment(values[index]))
                        } else {
                            Color.white.opacity(0.5)
                                .clipShape(TopRoundRect())
                                .frame(height: getHeightForSegment(values[index]))
                        }
                    }
                }
            }
            Color.white.opacity(0.5)
                .frame(height: 1.5)
            
            HStack(spacing: 10) {
                Text("20.01")
                    .frame(maxWidth: .infinity)
                Text("21.01")
                    .frame(maxWidth: .infinity)
                Text("22.01")
                    .frame(maxWidth: .infinity)
                Text("23.01")
                    .frame(maxWidth: .infinity)
                Text("24.01")
                    .frame(maxWidth: .infinity)
                Text("25.01")
                    .frame(maxWidth: .infinity)
                Text("26.01")
                    .frame(maxWidth: .infinity)
            }
            .font(.system(size: 14))
            .padding(.top, 4)
        }
    }
    
    func getHeightForSegment(_ int: Int) -> CGFloat {
        let min = values.min()!
        let max = values.max()!
        let diff = max - min
        
        let minHeight: CGFloat = 50.0
        
        return minHeight + CGFloat(int - min) * 60.0 / CGFloat(diff)
    }
}

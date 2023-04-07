//
//  IllnessLoader.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 02.07.2022.
//

import Foundation

struct IllnessData: Codable {
    
    struct Card: Codable {
        
        struct Footer: Codable {
            var title: String
            var text: String
        }
        
        struct Paragraph: Codable {
            var paragraphType: Int
            var text: String
        }
        
        var title: String
		var style: Int?
        var content: [Paragraph]
        var footer: Footer?
    }
    var cards: [Card]
}

final class HealthStateDescriptionLoader {
    
    let illness: String
    
    var illnessData: IllnessData!
    
    init(illness: String) {
        self.illness = illness
        guard let path = Bundle.main.url(forResource: illness, withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: path) else { return }
        guard let illnessData = try? JSONDecoder().decode(IllnessData.self, from: data) else { return }
        self.illnessData = illnessData
    }
}

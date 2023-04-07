//
//  DoctorsLoader.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 08.06.2022.
//

import Foundation

struct Doctor: Codable, Identifiable {
    
    var id: Int
    
    var firstName: String
    var lastName: String
    var avatarName: String
    var doctor_category: String
    var location: String
    var tags: [String]
    var description: String
    
    func initials() -> String {
        let firstFromFirstName = firstName.first ?? "-"
        let firstFromLastName = lastName.first ?? "-"
        return "\(firstFromFirstName)\(firstFromLastName)"
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

class DoctorsLoader: ObservableObject {
    
    var doctors: [Doctor] = []
    
    var filterKeys: Set<String> = [] {
        didSet {
            print(filterKeys)
        }
    }
    
    @Published
    var filteredDoctors: [Doctor] = []
    
    init() {
        guard let url = Bundle.main.url(forResource: "Doctors", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let doctors = try? JSONDecoder().decode([Doctor].self, from: data) else { return }
        self.doctors = doctors
        self.filteredDoctors = doctors
    }
    
    func add(key: String) {
        filterKeys.insert(key)
        filteredDoctors = doctors.filter { filterKeys.contains($0.doctor_category) }
        dump(filteredDoctors)
        
    }
    
    func remove(key: String) {
        filterKeys.remove(key)
        if filterKeys.isEmpty {
            filteredDoctors = doctors
        } else {
            filteredDoctors = doctors.filter { filterKeys.contains($0.doctor_category) }
        }
    }
}

//
//  DataParser.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 31.03.2024.
//

import Foundation

class DataParser {
    
    static let shared = DataParser()
    
    private let jsonFilePath = Bundle.main.path(forResource: "data", ofType: "json")

    func getRecommendData(completion: @escaping (Offers?, Error?) -> Void) {
        if let path = jsonFilePath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let offersResponse = try JSONDecoder().decode(Offers.self, from: data)
                completion(offersResponse, nil)
            } catch {
                completion(nil, error)
            }
        } else {
            print("Invalid file path")
        }
    }
    
    func getVacancies(completion: @escaping (Vacancies?, Error?) -> Void) {
        if let path = jsonFilePath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let vacanciesResponse = try JSONDecoder().decode(Vacancies.self, from: data)
                completion(vacanciesResponse, nil)
            } catch {
                completion(nil, error)
            }
        } else {
            print("Invalid file path")
        }
    }

}

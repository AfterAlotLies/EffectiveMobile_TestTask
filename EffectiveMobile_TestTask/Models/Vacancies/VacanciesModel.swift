//
//  VacanciesModel.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 31.03.2024.
//

import Foundation

struct Vacancies: Codable {
    let vacancies: [VacanciesModel]
}

struct VacanciesModel: Codable {
    let lookingNumber: Int?
    let title: String
    let address: VacanciesAddress
    let company: String
    let experience: VacanciesExperience
    let publishedDate: String
}

struct VacanciesAddress: Codable {
    let town: String
}

struct VacanciesExperience: Codable {
    let previewText: String
}


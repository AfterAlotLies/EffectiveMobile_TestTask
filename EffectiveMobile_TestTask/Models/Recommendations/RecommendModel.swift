//
//  RecommendModel.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 31.03.2024.
//

import Foundation

struct Offers: Codable {
    let offers: [RecommendModel]
}

struct RecommendModel: Codable {
    let title: String
}

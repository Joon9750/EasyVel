//
//  PopularTagsDTO.swift
//  VelogOnMobile
//
//  Created by JuHyeonAh on 2023/06/29.
//

import Foundation

struct PopularTagsDTO: Codable{
    let popularTagDtoList: [PopularTagDtoList]?
}

struct PopularTagDtoList: Codable{
    let keyword: String?
}

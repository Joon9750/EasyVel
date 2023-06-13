//
//  PopularPostsDTO.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/31.
//

import Foundation

struct PopularPostsDTO: Codable {
    let popularPostDtoList: [PopularPostDtoList]?
}

struct PopularPostDtoList: Codable {
    let comment: Int?
    let date: String?
    let img: String?
    let like: Int?
    let name: String?
    let summary: String?
    let tag: [String]?
    let title: String?
    let url: String?
    let num: String?
}
//
//struct Trend {
//    let keyword: String
//    let num: String
//}
//
//extension Trend{
//    static func dummy() -> [Trend]{
//        return [Trend(keyword: "iOS",
//                      num: "1"),
//                Trend(keyword: "Android",
//                      num: "2"),
//                Trend(keyword: "Sever",
//                      num: "3"),
//                Trend(keyword: "Design",
//                      num: "4"),
//                Trend(keyword: "알고리즘",
//                      num: "5"),
//                Trend(keyword: "TIL",
//                      num: "6"),
//                Trend(keyword: "프로그래머스",
//                      num: "7"),
//                Trend(keyword: "코딩테스트",
//                      num: "8"),
//                Trend(keyword: "Spring",
//                      num: "9"),
//                Trend(keyword: "CSS",
//                      num: "10"),
//        ]
//    }
//}

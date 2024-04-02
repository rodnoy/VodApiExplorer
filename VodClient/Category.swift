//
//  Category.swift
//  VodClient
//
//  Created by KIRILL SIMAGIN on 04/04/2024.
//

import Foundation

// Enum для advisory
//enum VodAdvisory: String, Codable {
//    case pg
//    case pg13
//    case r
//    case nc17
//}

// Enum для жанров
//enum Genre: String, Codable {
//    case action
//    case drama
//    case comedy
//    case horror
//}

// Enum для статуса
enum VodStatus: String, Codable {
    case prospected
    case programmed
    case published
    case removed
}

// Enum для типа видео
//enum VideoType: String, Codable {
//    case feature
//    case short
//    case series
//}

// Enum для CSA (рейтинг)
enum CSA: String, Codable {
    case csa1
    case csa2
    case csa3
    case csa4
    case csa5
}



// Структура для статьи
struct VodArticle: Identifiable, Codable {
    var id: String
    var title: String
    var csa: CSA
    var advisory: VodAdvisory
    var productionYear: Int
    var images: [VodImage]
    var superGenres: [String]
//    var links: [VodLink]
    var price: Double
    var status: VodStatus
    var trailers: [URL]
    var duration: Int // Длительность в минутах
    var type: VodContentType
    var covers: [VodImage]
    var videoType: VodVideoType
}

// Структура для категории
struct VodCategory: Identifiable, Codable {
    var id: String
    var title: String
    var name: String
    var advisory: VodAdvisory
    var images: [VodImage]
    var catalogID: String
    var articles: [VodArticle]
    var covers: [VodImage]
    var superGenres: [String]
    var highlights: [VodArticle]
}



struct VodImage: Codable {
    var format: ImageFormat
    var url: URL
}

struct VodLink: Codable {
    var link: URL?
    var catalogId: String?
}

enum VodContentType: String, Codable {
    case video
    case series
    case season
    case category
    case discountCategory
    case package
    case link
    case corner
    case catalog
    case menu
    case application
}
enum VodVideoType: String, Codable {
    case movie
    case episod
}
enum VodAdvisory: String, Codable {
    case allPublic
    case charm
    case adult
}

enum ImageFormat: String, Codable {
    case background
    case cover
    case banner_1
    case banner_2
    case banner_3
}

//enum ContentNature: String {
//    case composite = "COMPOSITE"
//}

//struct Category {
//    var id: String
//    var title: String
//    var type: ContentType
//    var advisory: Advisory
//    var images: [VodImage]
//    var name: String
//    var discountPitch: String
//    var nature: ContentNature
//    var catalogId: String
//    var links: [VodLink]
//    var covers: [VodImage]
//    // Дополнительные поля...
//}
// Структура для изображений
//struct VodImage: Identifiable, Codable {
//    var id: String
//    var url: URL
//}
//func mapCategoryDTOToCategory(dto: CategoryDTO) -> Category {
//    let articles = dto.articles.map { articleDTO in
//        Article(
//            id: articleDTO.id,
//            title: articleDTO.title,
//            csa: CSA(rawValue: articleDTO.csa.rawValue) ?? .csa1,
//            advisory: VodAdvisory(rawValue: articleDTO.advisory.rawValue) ?? .pg,
//            productionYear: articleDTO.productionYear,
//            images: articleDTO.images.map { VodImage(id: $0.id, url: URL(string: $0.url) ?? URL(string: "https://example.com/placeholder.png")!) },
//            superGenres: articleDTO.superGenres.compactMap { Genre(rawValue: $0.rawValue) },
//            links: articleDTO.links.compactMap { URL(string: $0) },
//            price: articleDTO.price,
//            status: VodStatus(rawValue: articleDTO.status.rawValue) ?? .available,
//            trailers: articleDTO.trailers.compactMap { URL(string: $0) },
//            duration: articleDTO.duration,
//            type: VideoType(rawValue: articleDTO.type.rawValue) ?? .feature,
//            covers: articleDTO.covers.map { Image(id: $0.id, url: URL(string: $0.url) ?? URL(string: "https://example.com/placeholder.png")!) },
//            videoType: VideoType(rawValue: articleDTO.videoType.rawValue) ?? .feature
//        )
//    }
//
//    return Category(
//        id: dto.id,
//        title: dto.title,
//        name: dto.name,
//        advisory: Advisory(rawValue: dto.advisory.rawValue) ?? .pg,
//        images: dto.images.map { Image(id: $0.id, url: URL(string: $0.url) ?? URL(string: "https://example.com/placeholder.png")!) },
//        catalogID: dto.catalogID,
//        articles: articles,
//        covers: dto.covers.map { Image(id: $0.id, url: URL(string: $0.url) ?? URL(string: "https://example.com/placeholder.png")!) },
//        superGenres: dto.superGenres.compactMap { Genre(rawValue: $0.rawValue) },
//        highlights: dto.highlights.map { articleDTO in
//            Article(
//                id: articleDTO.id,
//                title: articleDTO.title,
//                csa: CSA(rawValue: articleDTO.csa.rawValue) ?? .csa1,
//                advisory: Advisory(rawValue: articleDTO.advisory.rawValue) ?? .pg,
//                productionYear: articleDTO.productionYear,
//                images: articleDTO.images.map { Image(id: $0.id, url: URL(string: $0.url) ?? URL(string: "https://example.com/placeholder.png")!) },
//                superGenres: articleDTO.superGenres.compactMap { Genre(rawValue: $0.rawValue) },
//                links: articleDTO.links.compactMap { URL(string: $0) },
//                price: articleDTO.price,
//                status: Status(rawValue: articleDTO.status.rawValue) ?? .available,
//                trailers: articleDTO.trailers.compactMap { URL(string: $0) },
//                duration: articleDTO.duration,
//                type: VideoType(rawValue: articleDTO.type.rawValue) ?? .feature,
//                covers: articleDTO.covers.map { Image(id: $0.id, url: URL(string: $0.url) ?? URL(string: "https://example.com/placeholder.png")!) },
//                videoType: VideoType(rawValue: articleDTO.videoType.rawValue) ?? .feature
//            )
//        }
//    )
//}

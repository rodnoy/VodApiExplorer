//
//  Category.swift
//  VodClient
//
//  Created by KIRILL SIMAGIN on 04/04/2024.
//

import Foundation


public enum VodCSA: String, Codable {
    case csa1
    case csa2
    case csa3
    case csa4
    case csa5
}

public struct VodArticle: Identifiable, Codable {
    public let id: String
    public let title: String
    public let synopsis: String?
    public let csa: VodCSA
    public let advisory: VodAdvisory
    public let productionYear: Int
    public let images: [VodImage]
    public let superGenres: [String]
    public let price: Double
    public let status: VodStatus
    public let trailers: [URL]
    public let duration: Int
    public let type: VodContentType
    public let covers: [VodImage]
    public let videoType: VodVideoType
    public init(id: String, title: String, synopsis: String?, csa: VodCSA, advisory: VodAdvisory, productionYear: Int, images: [VodImage], superGenres: [String], price: Double, status: VodStatus, trailers: [URL], duration: Int, type: VodContentType, covers: [VodImage], videoType: VodVideoType) {
        self.id = id
        self.title = title
        self.synopsis = synopsis
        self.csa = csa
        self.advisory = advisory
        self.productionYear = productionYear
        self.images = images
        self.superGenres = superGenres
        self.price = price
        self.status = status
        self.trailers = trailers
        self.duration = duration
        self.type = type
        self.covers = covers
        self.videoType = videoType
    }
//    public init(id: String, title: String, csa: VodCSA, advisory: VodAdvisory, productionYear: Int, images: [VodImage], superGenres: [String], price: Double, status: VodStatus, trailers: [URL], duration: Int, type: VodContentType, covers: [VodImage], videoType: VodVideoType) {
//        self.id = id
//        self.title = title
//        self.csa = csa
//        self.advisory = advisory
//        self.productionYear = productionYear
//        self.images = images
//        self.superGenres = superGenres
//        self.price = price
//        self.status = status
//        self.trailers = trailers
//        self.duration = duration
//        self.type = type
//        self.covers = covers
//        self.videoType = videoType
//    }
}
public enum VodStatus: String, Codable {
    case prospected
    case programmed
    case published
    case removed
}
public struct VodLink: Codable {
    public let link: URL?
    public let catalogId: String?
    public init(link: URL?, catalogId: String?) {
        self.link = link
        self.catalogId = catalogId
    }
}

public struct VodCategory: Identifiable, Codable {
    public let id: String
    public let title: String
    public let name: String
    public let advisory: VodAdvisory
    public let images: [VodImage]
    public let catalogID: String
    public let articles: [VodArticle]
    public let covers: [VodImage]
    public let superGenres: [String]
    public let highlights: [VodArticle]
    
    public init(id: String, title: String, name: String, advisory: VodAdvisory, images: [VodImage], catalogID: String, articles: [VodArticle], covers: [VodImage], superGenres: [String], highlights: [VodArticle]) {
        self.id = id
        self.title = title
        self.name = name
        self.advisory = advisory
        self.images = images
        self.catalogID = catalogID
        self.articles = articles
        self.covers = covers
        self.superGenres = superGenres
        self.highlights = highlights
    }
}

public struct VodImage: Codable {
    public let format: VodImageFormat
    public let url: URL
    public init(format: VodImageFormat, url: URL) {
        self.format = format
        self.url = url
    }
}


public enum VodContentType: String, Codable {
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
public enum VodVideoType: String, Codable {
    case movie
    case episod
}
public enum VodAdvisory: String, Codable {
    case allPublic
    case charm
    case adult
}

public enum VodImageFormat: String, Codable {
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

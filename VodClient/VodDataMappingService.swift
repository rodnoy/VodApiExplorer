//
//  VodDataMappingService.swift
//  VodClient
//
//  Created by KIRILL SIMAGIN on 04/04/2024.
//

import Foundation
public typealias VODCategoryDTO = Components.Schemas.CategoryDetailedDTO
public typealias VODImageDTO = Components.Schemas.ImageDTO
public typealias VODArticleDTO = Components.Schemas.ArticleDTO
public typealias VODLinkDTO = Components.Schemas.LinkDTO
public typealias VODHighlightableDTO = Components.Schemas.HighlightableDTO
public typealias VODArticleListDTO = Components.Schemas.ArticleListDTO
public typealias VODVideoDTO = Components.Schemas.VideoDTO
//typealias
//
//repo
public struct VodDataMappingAssistant {
    
    public init() {}
    
    public func mapCategoryDTOToCategory(dto: VODCategoryDTO) -> VodCategory {
        return VodCategory(
            id: dto.id,
            title: dto.title,
            name: dto.name,
            advisory:
                advisoryCategoryDTOToVodAdvisory(dto: dto.advisory),
            images: dto.images.compactMap(imageDTOToImage),
            catalogID: dto.catalogId,
            articles: articlesDTOToVodArticles(dto: dto.articles),
            covers: [],
            superGenres: [],
            highlights: []
        )
    }
    func imageDTOToImage(dto: VODImageDTO) -> VodImage? {
        guard let url = URL(string: dto.url) else { return nil }
        return VodImage(
            format: VodImageFormat(dtoFormat: dto.format.rawValue),
            url: url
        )
    }
    
    func linkDTOToLink(dto: VODLinkDTO.Value2Payload) -> VodLink? {
        guard let linkString = dto.link, let linkURL = URL(string: linkString) else { return nil }
        return VodLink(
            link: linkURL,
            catalogId: dto.catalogId
        )
    }
    func advisoryCategoryDTOToVodAdvisory(dto: VODCategoryDTO.advisoryPayload) -> VodAdvisory {
        VodAdvisory(payload: dto) ?? .allPublic
    }
    func advisoryHighlightableDTOToVodAdvisory(dto: VODHighlightableDTO.advisoryPayload) -> VodAdvisory {
        VodAdvisory(payload: dto) ?? .allPublic
    }
    func articlesDTOToVodArticles(dto: VODArticleListDTO?) -> [VodArticle]{
        guard let dto = dto else {
            return []
        }
        return dto.items.map(itemPayloadToArticle)
    }
    func createVodArticle(from articleDTO: VODArticleDTO, additionalData: Any) -> VodArticle {
        let id = articleDTO.value1.id
        let title = articleDTO.value1.title
        let synopsis = articleDTO.value2.synopsis
        let images = articleDTO.value1.images.compactMap(imageDTOToImage)
        let covers = articleDTO.value1.covers.compactMap(imageDTOToImage)
        let csa = payloadCSADTOToCSA(dto: articleDTO.value2.csa)
        let advisory = advisoryHighlightableDTOToVodAdvisory(dto: articleDTO.value1.advisory ?? .ALLPUBLIC)
        let type = VodContentType(typePayload: articleDTO.value1._type) ?? .video
        let productionYear = Int(articleDTO.value2.productionYear ?? "0") ?? 0
        let price = getVideoSellPrice(dto: articleDTO.value2.price)
        let status = VodStatus(payload: articleDTO.value2.status ?? .PUBLISHED) ?? .published
        let genres = articleDTO.value2.superGenres ?? []
        var duration = 0
        var videoType = VodVideoType.episod // Default value
        // Extracting additional data
        if let value2 = additionalData as? Components.Schemas.EpisodeDTO.Value2Payload {
            duration = Int(value2.duration ?? 0)
            // Add more specific processing if needed
        }
        if let value2 = additionalData as? VODVideoDTO.Value2Payload {
            duration = Int(value2.duration ?? 0)
            videoType = .movie
        }
        
        return VodArticle(
            id: id,
            title: title,
            synopsis: synopsis,
            csa: csa,
            advisory: advisory,
            productionYear: productionYear,
            images: images,
            superGenres: genres,
            price: price,
            status: status,
            trailers: [],
            duration: duration,
            type: type,
            covers: covers,
            videoType: videoType
        )
    }
    func itemPayloadToArticle(dto: VODArticleListDTO.itemsPayloadPayload) -> VodArticle {
        switch dto {
        case .EpisodeDTO(let episode):
            return createVodArticle(from: episode.value1, additionalData: episode.value2)
        case .PackageDTO(let package):
            return createVodArticle(from: package.value1, additionalData: package.value2)
        case .VideoDTO(let video):
            return createVodArticle(from: video.value1, additionalData: video.value2)
        case .SeriesDTO(let series):
            return createVodArticle(from: series.value1, additionalData: series.value2)
        case .SeasonDTO(let season):
            return createVodArticle(from: season.value1, additionalData: season.value2)
        }
    }
    
    func getVideoSellPrice(dto: Components.Schemas.PriceDTO?) -> Double{
        return dto?.sellMinimalCatalogPrice ?? 0
    }
    func payloadCSADTOToCSA(dto: VODArticleDTO.Value2Payload.csaPayload?) -> VodCSA {
        var _dto: VODArticleDTO.Value2Payload.csaPayload = ._1
        if let dto = dto {
            _dto = dto
        }
        return VodCSA(csa: _dto) ?? .csa1
    }
}

extension VodImageFormat {
    init(dtoFormat: String) {
        self = VodImageFormat(rawValue: dtoFormat.uppercased()) ?? .cover
    }
}

extension VodCSA {
    init? (csa: VODArticleDTO.Value2Payload.csaPayload) {
        switch csa {
        case ._1:
            self = .csa1
        case ._2:
            self = .csa2
        case ._3:
            self = .csa3
        case ._4:
            self = .csa4
        case ._5:
            self = .csa5
        }
    }
}

extension VodContentType {
    init?(typePayload: VODHighlightableDTO._typePayload) {
        switch typePayload {
        case .VIDEO: self = .video
        case .SERIES: self = .series
        case .SEASON: self = .season
        case .CATEGORY: self = .category
        case .DISCOUNT_CATEGORY: self = .discountCategory
        case .PACKAGE: self = .package
        case .LINK: self = .link
        case .CORNER: self = .corner
        case .CATALOG: self = .catalog
        case .MENU: self = .menu
        case .APPLICATION: self = .application
        }
    }
}
extension VodContentType {
    init?(typePayload: VODCategoryDTO._typePayload) {
        switch typePayload {
        case .VIDEO: self = .video
        case .SERIES: self = .series
        case .SEASON: self = .season
        case .CATEGORY: self = .category
        case .DISCOUNT_CATEGORY: self = .discountCategory
        case .PACKAGE: self = .package
        case .LINK: self = .link
        case .CORNER: self = .corner
        case .CATALOG: self = .catalog
        case .MENU: self = .menu
        case .APPLICATION: self = .application
        }
    }
}
extension VodAdvisory {
    init?(payload: VODCategoryDTO.advisoryPayload) {
        switch payload {
        case .ALLPUBLIC: self = .allPublic
        case .CHARM: self = .charm
        case .ADULT: self = .adult
        }
    }
}
extension VodAdvisory {
    init?(payload: VODHighlightableDTO.advisoryPayload) {
        switch payload {
        case .ALLPUBLIC: self = .allPublic
        case .CHARM: self = .charm
        case .ADULT: self = .adult
        }
    }
}
extension VodStatus {
    init?(payload:  VODArticleDTO.Value2Payload.statusPayload) {
        switch payload {
        case .PROSPECTED: self = .prospected
        case .PROGRAMMED: self = .programmed
        case .PUBLISHED: self = .published
        case .REMOVED: self = .removed
        }
    }
}
//
extension VodVideoType {
    init?(payload: VODVideoDTO.Value2Payload.videoTypePayload) {
        switch payload {
        case .MOVIE:
            self = .movie
        case .EPISODE:
            self = .episod
        }
    }
}

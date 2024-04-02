//
//  VodDataMappingService.swift
//  VodClient
//
//  Created by KIRILL SIMAGIN on 04/04/2024.
//

import Foundation

class DataMappingService {
    //    func mapCategoryDTOToCategory(dto: Components.Schemas.CategoryDetailedDTO) -> VodCategory {
    //        return VodCategory(id: dto.id, title: dto.title, name: dto.name, advisory: advisoryCategoryDTOToVodAdvisory(dto: dto.advisory), images: dto.images.compactMap(imageDTOToImage), catalogID: dto.catalogId, articles: <#T##[VodArticle]#>, covers: <#T##[VodImage]#>, superGenres: <#T##[Genre]#>, highlights: <#T##[VodArticle]#>)
    //
    //
    //        //        return Category(
    //        //            id: dto.value2.id ?? "",
    //        //            title: dto.value2.title ?? "",
    //        //            type: VodContentType(rawValue: dto.value2._type?.rawValue.uppercased() ?? "") ?? .video,
    //        //            advisory: VodAdvisory(rawValue: dto.value2.advisory?.rawValue.uppercased() ?? "") ?? .allPublic,
    //        //            images: dto.value2.images?.map(ImageDTOToImage) ?? [],
    //        //            name: dto.value2.name ?? "",
    //        //            discountPitch: dto.value2.discountPitch ?? "",
    //        //            nature: ContentNature(rawValue: dto.value2.nature?.rawValue.uppercased() ?? "") ?? .composite,
    //        //            catalogId: dto.value2.catalogId ?? "",
    //        //            links: dto.value2.links?.compactMap(linkDTOToLink) ?? [],
    //        //            covers: dto.value2.covers?.map(ImageDTOToImage) ?? []
    //        //        )
    //    }
    
    func imageDTOToImage(dto: Components.Schemas.ImageDTO) -> VodImage {
        return VodImage(
            format: ImageFormat(rawValue: dto.format.rawValue.uppercased()) ?? .cover,
            url: URL(string: dto.url)!
        )
    }
    
    func linkDTOToLink(dto: Components.Schemas.LinkDTO.Value2Payload) -> VodLink? {
        guard let linkString = dto.link, let linkURL = URL(string: linkString) else { return nil }
        return VodLink(
            link: linkURL,
            catalogId: dto.catalogId
        )
    }
    //    func linkDTOToLink(dto: Components.Schemas.LinkDTO.Value2Payload) -> VodLink? {
    //        guard let linkString = dto.link, let linkURL = URL(string: linkString) else { return nil }
    //        return VodLink(
    //            link: linkURL,
    //            catalogId: dto.catalogId
    //        )
    //    }
    func advisoryCategoryDTOToVodAdvisory(dto: Components.Schemas.CategoryDetailedDTO.advisoryPayload) -> VodAdvisory {
        VodAdvisory(payload: dto) ?? .allPublic
    }
    func advisoryHighlightableDTOToVodAdvisory(dto: Components.Schemas.HighlightableDTO.advisoryPayload) -> VodAdvisory {
        VodAdvisory(payload: dto) ?? .allPublic
    }
    //typealias itemsPayload = [Components.Schemas.ArticleListDTO.itemsPayloadPayload]
    //    Components.Schemas.ArticleListDTO
    func ArticlesDTOToVodArticles(dto: Components.Schemas.ArticleListDTO) {
        //        dto.items.map {
        //
        //        }
    }
    
    func createVodArticle(from articleDTO: Components.Schemas.ArticleDTO, additionalData: Any) -> VodArticle {
        let id = articleDTO.value1.id
        let title = articleDTO.value1.title
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
        if let value2 = additionalData as? Components.Schemas.VideoDTO.Value2Payload {
            duration = Int(value2.duration ?? 0)
            videoType = .movie
        }

        return VodArticle(
            id: id,
            title: title,
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
    func itemPayloadToArticle(dto: Components.Schemas.ArticleListDTO.itemsPayloadPayload) -> VodArticle {
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
    
//    func itemPayloadToArticle(dto: Components.Schemas.ArticleListDTO.itemsPayloadPayload) -> VodArticle{
//        switch dto {
//        case .EpisodeDTO(let episode):
//            VodArticle(
//                id: episode.value1.value1.id,
//                title: episode.value1.value1.title,
//                csa: payloadCSADTOToCSA(dto: episode.value1.value2.csa),
//                advisory: advisoryHighlightableDTOToVodAdvisory(dto: episode.value1.value1.advisory ?? .ALLPUBLIC),
//                productionYear: Int(episode.value1.value2.productionYear ?? "0") ?? 0,
//                images: episode.value1.value1.images.compactMap(imageDTOToImage),
//                superGenres: episode.value1.value2.superGenres ?? [],
//                price: getVideoSellPrice(dto: episode.value1.value2.price),
//                status: VodStatus(payload: episode.value1.value2.status ?? .PUBLISHED) ?? .published,
//                trailers: [],
//                duration: 0,
//                type: VodContentType(typePayload: episode.value1.value1._type) ?? .video,
//                covers: episode.value1.value1.covers.compactMap(imageDTOToImage),
//                videoType: .episod
//            )
//        case .PackageDTO(let package):
//            VodArticle(
//                id: package.value1.value1.id,
//                title: package.value1.value1.title,
//                csa: payloadCSADTOToCSA(dto: package.value1.value2.csa),
//                advisory: advisoryHighlightableDTOToVodAdvisory(dto: package.value1.value1.advisory ?? .ALLPUBLIC),
//                productionYear: Int(package.value1.value2.productionYear ?? "0") ?? 0,
//                images: package.value1.value1.images.compactMap(imageDTOToImage),
//                superGenres: package.value1.value2.superGenres ?? [],
//                price: getVideoSellPrice(dto: package.value1.value2.price),
//                status: VodStatus(payload: package.value1.value2.status ?? .PUBLISHED) ?? .published,
//                trailers: [],
//                duration: 0,
//                type: VodContentType(typePayload: package.value1.value1._type) ?? .video,
//                covers: package.value1.value1.covers.compactMap(imageDTOToImage),
//                videoType: .episod)
//        case .SeasonDTO(let season):
//            VodArticle(
//                id: season.value1.value1.id,
//                title: season.value1.value1.title,
//                csa: payloadCSADTOToCSA(dto: season.value1.value2.csa),
//                advisory: advisoryHighlightableDTOToVodAdvisory(dto: season.value1.value1.advisory ?? .ALLPUBLIC),
//                productionYear: Int(season.value1.value2.productionYear ?? "0") ?? 0,
//                images: season.value1.value1.images.compactMap(imageDTOToImage),
//                superGenres: season.value1.value2.superGenres ?? [],
//                price: getVideoSellPrice(dto: season.value1.value2.price),
//                status: VodStatus(payload: season.value1.value2.status ?? .PUBLISHED) ?? .published,
//                trailers: [],
//                duration: 0,
//                type: VodContentType(typePayload: season.value1.value1._type) ?? .video,
//                covers: season.value1.value1.covers.compactMap(imageDTOToImage),
//                videoType: .episod)
//        case .SeriesDTO(let series):
//            VodArticle(
//                id: series.value1.value1.id,
//                title: series.value1.value1.title,
//                csa: payloadCSADTOToCSA(dto: series.value1.value2.csa),
//                advisory: advisoryHighlightableDTOToVodAdvisory(dto: series.value1.value1.advisory ?? .ALLPUBLIC),
//                productionYear: Int(series.value1.value2.productionYear ?? "0") ?? 0,
//                images: series.value1.value1.images.compactMap(imageDTOToImage),
//                superGenres: series.value1.value2.superGenres ?? [],
//                price: getVideoSellPrice(dto: series.value1.value2.price),
//                status: VodStatus(payload: series.value1.value2.status ?? .PUBLISHED) ?? .published,
//                trailers: [],
//                duration: 0,
//                type: VodContentType(typePayload: series.value1.value1._type) ?? .video,
//                covers: series.value1.value1.covers.compactMap(imageDTOToImage),
//                videoType: .episod)
//        case .VideoDTO(let video):
//            VodArticle(
//                id: video.value1.value1.id,
//                title: video.value1.value1.title,
//                csa: payloadCSADTOToCSA(dto: video.value1.value2.csa),
//                advisory: advisoryHighlightableDTOToVodAdvisory(dto: video.value1.value1.advisory ?? .ALLPUBLIC),
//                productionYear: Int(video.value1.value2.productionYear ?? "0") ?? 0,
//                images: video.value1.value1.images.compactMap(imageDTOToImage),
//                superGenres: video.value1.value2.superGenres ?? [],
//                price: getVideoSellPrice(dto: video.value1.value2.price),
//                status: VodStatus(payload: video.value1.value2.status ?? .PUBLISHED) ?? .published,
//                trailers: [],
//                duration: Int(video.value2.duration ?? 0),
//                type: VodContentType(typePayload: video.value1.value1._type) ?? .video,
//                covers: video.value1.value1.covers.compactMap(imageDTOToImage),
//                videoType: VodVideoType(payload:video.value2.videoType ?? .MOVIE) ?? .movie)
//        }
//    }
    func getVideoSellPrice(dto: Components.Schemas.PriceDTO?) -> Double{
        return dto?.sellMinimalCatalogPrice ?? 0
    }
    func payloadCSADTOToCSA(dto: Components.Schemas.ArticleDTO.Value2Payload.csaPayload?) -> CSA {
        var _dto: Components.Schemas.ArticleDTO.Value2Payload.csaPayload = ._1
        if let dto = dto {
            _dto = dto
        }
        return CSA(csa: _dto) ?? .csa1
    }
}


extension CSA {
    init? (csa: Components.Schemas.ArticleDTO.Value2Payload.csaPayload) {
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
    init?(typePayload: Components.Schemas.HighlightableDTO._typePayload) {
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
    init?(typePayload: Components.Schemas.CategoryDetailedDTO._typePayload) {
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
    init?(payload: Components.Schemas.CategoryDetailedDTO.advisoryPayload) {
        switch payload {
        case .ALLPUBLIC: self = .allPublic
        case .CHARM: self = .charm
        case .ADULT: self = .adult
        }
    }
}
extension VodAdvisory {
    init?(payload: Components.Schemas.HighlightableDTO.advisoryPayload) {
        switch payload {
        case .ALLPUBLIC: self = .allPublic
        case .CHARM: self = .charm
        case .ADULT: self = .adult
        }
    }
}
extension VodStatus {
    init?(payload:  Components.Schemas.ArticleDTO.Value2Payload.statusPayload) {
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
    init?(payload: Components.Schemas.VideoDTO.Value2Payload.videoTypePayload) {
        switch payload {
        case .MOVIE:
            self = .movie
        case .EPISODE:
            self = .episod
        }
    }
}

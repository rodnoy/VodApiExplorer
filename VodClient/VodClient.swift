//
//  VodClient.swift
//  VodClient
//
//  Created by KIRILL SIMAGIN on 28/03/2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import HTTPTypes


struct HeadersMiddleware: ClientMiddleware {
    func intercept(_ request: HTTPRequest, body: HTTPBody?, baseURL: URL, operationID: String, next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        let headerText = UserAgentHelper.userAgent
        request.headerFields[.userAgent] = headerText
        print(headerText)
        return try await next(request, body, baseURL)
    }

    
}
// Server1 : server pour acceder à categorie

public struct VodClient {
    let client: Client
    public init() {
        client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport(),
            middlewares: [HeadersMiddleware()]
        )
    }
    //Components.Schemas.CategoryDetailedDTO
    public func getAllCategories() async throws -> String{
        let response =  try await client.getCategoryFull(
            path: .init(
                version: VodClientConstants.versionKey,
                catalogId: VodClientConstants.catalogIDKey,
                categoryId: VodClientConstants.categoryIDKey),
            query: .init(filterCharmAdult: false))
        switch response {
        case let .ok(okResponse):
            switch okResponse.body {
            case .json(let categoryDetailedDTO):
                return categoryDetailedDTO.name
            }
        default:
            throw "Failed to fetch categories"
        }
    }
}

extension String: LocalizedError {
    
    public var errorDescription: String? { self }
}

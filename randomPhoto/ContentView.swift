//
//  ContentView.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/9/14.
//

import SwiftUI
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct ContentView: View {
    @State var 動態圖片url="https://res.cloudinary.com/alchemyapi/image/upload/w_250,h_250/mainnet/07783aaf80e4c4497725b2da0af33394.png"
    var body: some View {
        ZStack{
            Color.purple
                .ignoresSafeArea()
            VStack{
                
                AsyncImage(url: URL(string: 動態圖片url))
                Button(action: {
                    var token_id = Int.random(in: 1..<389)
                    
                    // This file was generated from JSON Schema using quicktype, do not modify it directly.
                    // To parse the JSON, add this file to your project and do:
                    //
                    //   let nftMeta = try? newJSONDecoder().decode(NftMeta.self, from: jsonData)

                    // MARK: - NftMeta
                    struct NftMeta: Codable {
                        let contract: Contract
                        let id: ID
                        let title, nftMetaDescription: String
                        let tokenURI: TokenURI
                        let media: [Media]
                        let metadata: Metadata
                        let timeLastUpdated: String
                        let contractMetadata: ContractMetadata

                        enum CodingKeys: String, CodingKey {
                            case contract, id, title
                            case nftMetaDescription = "description"
                            case tokenURI = "tokenUri"
                            case media, metadata, timeLastUpdated, contractMetadata
                        }
                    }

                    // MARK: - Contract
                    struct Contract: Codable {
                        let address: String
                    }

                    // MARK: - ContractMetadata
                    struct ContractMetadata: Codable {
                        let name, symbol, totalSupply, tokenType: String
                    }

                    // MARK: - ID
                    struct ID: Codable {
                        let tokenID: String
                        let tokenMetadata: TokenMetadata

                        enum CodingKeys: String, CodingKey {
                            case tokenID = "tokenId"
                            case tokenMetadata
                        }
                    }

                    // MARK: - TokenMetadata
                    struct TokenMetadata: Codable {
                        let tokenType: String
                    }

                    // MARK: - Media
                    struct Media: Codable {
                        let raw, gateway, thumbnail: String
                        let format: String
                        let bytes: Int
                    }

                    // MARK: - Metadata
                    struct Metadata: Codable {
                        let name: String
                        let image: String
                        let metadataDescription, imageSerialNum: String

                        enum CodingKeys: String, CodingKey {
                            case name, image
                            case metadataDescription = "description"
                            case imageSerialNum = "image_serial_num"
                        }
                    }

                    // MARK: - TokenURI
                    struct TokenURI: Codable {
                        let raw, gateway: String
                    }

                    let semaphore = DispatchSemaphore (value: 0)

                    var request = URLRequest(url: URL(string: "https://eth-mainnet.alchemyapi.io/v2/demo/getNFTMetadata?contractAddress=0x1e39a585b465a319e0ffbfb43306a82c5594a8fc&tokenId=\(String(token_id))&tokenType=erc721")!,timeoutInterval: Double.infinity)
                    request.httpMethod = "GET"

                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                      guard let data = data else {
                        print(String(describing: error))
                        semaphore.signal()
                        return
                      }
                      // print(String(data: data, encoding: .utf8)!)
                      let NftMeta = try? JSONDecoder().decode(NftMeta.self, from: data)
                        動態圖片url = NftMeta?.media[0].thumbnail ?? "null"
                        動態圖片url = 動態圖片url.replacingOccurrences(of: "h_256", with: "h_170", options: .literal, range: nil)
                      semaphore.signal()
                    }

                    task.resume()
                    semaphore.wait()


                }, label: {
                    Text("換圖片")
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

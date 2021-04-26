//
//  NetworkMethods.swift
//  AppExample
//
//  Created by slava on 26/04/2021.
//

import Foundation
import Combine


protocol NetworkServiceProtocol {
    
    func requestData()
    
}

public class NetworkService {
    
    //MARK: Post
    func postRequest(url: RequestURL, accesKey: Constants, idClient: String, idDevice: String) -> AnyPublisher<PostData, Never> {
        let session = URLSession.shared
        guard let url = URL(string: url.rawValue) else { return Just(PostData(accessToken: "")).eraseToAnyPublisher()}
        
        let json = [
            "idClient": idClient,
            "paramValue": idDevice
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accesKey.rawValue, forHTTPHeaderField: "AccessKey")
        
        
        return session
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: PostData.self, decoder: JSONDecoder())
            .replaceError(with: PostData(accessToken: ""))
            .eraseToAnyPublisher()
    }
    
    //MARK: GET
    func getRequest(url: RequestURL, token: String, accesKey: Constants) ->  AnyPublisher<GetModel, NetworkError> {
        let session = URLSession.shared
        let getURL: URL = URL(string: url.rawValue + token) ?? .init(fileURLWithPath: "")
        let decoder = JSONDecoder()
        
        var request = URLRequest(url: getURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accesKey.rawValue, forHTTPHeaderField: "AccessKey")
        
        return session
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap{
                guard let httpResponse = $0.response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.unknown
                }
                let value = try decoder.decode(GetModel.self, from: $0.data)
                return GetModel(resultOperation: value.resultOperation, data: value.data)
            }
            .mapError { err in
                if let error = err as? NetworkError {
                    return error
                } else {
                    return NetworkError.apiError(reason: err.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}


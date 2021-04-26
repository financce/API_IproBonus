//
//  Observer.swift
//  AppExample
//
//  Created by slava on 26/04/2021.
//

import Foundation
import Combine


public class Observer: ObservableObject {
    
    @Published var idToken = ""
    @Published public var typeBonus = ""
    @Published public var bonusCurrentQuantity = 0
    @Published public var forBurningQuantity = 0
    @Published public var dateBurning = Date()
    @Published private var idDevice: String
    @Published private var idClient: String
    
    
    var networkService = NetworkService()
    var postRequest: AnyCancellable?
    var getRequest: AnyCancellable?
    var cancellable: Cancellable?
    
    public init(idClient: String, idDevice: String) {
        self.idDevice = idDevice
        self.idClient = idClient
        
        self.postRequest = self.networkService.postRequest(url: .postURL, accesKey: .accessKey, idClient: self.idClient, idDevice: self.idDevice)
            .receive(on: DispatchQueue.main)
            .sink { res in
                switch res {
                case .finished:
                    break
                case .failure(let err):
                    print("Error \(err.localizedDescription)")
                }
                
            } receiveValue: { post in
                self.idToken = post.accessToken
                NotificationCenter.default.post(name: NSNotification.Name(Constants.notyGet.rawValue), object: nil)
            }
        
        cancellable = NotificationCenter.default
            .publisher(for: NSNotification.Name(Constants.notyGet.rawValue))
            .sink() {[weak self] _ in
                guard let self = self else { return }
                self.getRequest = self.networkService.getRequest(url: .getURL, token: self.idToken, accesKey: .accessKey)
                    .receive(on: DispatchQueue.main)
                    .print()
                    .sink(receiveCompletion: { res in
                        switch res {
                        case .finished:
                            break
                        case .failure(let err):
                            print(err.localizedDescription)
                        }
                        
                    }, receiveValue: {[weak self] model in
                        guard let self = self else {return}
                        self.typeBonus = model.data.typeBonusName
                        self.bonusCurrentQuantity = model.data.currentQuantity
                        self.dateBurning = self.dateFormater(date: model.data.dateBurning)
                        self.forBurningQuantity = model.data.forBurningQuantity
                        
                    })
            }
    }
    
    func dateFormater(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.date(from: date) ?? Date()
        return date
    }
}



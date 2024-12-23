//
//  HoldingService.swift
//  SiddheshDemo
//
//  Created by Siddhesh Redkar on 22/12/24.
//

import Foundation

protocol HoldingServiceProtocol:AnyObject{
    func fetchUserHoldings(completion: @escaping ([UserHolding]?, Error?) -> ())
    func readLocalJSONFile(forName name: String,completion: @escaping ([UserHolding]?, Error?)-> ())
}

class HoldingService {
    public init(){
    }
}

extension HoldingService:HoldingServiceProtocol{
    func fetchUserHoldings(completion: @escaping ([UserHolding]?, Error?) -> ()) {
        let urlString = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch UserHolding:", err)
                return
            }
            
            // check response
            
            guard let data = data else { return }
            do {
                let holdingData = try JSONDecoder().decode(Welcome.self, from: data)
                let userHoldings = holdingData.data?.userHoldings
                
                DispatchQueue.main.async {
                    completion(userHoldings, nil)
                }
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
            }.resume()
    }
    
    func readLocalJSONFile(forName name: String,completion: @escaping ([UserHolding]?, Error?) -> ()){
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                do {
                    let holdingData = try JSONDecoder().decode(Welcome.self, from: data)
                    guard let data = holdingData.data else{
                        completion(nil, nil)
                        return
                    }
                    let userHoldings = data.userHoldings
                    
                    DispatchQueue.main.async {
                        completion(userHoldings, nil)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    
    
    
    
}

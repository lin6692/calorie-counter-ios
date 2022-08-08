//
//  FoodDetailAPI.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/7/22.
//

import SwiftUI

struct JSONParameters:Encodable {
    let search_term: String
}

struct FoodDetail:Codable, Identifiable {
    let id = UUID()
    var name: String
    var ounce: [Int]
    var serving: [Int]
    var slice: [Int]
    var whole: [Int]
}

func convertIntoJSONString(arrayObject: [Any]) -> String? {

        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }

class Api {
    func getInfo(search_term:String, completion: @escaping (FoodDetail) -> () ) {
        var components = URLComponents(string: "http://127.0.0.1:5000/calories")!
        components.queryItems = [
            URLQueryItem(name:"search_term", value: search_term)
        ]
        
        var request = URLRequest(url: components.url!)
        URLSession.shared.dataTask(with: request) { data, _, _ in
           
            let foodInfo = try! JSONDecoder().decode(FoodDetail.self, from:data!)
            DispatchQueue.main.async {
                completion(foodInfo)
            }
        }
        .resume()
    }
}

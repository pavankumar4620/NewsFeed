//
//  Services.swift
//  NewsFeed
//
//  Created by Gamenexa_iOS3 on 18/09/19.
//  Copyright © 2019 Gamenexa_iOS3. All rights reserved.
//

import Foundation

protocol APIResponse {
    func errorResponse(error : NSError)
    func successResponse(response: Any)
}


class Services: NSObject {

    var apiReponseProtocol : APIResponse?
    
   
    func signupServiceCall(url urlStr: String, body: NSDictionary, requestStr: String ) {
        
        let Url = String(format: urlStr)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = requestStr
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.apiReponseProtocol?.successResponse(response: json)
                    print("=== json ===", json)
                } catch {
                    print("=== error ===", error)
                    self.apiReponseProtocol?.errorResponse(error: error as NSError)
                }
            }
            }.resume()
    }
    
    func newsFeedList(url urlStr: String, body: NSDictionary, requestStr: String, apitoken : String) {
        let Url = String(format: urlStr)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        
        let headers = [
            "Accept": "application/json",
            "Authorization": apitoken]
        
        request.httpMethod = requestStr
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
       
        session.dataTask(with: request) { (data, response, error) in
          
            if let data = data {
                do {
                    let responseData = try JSONDecoder().decode(News.self, from: data)
                    self.apiReponseProtocol?.successResponse(response: responseData)
                    
                } catch {
                    print("=== error ===", error)
                    self.apiReponseProtocol?.errorResponse(error: error as NSError)
                }
            }
            }.resume()
 
    }
    }



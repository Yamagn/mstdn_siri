//
//  APIController.swift
//  TootFromSiri
//
//  Created by ymgn on 2018/10/21.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation

let api = APIController()

class HttpClientImpl {
    private let session: URLSession
    public  init(config: URLSessionConfiguration? = nil) {
        self.session = config.map { URLSession(configuration: $0) } ?? URLSession.shared
    }
    
    public func execute(request: URLRequest) -> (NSData?, URLResponse?, NSError?) {
        var d: NSData? = nil
        var r: URLResponse? = nil
        var e: NSError? = nil
        let semaphore = DispatchSemaphore(value: 0)
        session.dataTask(with: request) { (data, response, error) -> Void in
            d = data as NSData?
            r = response
            e = error as NSError?
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return(d, r, e)
    }
}

struct Toots: Codable {
    let content: String
    let account: Account
}

struct Account: Codable {
    let avatar: URL
    let username: String
    let display_name: String
}

class APIController {
    func regist(domain: String, responseJson: Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject>? {
        let registUrl = URL(string: "https://" + domain + "/api/v1/apps")!
        
        let registBody: [String: String] = ["client_name": "TootFromSiri", "redirect_uris": "urn:ietf:wg:oauth:2.0:oob", "scopes": "write read"]
        
        do {
            var request: URLRequest = URLRequest(url: registUrl)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: registBody, options: .prettyPrinted)
            
            let session = HttpClientImpl()
            let (data, _, _) = session.execute(request: request as URLRequest)
            if data == nil {
                return nil
            }
            return try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? Dictionary<String, AnyObject>
        } catch {
            
            return nil
        }
    }
    
    func loginAuth(domain: String, mail: String, pass: String, responseJson: Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject>? {
        let loginUrl = URL(string: "https://" + domain + "/oauth/token")!
        if responseJson["client_id"] == nil{
            print("regist failed")
            return nil
        }
        
        let loginBody: [String: String] = ["scope": "write read", "client_id": responseJson["client_id"] as! String, "client_secret": responseJson["client_secret"] as! String, "grant_type": "password", "username": mail, "password": pass]
        
        do {
            var request: URLRequest = URLRequest(url: loginUrl)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: loginBody, options: .prettyPrinted)
            
            let session = HttpClientImpl()
            let (data, _, _) = session.execute(request: request as URLRequest)
            return try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? Dictionary<String, AnyObject>
        } catch {
            return nil
        }
    }
    
    func toot(domain: String, content: String, responseJson: Dictionary<String, AnyObject>?) -> Dictionary<String, AnyObject>? {
        let tootUrl = URL(string: "https://" + domain + "/api/v1/statuses")!
        
        let tootBody: [String: String] = ["access_token": responseJson?["access_token"] as! String, "status": content, "visibility": "public"]
        do {
            var request: URLRequest = URLRequest(url: tootUrl)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: tootBody, options: .prettyPrinted)
            
            let session = HttpClientImpl()
            let (data, _, _) = session.execute(request: request as URLRequest)
            return try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? Dictionary<String, AnyObject>
        } catch {
            return nil
        }
    }
    
    func getTl(domain: String, responseJson: Dictionary<String, AnyObject>?) -> [Toots] {
        let getTlUrl = URL(string: "https://" + domain + "/api/v1/timelines/home")!
        var request: URLRequest = URLRequest(url: getTlUrl)
        guard let accessToken = responseJson?["access_token"] else {
            return []
        }
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + (accessToken as! String), forHTTPHeaderField: "Authorization")
        let session = HttpClientImpl()
        let (data, _, _) = session.execute(request: request as URLRequest)
        guard let jsonData: NSData = data else {
            return []
        }
        return try! JSONDecoder().decode([Toots].self, from: jsonData as Data)
    }
    
    func tootWithToken(domain: String, content: String, access_token: String) -> Dictionary<String, AnyObject>? {
        let tootUrl = URL(string: "https://" + domain + "/api/v1/statuses")!
        let tootBody: [String: String] = ["access_token": access_token, "status": content, "visibility": "public"]
        do {
            var request: URLRequest = URLRequest(url: tootUrl)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: tootBody, options: .prettyPrinted)
            
            let session = HttpClientImpl()
            let (data, _, _) = session.execute(request: request as URLRequest)
            return try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? Dictionary<String, AnyObject>
        } catch {
            return nil
        }
    }
    
    func getTlWithToken(domain: String, access_token: String) -> [Toots] {
        let getTlUrl = URL(string: "https://" + domain + "/api/v1/timelines/home?limit=10")!
        var request: URLRequest = URLRequest(url: getTlUrl)
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + access_token, forHTTPHeaderField: "Authorization")
        let session = HttpClientImpl()
        let (data, _, _) = session.execute(request: request as URLRequest)
        guard let jsonData: NSData = data else {
            return []
        }
        return try! JSONDecoder().decode([Toots].self, from: jsonData as Data)
    }
}

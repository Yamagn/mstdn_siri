//
//  TootIntentHandler.swift
//  TootTest
//
//  Created by ymgn on 2018/10/20.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation

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

class TootIntentHandler: NSObject ,TootIntentHandling {
    func confirm(intent: TootIntent, completion: @escaping (TootIntentResponse) -> Void) {
        let vc = ViewController()

        let registBody: [String: String] = ["client_name": "TootFromSiri", "redirect_uris": "urn:ietf:wg:oauth:2.0:oob", "scopes": "write"]

        do {
            let registUrl = URL(string: "https://" + domain + "/api/v1/apps")!
            var request: URLRequest = URLRequest(url: registUrl)

            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: registBody, options: .prettyPrinted)

            let session = HttpClientImpl()
            var (data, _, _) = session.execute(request: request as URLRequest)
            vc.responseJson = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! Dictionary<String, AnyObject>
        } catch {
            print(error)
            return;
        }
        let loginUrl = URL(string: "https://" + domain + "/oauth/token")!
        if vc.responseJson["client_id"] == nil{
            return
        }

        let loginBody: [String: String] = ["scope": "write", "client_id": vc.responseJson["client_id"] as! String, "client_secret": vc.responseJson["client_secret"] as! String, "grant_type": "password", "username": mail, "password": pass]

        do {
            var request: URLRequest = URLRequest(url: loginUrl)

            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: loginBody, options: .prettyPrinted)

            let session = HttpClientImpl()
            var (data, _, _) = session.execute(request: request as URLRequest)
            vc.responseJson = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! Dictionary<String, AnyObject>
        } catch {
            print(error)
            return
        }
    }
    func handle(intent: TootIntent, completion: @escaping (TootIntentResponse) -> Void) {
        let vc = ViewController()
        let tootUrl = URL(string: "https://" + "mstdn.maud.io" + "/api/v1/statuses")!

        let tootBody: [String: String] = ["access_token": vc.responseJson["access_token"] as! String, "status": "Hello Mstdn", "visibility": "public"]
        do {
            var request: URLRequest = URLRequest(url: tootUrl)

            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: tootBody, options: .prettyPrinted)

            let session = HttpClientImpl()
            let (data, _, _) = session.execute(request: request as URLRequest)
            _ = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! Dictionary<String, AnyObject>
        } catch {
            print(error)
            return
        }
        print("Success")
        completion(TootIntentResponse.success(tootContent: "Hello Mstdn"))
    }
}

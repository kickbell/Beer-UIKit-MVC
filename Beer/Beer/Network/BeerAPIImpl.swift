//
//  BeerAPIImpl.swift
//  Beer
//
//  Created by jc.kim on 2/9/23.
//

import Foundation

class BeerAPIImpl: BeerAPI {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func random() {
        session.request(.random) { data, response, error in
            guard let data = data else { return }
            
            do {
                let beers = try JSONDecoder().decode([Beer].self, from: data)
                print(beers)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func single(withID id: Int) {
        session.request(.single(withID: id)) { data, response, error in
            guard let data = data else { return }
            
            do {
                let beers = try JSONDecoder().decode([Beer].self, from: data)
                print(beers)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func search(for page: Int) {
        session.request(.search(for: page)) { data, response, error in
            guard let data = data else { return }
            
            do {
                let beers = try JSONDecoder().decode([Beer].self, from: data)
                print(beers)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}






extension URLSession {
    
    enum NetworkError: Error {
        case notValidateStatusCode  // 유효하지 않는 StatusCode
        case noData                 // 결과 데이터 미존재
        case failDecode             // Decode 실패
    }
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    @discardableResult
    func request(
        _ endpoint: Endpoint,
        then handler: @escaping Handler
    ) -> URLSessionDataTask {
        let task = dataTask(
            with: endpoint.url,
            completionHandler: handler
        )

        task.resume()
        return task
    }
}

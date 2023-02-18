//
//  ImageLoader.swift
//  Beer
//
//  Created by jc.kim on 2/18/23.
//

import Foundation
import UIKit.UIImage
import Combine

public final class ImageLoader {
    public static let shared = ImageLoader()

    private let cache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }

    public func loadImage(from url: URL, completion: @escaping (Result<UIImage?, Never>) -> Void) {
        if let image = cache[url] {
            completion(.success(image))
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                let image = UIImage(data: data)
                self.cache[url] = image
                completion(.success(image))
            }
        }.resume()
    }
}


//extension UIImageView {
//    func load(urlStr: String) {
//        guard let url = URL(string: urlStr) else {
//            print("invalid url...")
//            return
//        }
//
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

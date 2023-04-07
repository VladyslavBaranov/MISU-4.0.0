//
//  AsyncImage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

final class _AsyncImageView: UIView {
    
    var isCurrentUser: Bool = false
    
    private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.frame.size = .init(width: 90, height: 90)
        imageView.contentMode = .scaleAspectFill
        alpha = 0
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDidUpdateAvatar(_:)),
            name: NotificationManager.shared.notificationName(for: .didUpdateAvatar),
            object: nil
        )
    }
    
    @objc func onDidUpdateAvatar(_ notification: Notification) {
        if isCurrentUser {
            if let img = notification.object as? UIImage {
                imageView.image = img
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var url: String = "" {
        didSet {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard !url.contains("default.png") else { return }
        if let img = RealmImage.getImage(for: url) {
            if let data = img.data {
                imageView.image = UIImage(data: data)
                alpha = 1
            } else {
                alpha = 0
            }
        } else {
            getImage(from: url) { img in
                if let img = img {
                    DispatchQueue.main.async { [weak self] in
                        if let url = self?.url {
                            if !url.contains("default.png") {
                                self?.imageView.image = img
                                RealmImage.save(img, for: url)
                                self?.alpha = 1
                            }
                        } else {
                            self?.alpha = 0
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.alpha = 0
                    }
                }
            }
        }
    }
    
    private func getImage(from url: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(
            with: URLRequest(url: url)
        ) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let img = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(img)
        }.resume()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self )
    }
}

struct AsyncImage: UIViewRepresentable {
    
    let isCurrentUser: Bool
    let url: String
    
    typealias UIViewType = _AsyncImageView
    
    func makeUIView(context: Context) -> _AsyncImageView {
        let image = _AsyncImageView()
        image.isCurrentUser = isCurrentUser
        image.frame.size = .init(width: 90, height: 90)
        image.contentMode = .scaleAspectFill
        image.url = url
        return image
    }
    
    func updateUIView(_ uiView: _AsyncImageView, context: Context) {
        uiView.url = url
    }
    
}

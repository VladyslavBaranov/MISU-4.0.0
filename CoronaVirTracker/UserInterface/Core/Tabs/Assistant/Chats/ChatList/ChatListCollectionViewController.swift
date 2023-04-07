//
//  ChatListCollectionView.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 29.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

final class ChatListCollectionViewController: UIViewController {
	
	var backButton: UIButton!
    
    var progressView: UIActivityIndicatorView!
	var titleLabel: UILabel!

	var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		let layout = UICollectionViewFlowLayout()
		collectionView = UICollectionView(
			frame: .init(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height - 100),
			collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
		collectionView.dataSource = self
		collectionView.register(ChatListCollectionViewCell.self, forCellWithReuseIdentifier: "id")
		collectionView.contentInset.top = 24
		view.addSubview(collectionView)
		
		setupUI()
        setupChatManager()
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !KeyStore.getBoolValue(for: .didShowChatStart) {
            let controller = UIHostingController(rootView: ChatStartPage())
            controller.modalPresentationStyle = .fullScreen
            controller.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
            present(controller, animated: true)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.center = .init(x: view.bounds.midX, y: 70)
        progressView.center = .init(x: view.bounds.midX - titleLabel.bounds.width / 2 - 20, y: 70)
    }
	
	private func setupUI() {
		backButton = UIButton()
		backButton.frame.size = .init(width: 25, height: 14)
		backButton.center = .init(x: 28.5, y: 70)
		backButton.setImage(UIImage(named: "orange_back"), for: .normal)
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		view.addSubview(backButton)
		
		titleLabel = UILabel()
		titleLabel.text = "Всі чати"
		titleLabel.textAlignment = .center
		titleLabel.font = CustomFonts.createUIInter(weight: .semiBold, size: 16)
		view.addSubview(titleLabel)
		titleLabel.sizeToFit()
		titleLabel.center = .init(x: view.bounds.midX, y: 70)
        
        progressView = UIActivityIndicatorView()
        view.addSubview(progressView)
        progressView.hidesWhenStopped = true
	}
	
	@objc private func back() {
		navigationController?.popViewController(animated: true)
	}
    
    private func setupChatManager() {
        ChatLocalManager.shared.delegate = self
    }
}

extension ChatListCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ChatLocalManager.shared.chats.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ChatListCollectionViewCell
		cell.delegate = self
        cell.indexPath = indexPath
        let chat = ChatLocalManager.shared.chats[indexPath.row]
        cell.setChat(chat)
		return cell
	}
}

extension ChatListCollectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		.init(width: collectionView.bounds.width - 32, height: 90)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		16
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		16
	}
}

extension ChatListCollectionViewController: ChatListCollectionViewCellDelegate {
    func didSelect(_ indexPath: IndexPath) {
        let chat = ChatLocalManager.shared.chats[indexPath.row]
        let controller = UIHostingController(rootView: ChatPage(chat))
		controller.hidesBottomBarWhenPushed = true
		navigationController?.pushViewController(controller, animated: true)
	}
	
	func didTapEdit() {}
	
	func didTapDelete() {}
	
	func didExpand() {}
	
    func didCollapse() {}
}

extension ChatListCollectionViewController: ChatLocalManagerDelegate {
    func willStartLoadingChatList(_ manager: ChatLocalManager) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = "Оновлення..."
            self?.titleLabel.sizeToFit()
            self?.progressView.startAnimating()
        }
    }
    
    func didLoadChatList(_ manager: ChatLocalManager) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = "Всі чати"
            self?.titleLabel.sizeToFit()
            self?.progressView.stopAnimating()
            self?.collectionView.reloadData()
            // self?.collectionView.reloadSections(.init(integer: 0))
        }
    }
}

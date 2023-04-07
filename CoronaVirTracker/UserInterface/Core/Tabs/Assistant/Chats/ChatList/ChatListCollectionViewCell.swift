//
//  ChatCardView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 08.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let chatCardExpanded = "com.chatoptionsexpanded"
}

fileprivate class _ChatSideView: UIView {
    
    fileprivate var editButton: UIButton!
    fileprivate var deleteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // isUserInteractionEnabled = true
        
        editButton = UIButton()
        editButton.tag = 0
        editButton.backgroundColor = UIColor(red: 0.36, green: 0.61, blue: 0.97, alpha: 1)
        editButton.setImage(UIImage(named: "chat-pin"), for: .normal)
        editButton.layer.cornerRadius = 12
        editButton.layer.cornerCurve = .continuous
		// editButton.setTitle("Закріпити", for: .normal)
        addSubview(editButton)
        
        deleteButton = UIButton()
        deleteButton.tag = 1
		deleteButton.backgroundColor = UIColor(red: 1, green: 0.37, blue: 0.37, alpha: 1)
        deleteButton.setImage(UIImage(named: "chat-trash"), for: .normal)
        deleteButton.layer.cornerRadius = 12
        deleteButton.layer.cornerCurve = .continuous
		// deleteButton.setTitle("Видалити", for: .normal)
        addSubview(deleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        editButton.frame = .init(x: 0, y: 0, width: bounds.midX - 8, height: bounds.height)
        deleteButton.frame = .init(x: bounds.midX + 8, y: 0, width: bounds.midX - 8, height: bounds.height)
    }

}

protocol _ChatCardViewDelegate: AnyObject {
    func didExpand()
    func didCollapse()
	func didTap()
}

final class _ChatCardView: UICollectionViewCell {

    var isExpanded = false
    weak var delegate: _ChatCardViewDelegate!
    
    private var dragGesture = UIPanGestureRecognizer()
    
    fileprivate var differenceFromCenter: CGFloat = 0.0
    fileprivate var initialCenter: CGFloat = 0.0
    
    fileprivate var sideView = _ChatSideView()
    
    fileprivate var imageView: UIImageView!
    fileprivate var chatNameLabel: UILabel!
    fileprivate var lastMessageLabel: UILabel!
	fileprivate var timeLabel: UILabel!
	fileprivate var unreadCountLabel: UILabel!
    
    func setupUI() {

        isUserInteractionEnabled = true
        
        imageView = UIImageView(frame: .init(x: 0, y: 0, width: 60, height: 60))
        imageView.layer.cornerRadius = 30
        imageView.image = UIImage(named: "DoctorPhoto")
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        chatNameLabel = UILabel()
        chatNameLabel.text = ""
        chatNameLabel.textAlignment = .left
		chatNameLabel.font = CustomFonts.createUIInter(weight: .bold, size: 16)
        addSubview(chatNameLabel)
        
        lastMessageLabel = UILabel()
        lastMessageLabel.text = ""
        lastMessageLabel.textAlignment = .left
        lastMessageLabel.font = CustomFonts.createUIInter(weight: .regular, size: 14)
		lastMessageLabel.lineBreakMode = .byCharWrapping
		lastMessageLabel.textColor = UIColor(red: 0.41, green: 0.47, blue: 0.6, alpha: 1)
        addSubview(lastMessageLabel)
		
		timeLabel = UILabel()
		timeLabel.text = "12:00"
		timeLabel.font = CustomFonts.createUIInter(weight: .regular, size: 12)
		timeLabel.textAlignment = .right
		timeLabel.textColor = UIColor(red: 0.41, green: 0.47, blue: 0.6, alpha: 1)
		addSubview(timeLabel)
		
		unreadCountLabel = UILabel()
		unreadCountLabel.text = "1"
		unreadCountLabel.font = CustomFonts.createUIInter(weight: .semiBold, size: 12)
		unreadCountLabel.textColor = .white
		unreadCountLabel.backgroundColor = UIColor(red: 0.36, green: 0.61, blue: 0.97, alpha: 1)
		unreadCountLabel.textAlignment = .center
		unreadCountLabel.layer.cornerRadius = 11
		unreadCountLabel.clipsToBounds = true
        unreadCountLabel.isHidden = true
		addSubview(unreadCountLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        dragGesture.addTarget(self, action: #selector(onPanGesture(_:)))
        addGestureRecognizer(dragGesture)

        layer.cornerRadius = 12
        layer.borderWidth = 1
		layer.borderColor = UIColor(red: 0.89, green: 0.94, blue: 1, alpha: 1).cgColor
        
        setupUI()
        
		sideView.frame.size.width = 170
        
        addSubview(sideView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        sideView.frame.origin = .init(x: bounds.width + 16, y: 0)
		sideView.frame.size.height = bounds.height
        
        imageView.center = .init(x: bounds.midY, y: bounds.midY)
        
        chatNameLabel.frame.size = .init(
            width: bounds.width - bounds.height - 100, height: 22)
		chatNameLabel.frame.origin = .init(x: bounds.height, y: 18)
		
		lastMessageLabel.frame = .init(
			x: bounds.height,
			y: bounds.midY - 10,
			width: bounds.width - bounds.height - 100, height: 40)
		
		timeLabel.frame = .init(x: bounds.width - 52, y: 10, width: 40, height: 19)
		unreadCountLabel.frame = .init(x: bounds.width - 38, y: bounds.midY - 11, width: 22, height: 22)
		
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onPanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {

        switch gestureRecognizer.state {
        case .changed:
            let loc = gestureRecognizer.location(in: superview)
            self.center.x = loc.x - differenceFromCenter
            
            let absOffset = abs(initialCenter - self.center.x)
			
			if absOffset > 186 {
				sideView.frame.size.width = absOffset - 16
			} else {
				sideView.frame.size.width = 170
            }
			
        case .ended:
            
            let absOffset = abs(initialCenter - self.center.x)
            let vel = abs(gestureRecognizer.velocity(in: self).x)
            
            if absOffset <= 186 {
                
                if absOffset < 93 {
                    if vel > 50 {
                        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
                            self.center.x = self.initialCenter - 186
                        }
                        // delegate?.didExpand()
                        isExpanded = true
                    } else {
                        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
                            self.center.x = self.initialCenter
                        }
                        // delegate?.didCollapse()
                        isExpanded = false
                    }
                    
                } else {
                    if vel > 93 {
                        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
                            self.center.x = self.initialCenter
                        }
                        // delegate?.didCollapse()
                        isExpanded = false
                    } else {
                        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
                            self.center.x = self.initialCenter - 186
                        }
                        // delegate?.didExpand()
                        isExpanded = true
                    }
                    
                }
            } else {
                UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
                    self.center.x = self.initialCenter - 186
                    self.sideView.frame.size.width = 170
                    self.sideView.layoutSubviews()
                }
                // delegate?.didExpand()
                isExpanded = true
            }
        case .began:
            let loc = gestureRecognizer.location(in: superview)
            differenceFromCenter = loc.x - self.center.x
        default:
            break
        }
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		delegate?.didTap()
	}
}

protocol ChatListCollectionViewCellDelegate: AnyObject {
	func didTapEdit()
	func didTapDelete()
	func didExpand()
	func didCollapse()
    func didSelect(_ indexPath: IndexPath)
}

final class ChatListCollectionViewCell: UICollectionViewCell {
    
    let view: _ChatCardView = _ChatCardView()
    
    var indexPath: IndexPath = .init(index: 0)
	weak var delegate: ChatListCollectionViewCellDelegate!
    private var wasTouched = false
    
    func setChat(_ chat: ChatV2) {
        if let sender = chat.participants.first(where: { $0.id != KeyStore.getIntValue(for: .currentUserId) }) {
            
            if let profile_name = sender.profile_name {
                var splitted = profile_name.split(separator: " ")
                splitted.removeAll { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                view.chatNameLabel.text = splitted.joined(separator: " ")
            }
            
            if let lastMsg = chat.messages.last {
                view.lastMessageLabel.text = lastMsg.text
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                view.timeLabel.text = formatter.string(from: lastMsg.getDate())
            }
            
            if let img = sender.image {
                if !img.contains("Assistant") {
                    let fullImage = "https://misu.pp.ua\(img)"
                    if let img = RealmImage.getImage(for: fullImage) {
                        if let data = img.data {
                            view.imageView.image = UIImage(data: data)
                        }
                    }
                } else {
                    view.imageView.image = UIImage(named: "DoctorPhoto")
                }
            }
            
            let unreadCount = RealmMessage.getUnreadMessagesCount(for: chat)
            view.unreadCountLabel.text = "\(unreadCount)"
            view.unreadCountLabel.isHidden = unreadCount == 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
		view.delegate = self
		backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 1, alpha: 1)
        
        // view.delegate = self
        view.frame.size = bounds.size
        view.initialCenter = frame.width / 2
        addSubview(view)
		
		// view.sideView.editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
		// view.sideView.deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        //NotificationCenter.default.addObserver(
        //    self,
        //    selector: #selector(collapse(_:)),
        //    name: Notification.Name("com.albumCardExpanded"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

		let subP = view.sideView.convert(point, from: self)
		
		if let subView = view.sideView.hitTest(subP, with: event) {
			switch subView.tag {
			case 0:
				if !wasTouched {
					delegate?.didTapEdit()
					wasTouched = true
				} else {
					wasTouched = false
				}
			case 1:
				if !wasTouched {
					delegate?.didTapDelete()
					wasTouched = true
				} else {
					wasTouched = false
				}
			default:
				break
			}
		}
		
		return super.hitTest(point, with: event)
	}
	
}

extension ChatListCollectionViewCell: _ChatCardViewDelegate {
	func didExpand() {
		
	}
	
	func didCollapse() {
		
	}
	
	func didTap() {
		delegate?.didSelect(indexPath)
	}
}

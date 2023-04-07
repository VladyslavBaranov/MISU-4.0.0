//
//  ValidationResponse.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 10.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import Foundation

struct ValidationResponse {
    struct LatestReceiptInfo {
        var is_trial_period: Bool = false
        var expires_date: Date = .init()
        var product_id: String = ""
    }
    struct PendingRenewalInfo {
        var auto_renew_status: Int = 0
        var product_id: String = ""
    }
    struct Receipt {
        var request_date: Date
    }
    
    var latest_receipt_info: [LatestReceiptInfo] = []
    var pending_renewal_info: [PendingRenewalInfo] = []
    var receipt: Receipt = .init(request_date: Date())
    var status: Int = 0
    
    init(_ dictionary: NSDictionary) {
        if let latestReceiptObj = dictionary["latest_receipt_info"] as? NSArray {
            if let firstAndLast = latestReceiptObj.firstObject as? NSDictionary {
                var info = LatestReceiptInfo()
                if let isTrial = firstAndLast["is_trial_period"] as? Bool {
                    info.is_trial_period = isTrial
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                if let expiresDate = firstAndLast["expires_date"] as? String {
                    info.expires_date = formatter.date(from: expiresDate) ?? .init()
                }
                if let productid = firstAndLast["product_id"] as? String {
                    info.product_id = productid
                }
                latest_receipt_info.append(info)
            }
        }
        
        if let pendingInfo = dictionary["latest_receipt_info"] as? NSArray {
            if let firstAndLast = pendingInfo.firstObject as? NSDictionary {
                var info = PendingRenewalInfo()
                if let renew_status = firstAndLast["auto_renew_status"] as? Int {
                    info.auto_renew_status = renew_status
                }
                if let productid = firstAndLast["product_id"] as? String {
                    info.product_id = productid
                }
                pending_renewal_info.append(info)
            }
        }
        
        if let receipt = dictionary["receipt"] as? NSDictionary {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            if let expiresDate = receipt["expires_date"] as? String {
                let date = formatter.date(from: expiresDate) ?? .init()
                self.receipt = .init(request_date: date)
            }
        }
        if let status = dictionary["status"] as? Int {
            self.status = status
        }
    }
    
    func isReqDateLessThanExpiry() -> Bool {
        let reqDate = receipt.request_date
        guard let exp = latest_receipt_info.first?.expires_date else { return false }
        return reqDate < exp
    }
}

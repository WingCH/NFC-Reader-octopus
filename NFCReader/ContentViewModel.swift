//
//  ContentViewModel.swift
//  NFCReader
//
//  Created by WingCH on 3/10/2021.
//

import Foundation
import TRETJapanNFCReader
import SwiftUI

class ContentViewModel: NSObject, ObservableObject {
    
    var reader: OctopusReader?
    @Published var balance: String? = nil
    
    override init() {
        super.init()
        // TRETJapanNFCReader have some presets languages
        kJapanNFCReaderLocalizedLanguage = .zhHK
        
        self.reader = OctopusReader(delegate: self)
    }
    
    func scan() {
        print("onclick")
        self.reader?.get(itemTypes: OctopusCardItemType.allCases)
    }
}

extension ContentViewModel: FeliCaReaderSessionDelegate {
    
    func feliCaReaderSession(didRead feliCaCardData: FeliCaCardData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        if let octopus = feliCaCardData as? OctopusCardData,
           let rawBalance: Int =  octopus.balance {
            
            // https://www.octopus.com.hk/en/consumer/customer-service/faq/get-your-octopus/about-octopus.html#3532
            // Octopus issued on or after 1 October 2017 offset is $50
            // else offset is $35
            let offet:Double = 35.0;
            
            // real balance = (rawBalance / 10) - offset
            let realBalance: Double = (Double(rawBalance) / 10) - offet
            
            // display balance as currency, e.g: HK$185.50
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = Locale.current
            
            if let balancString = currencyFormatter.string(from: NSNumber(value: realBalance)) {
                DispatchQueue.main.async {
                    self.balance = balancString
                }
            }
        }
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        //        print(#function, error)
    }
    
    func feliCaReaderSession(didInvalidateWithError pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        //        print(#function, pollingErrors)
    }
}

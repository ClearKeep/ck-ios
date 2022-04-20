//
//  CKPreKey.swift
//  ClearKeep
//
//  Created by Luan Nguyen on 10/29/20.
//

import Foundation
import SignalProtocolObjC

class CKPreKey {
    let preKeyId: UInt32
    let publicKey: Data
    
    init(withPreKeyId preKeyId: UInt32, publicKey: Data) {
        self.preKeyId = preKeyId
        self.publicKey = publicKey
    }
}

extension CKPreKey {
    static func preKeysFromSignal(_ preKeys: [SignalPreKey]) -> [CKPreKey] {
        var omemoPreKeys: [CKPreKey] = []
        preKeys.forEach { (signalPreKey) in
            guard let publicKey = signalPreKey.keyPair?.publicKey else { return }
            let omemoPreKey = CKPreKey(withPreKeyId: signalPreKey.preKeyId, publicKey: publicKey)
            omemoPreKeys.append(omemoPreKey)
        }
        return omemoPreKeys
    }
}

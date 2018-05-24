//
//  MD5.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 4/19/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import Foundation

/// in Bridging-Header.h need
/// #import <CommonCrypto/CommonCrypto.h>
final class MD5 {
    
    lazy var hex = hash.map { String(format: "%02x", $0) }.joined()
    lazy var base64 = Data(bytes: hash).base64EncodedString()
    
    private let hash: [UInt8]
    
    init(data: Data) {
        self.hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes, CC_LONG(data.count), &hash)
            return hash
        }
    }
    
    convenience init?(string: String?) {
        guard let data = string?.data(using: .utf8) else {
            return nil
        }
        self.init(data: data)
    }
}
extension MD5 {
    static func from(_ string: String) -> String? {
        return MD5(string: string)?.hex.uppercased()
    }
}

extension String {
    var md5: String? {
        return MD5(string: self)?.hex.uppercased()
    }
}

/// https://gist.github.com/khanlou/baf60dd62601b879eeba209943b04973
//extension String {
//    var md5: String? {
//        guard let data = self.data(using: String.Encoding.utf8) else {
//            return nil
//        }
//        
//        let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
//            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//            CC_MD5(bytes, CC_LONG(data.count), &hash)
//            return hash
//        }
//        
//        return hash.map { String(format: "%02x", $0) }.joined()
//    }
//}

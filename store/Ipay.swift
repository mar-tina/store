//
//  Ipay.swift
//  store
//
//  Created by martina khaemba on 26/07/2022.
//

import Foundation;
import CommonCrypto

public class Ipay {
    public var baseURL: String
    
    public var key: String
    public var parameters: [String: String] = [:]
    private var queryItems = [URLQueryItem]()
 
    public func setParam(key: String, value: String) {
        parameters[key] = value
        print(parameters);
    }

    
    public func buildDatastr() -> String {
        let live = parameters["live"]
        let oid = parameters["oid"]
        let inv = parameters["inv"]
        let ttl = parameters["ttl"]
        let tel = parameters["tel"]
        let eml = parameters["eml"]
        let vid = parameters["vid"]
        let curr = parameters["curr"]
        let p1 = parameters["p1"]
        let p2 = parameters["p2"]
        let p3 = parameters["p3"]
        let p4 = parameters["p4"]
        let cbk = parameters["cbk"]
        let cst = parameters["cst"]
        let crl = parameters["crl"]
        
        let datastr = "\(live ?? "0")\(oid ?? "")\(inv ?? "")\(ttl ?? "")\(tel ?? "")\(eml ?? "")\(vid ?? "")\(curr ?? "")\(p1 ?? "")\(p2 ?? "")\(p3 ?? "")\(p4 ?? "")\(cbk ?? "")\(cst ?? "")\(crl ?? "")"

        return datastr;
    }
    
    public func buildUrl() -> URL {
        var components = URLComponents(string: baseURL)!
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    public func complete() {
        let datastr = buildDatastr()
        let hash = datastr.hmac(algorithm: HMACAlgorithm.SHA1 , key: key)
        parameters["hsh"] = hash
        print("hashLength", hash.count)
        print(buildUrl())
    }
    
    public init(key: String, baseURL: String) {
        self.key = key
        self.baseURL = baseURL
    }
}

enum HMACAlgorithm {
    case SHA1

    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        return CCHmacAlgorithm(kCCHmacAlgSHA1)
    }

    func digestLength() -> Int32 {
        return CC_SHA1_DIGEST_LENGTH
    }
}

extension String {
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        var bytes = [UInt8](repeating: 0, count: hmacData.length)
        hmacData.getBytes(&bytes, length: hmacData.length)
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02hhx", UInt8(byte))
        }
        
        return hexString
    }
}

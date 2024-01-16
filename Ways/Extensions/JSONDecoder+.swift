//
//  JSONDecoder+.swift
//  Ways
//
//  Created by Leon on 2024/1/16.
//

import Foundation

extension JSONDecoder {
    public static let decoderWithStrategy = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yearMonthDay)
        return decoder
    }()
}

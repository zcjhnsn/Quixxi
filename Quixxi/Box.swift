//
//  Box.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/26/24.
//

import Foundation

enum Status {
    case crossed
    case disabled
    case normal
}

struct Box: Equatable {
    var status: Status = .normal
    
    var isDisabled: Bool {
        status == .disabled
    }
    
    var isCrossed: Bool {
        status == .crossed
    }
    
    var isNormal: Bool {
        status == .normal
    }
}

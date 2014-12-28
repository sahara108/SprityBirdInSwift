//
//  Constants.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import Foundation

struct Constants {
    static let BACK_BIT_MASK: UInt32 = 0x1 << 0;
    static let BIRD_BIT_MASK: UInt32 = 0x1 << 1;
    static let FLOOR_BIT_MASK: UInt32 = 0x1 << 2;
    static let BLOCK_BIT_MASK: UInt32 = 0x1 << 3;
}

enum GameState: Int {
    case Waiting = 0
    case Playing
    case Over
}

let GADAdmobUnitId = "ca-app-pub-9164163399397953/2805068620"

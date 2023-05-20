//
//  Platform.swift
//  
//
//  Created by Leonardo Lobato on 11/04/23.
//

import Foundation

public enum Platform: Int {
    case megaDrive = 1
    case masterSystem = 2
    case nes = 3
    case snes = 4
    case gameboy = 9
    case gameboyColor = 10
    case gameboyAdvance = 12
    case sega32x = 19
    case megaCd = 20
    case gameGear = 21
    case neoGeoPocket = 25
    case neoGeoPocketColor = 82
    case atari2600 = 26
    case atariLynx = 28
    case pcengine = 31
    case wonderSwanColor = 46
    case supergrafx = 105
    case pcengineCd = 114
    case neoGeo = 142
    case msx = 113
    case dos = 135
    case playstation = 57
    case scummVm = 123

    public func extensions() -> [String] {
        switch self {
        case .atari2600: return ["a26","bin","rom"]
        case .megaDrive: return ["gen","md","smd","bin","sg"]
        case .masterSystem: return ["sms","bin"]
        case .nes: return ["nes","fds","fig","bin","unf"]
        case .snes: return ["sfc","smc","fig","mgd","swc"]
        case .gameboy: return ["gb","bin"]
        case .gameboyColor: return ["gb","gbc","bin"]
        case .gameboyAdvance: return ["gba","bin"]
        case .sega32x: return ["32x","smd","md","bin","ccd","cue","img","iso","sub","wav"]
        case .megaCd: return ["bin","ccd","chd","cue","img","iso","sub","wav"]
        case .gameGear: return ["gg","sms","bin"]
        case .neoGeoPocket: return ["ngp","ngc","bin"]
        case .neoGeoPocketColor: return ["ngp","ngc","bin"]
        case .atariLynx: return ["bin","lnx"]
        case .pcengine: return ["pce","sgx"]
        case .wonderSwanColor: return ["ws","wsc","bin"]
        case .supergrafx: return ["pce","cue","ccd","sgx"]
        case .pcengineCd: return ["pce","cue","ccd","chd","iso","sgx"]
        case .neoGeo: return ["chd"]
        case .msx: return ["mx1","rom","dsk","col","cas"]
        case .playstation: return ["iso","bin","ccd","cue","pbp","cbn","img","mdf","m3u","toc","znx","chd"]
        case .dos: return ["bas","bin","com","dat","dsk","exe","game","gog","ima","img","iso","mdf","wad","z5","z8","zip"] // "extensions": "pc(exe|com|iso|bin|mdf|ima|img|gog|dsk|z5|z8|bas|dat),dos(exe|com|iso|bin|mdf|ima|img|gog|dsk|z5|z8|bas|dat),wad,game,zip",
        case .scummVm: return [] // ["svm","scummvm"]
        }
    }

    public func romType() -> RomType {
        switch self {
        case .atari2600,
                .megaDrive,
                .masterSystem,
                .nes,
                .snes,
                .gameboy,
                .gameboyColor,
                .gameboyAdvance,
                .gameGear,
                .neoGeoPocket,
                .neoGeoPocketColor,
                .atariLynx,
                .pcengine,
                .wonderSwanColor,
                .neoGeo:
            return .rom

        case .sega32x, .megaCd, .supergrafx, .pcengineCd, .playstation:
            return .iso

        case .msx, .dos, .scummVm:
            return .folder

        }
    }
}

public enum RomType: String {
    case folder = "dossier"
    case file = "fichier"
    case iso = "iso"
    case rom = "rom"
}

//
//  Region.swift
//  
//
//  Created by Leonardo Lobato on 12/04/23.
//
/*
 "dateTime": "2023-04-12 22:22:40",
 "commandRequested": "https://neoclone.screenscraper.fr/api2/regionsListe.php?devid=xxx&devpassword=yyy&softname=zzz&output=json&ssid=test&sspassword=test",
 */

import Foundation

public enum Region: String, Codable, CaseIterable {
    case wor
    case eu
    case us
    case uk
    case de
    case jp
    case br
    case fr
    case cn
    case kr
    case au
    case tw
    case asi
    case se
    case it
    case ca
    case sp
    case ru
    case nl
    case dk
    case fi
    case ame
    case pl
    case cus
    case pt
    case cz
    case hu
    case cl
    case sk
    case oce
    case nz
    case mor
    case il
    case pe
    case tr
    case kw
    case no
    case bg
    case gr
    case ss
    case ae
    case za
    case mex
    case afr
}

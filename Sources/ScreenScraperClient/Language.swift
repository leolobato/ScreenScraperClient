//
//  Language.swift
//  
//
//  Created by Leonardo Lobato on 15/04/23.
//
/*
 "dateTime": "2023-04-15 17:29:27",
 "commandRequested": "https://neoclone.screenscraper.fr/api2/languesListe.php?devid=xxx&devpassword=yyy&softname=zzz&output=json&ssid=test&sspassword=test",
 */
import Foundation

public enum Language: String, Codable {
    case en
    case fr
    case de
    case es
    case it
    case ja
    case sv
    case pt
    case nl
    case no
    case fi
    case ko
    case pl
    case zh
    case ru
    case tr
    case cz
    case sk
    case hu
    case da
}

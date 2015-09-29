//
//  Country.swift
//  
//
//  Created by Remi Robert on 26/07/15.
//
//

import UIKit

class SmileyCountry {

    class func smileyForCountryCodeISO(code: String) -> String {
        switch code {
        case "CN": return "🇨🇳"
        case "DE": return "🇩🇪"
        case "FR": return "🇫🇷"
        case "ES": return "🇪🇸"
        case "CA": return "🇨🇦"
        case "BE": return "🇧🇪"
        case "BR": return "🇧🇷"
        case "EN": return "🇬🇧"
        case "IT": return "🇮🇹"
        case "US": return "🇺🇸"
        case "JP": return "🇯🇵"
        case "VN": return "🇻🇳"
        case "MX": return "🇲🇽"
        case "FI": return "🇫🇮"
        case "SE": return "🇸🇪"
        case "IN": return "🇮🇳"
        case "PT": return "🇵🇹"
        case "CH": return "🇨🇭"
        case "KP": return "🇰🇷"
        case "KR": return "🇰🇷"
        case "AU": return "🇦🇺"
        case "IE": return "🇮🇪"
        default: return ""
        }
    }
}

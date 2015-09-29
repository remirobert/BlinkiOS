//
//  Colors.swift
//  Sneak
//
//  Created by Remi Robert on 21/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class Colors: NSObject {
    
    class func colorAndFaceFromColor(color: UIColor) -> (face: UIImage, secondColor: UIColor) {
        let colors = [UIColor(red:0.95, green:0.65, blue:0.21, alpha:1),
            UIColor(red:0.97, green:0.9, blue:0.23, alpha:1),
            UIColor(red:0.99, green:0.09, blue:0.51, alpha:1),
            UIColor(red:0.95, green:0.58, blue:0.76, alpha:1),
            UIColor(red:0.1, green:0.66, blue:0.52, alpha:1),
            UIColor(red:0.35, green:0.89, blue:0.76, alpha:1),
            UIColor(red:0.31, green:0.57, blue:0.87, alpha:1),
            UIColor(red:0.59, green:0.78, blue:0.99, alpha:1)]
        
        var indexRow = 0
        for var index = 0; index < colors.count; index++ {
            if color == colors[index] {
                indexRow = index
                break
            }
        }
        return (Colors.faceColorForRow(indexRow), Colors.secondColorForRow(indexRow))
    }
    
    class func faceColorForRow(row: Int) -> UIImage {
        if (row < 8) {
            return UIImage(named: "face\(row)")!
        }
        return UIImage(named: "face\(row % 8)")!
    }
    
    class func secondColorForRow(row: Int) -> UIColor {
        let colors = [UIColor(red:0.97, green:0.9, blue:0.23, alpha:1),
            UIColor(red:0.95, green:0.65, blue:0.21, alpha:1),
            UIColor(red:0.95, green:0.58, blue:0.76, alpha:1),
            UIColor(red:0.99, green:0.09, blue:0.51, alpha:1),
            UIColor(red:0.35, green:0.89, blue:0.76, alpha:1),
            UIColor(red:0.1, green:0.66, blue:0.52, alpha:1),
            UIColor(red:0.59, green:0.78, blue:0.99, alpha:1),
            UIColor(red:0.31, green:0.57, blue:0.87, alpha:1)]
        
        if (row < 8) {
            return colors[row]
        }
        return colors[row % 8]
    }
    
    class func colorForRow(row: Int) -> UIColor {
        let colors = [UIColor(red:0.95, green:0.65, blue:0.21, alpha:1),
            UIColor(red:0.97, green:0.9, blue:0.23, alpha:1),
            UIColor(red:0.99, green:0.09, blue:0.51, alpha:1),
            UIColor(red:0.95, green:0.58, blue:0.76, alpha:1),
            UIColor(red:0.1, green:0.66, blue:0.52, alpha:1),
            UIColor(red:0.35, green:0.89, blue:0.76, alpha:1),
            UIColor(red:0.31, green:0.57, blue:0.87, alpha:1),
            UIColor(red:0.59, green:0.78, blue:0.99, alpha:1)]

        if (row < 8) {
            return colors[row]
        }
        return colors[row % 8]
    }
    
}

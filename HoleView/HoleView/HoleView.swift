//
//  HoleView.swift
//  HoleView
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

class HoleView: UIView {
    
    lazy var imageBackground: UIImageView! = {
        let image = UIImageView()
        image.contentMode = UIViewContentMode.ScaleAspectFit
        image.image = UIImage(named: "B49E1549-2A84-477D-9D49-24B453B47409")
        return image
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageBackground)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

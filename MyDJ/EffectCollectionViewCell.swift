//
//  EffectCollectionViewCell.swift
//  MyDJ
//
//  Created by Rene Candelier on 4/4/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit

class EffectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var effectTitle: UILabel!
    
    var currentColor = UIColor.white
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        currentColor = colorView.backgroundColor ?? UIColor.white
        colorView.backgroundColor = UIColor.white
        UIView.animate(withDuration: 0.5) {
            self.colorView.backgroundColor = self.currentColor
        }
    }
}

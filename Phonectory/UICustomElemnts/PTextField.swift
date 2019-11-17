//
//  PTextField.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 08/11/2019.
//  Copyright © 2019 DM. All rights reserved.
//

import Foundation
import UIKit

class PTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        innerInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        innerInit()
    }

    private func innerInit() {
        backgroundColor = .white
        font = PStyle.baseFont(size: 16, weight: .regular)
        textColor = PStyle.darkGray
    }
}

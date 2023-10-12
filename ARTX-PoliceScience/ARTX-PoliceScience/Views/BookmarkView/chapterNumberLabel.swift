//
//  chapterNumberLabel.swift
//  ARTX-PoliceScience
//
//  Created by apple on 10/12/23.
//

import UIKit

class chapterNumberLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureLabel() {
        self.textAlignment = .left
        self.font = .caption2Bold
        self.textColor = .textBlue
    }
    
    func updateText(to number: String) {
        self.text = "CHAPTER " + String(format: "02d", number)
    }
}

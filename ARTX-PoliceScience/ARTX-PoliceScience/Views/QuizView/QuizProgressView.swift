//
//  QuizProgressView.swift
//  ARTX-PoliceScience
//
//  Created by yusang on 10/14/23.
//

import Foundation
import UIKit

class QuizProgressView: UIView {

    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trackTintColor = .white
        view.progressTintColor = UIColor(resource: .barPoint)
        view.transform = CGAffineTransformScale(view.transform, 1, 0.2)
        view.progress = 0.0
        view.setProgress(0.3, animated: true)
        return view
    }()

    let progressNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " 0/30"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        //assets에 alpha값 고려한거 추가하면 고칠게요...
        label.textColor = UIColor(hex: "#000000", alpha: 0.6)
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "heart.fill"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var progressStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .center
        return view
    }()
    
}

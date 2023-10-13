//
//  BookmarkViewHeader.swift
//  ARTX-PoliceScience
//
//  Created by apple on 10/13/23.
//

import UIKit

class BookmarkViewHeader: UITableViewHeaderFooterView {
    
    static let identifier = "BookmarkViewHeader"
    
    private var partNumberLabel = PartNumberLabel()
    private var partTitleLabel = PartTitleLabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.configureBookmarkViewHeader()
        self.layoutBookmarkViewHeader()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func update(bookmarkViewModel: BookmarkViewModel) {
        self.partNumberLabel.updateText(to: bookmarkViewModel.getChapterNumber())
        self.partTitleLabel.updateText(to: bookmarkViewModel.getChapterTitle())
    }
    
    private func configureBookmarkViewHeader() {
        self.contentView.backgroundColor = .clear
        [
            self.partNumberLabel,
            self.partTitleLabel,
        ].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func layoutBookmarkViewHeader() {
        partNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        partTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            partNumberLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            partNumberLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),

            partTitleLabel.topAnchor.constraint(equalTo: self.partNumberLabel.topAnchor, constant: 8),
            partTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0)
        ])
    }
}

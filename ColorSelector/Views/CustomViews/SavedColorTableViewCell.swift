//
//  SavedColorTableViewCell.swift
//  ColorSelector
//
//  Created by Wass on 18/09/2023.
//

import UIKit

class SavedColorTableViewCell: UITableViewCell {
    
    let hexLabel: UILabel = {
        let label = UILabel()
        label.text = "Color"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let colorCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.lightGray.cgColor  
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    func colorCircleView() {
        colorCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        colorCircle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorCircle.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorCircle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
    }
    
    func hexLabelView() {
        hexLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        hexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        hexLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(colorCircle)
        contentView.addSubview(hexLabel)
        colorCircleView()
        hexLabelView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(hexLabelText: String, color: UIColor) {
        colorCircle.backgroundColor = color
        hexLabel.text = hexLabelText
    }
    
}

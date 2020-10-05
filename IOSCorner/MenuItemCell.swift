//
//  MenuItemCell.swift
//  IOSCorner
//
//  Created by Andrey on 23.09.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

protocol MenuItemCellDelegate {
    func saveItem(by: Menu)
}

class MenuItemCell: UITableViewCell {
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var itemView: UIView!
    @IBOutlet var addInBusket: UIButton!
    @IBOutlet var rightSideView: UIView!
    
    var item: Menu?
    var delegate: MenuItemCellDelegate?
    
    static let reuseID = String(describing: MenuItemCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        itemView.layer.cornerRadius = 10
        itemView.clipsToBounds = true
        itemImage.contentMode = .scaleAspectFill
        backgroundColor = .clear
        selectionStyle = .none
        
    }
    
    func setup(model: Menu) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        priceLabel.text = String(model.price) + "$"
        if model.image != nil {
            itemImage.load(url: model.image!)
        } else {
            itemImage.image = UIImage(data: model.imageData ?? Data())
        }
        self.item = model
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        itemImage.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buyItem(_ sender: Any) {
        guard let item = item, let delegate = delegate else {
            return
        }
        delegate.saveItem(by: item)
    }
}

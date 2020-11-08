//
//  MenuItemCell.swift
//  IOSCorner
//
//  Created by Andrey on 23.09.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

protocol MenuItemCellDelegate {
    func saveItem(by: Menu, count: Int)
    func setNewCount(by: Menu)
}

class MenuItemCell: UITableViewCell {
    
    var count: Int = 1 {
        didSet {
            countLabel.text = String(count)
        }
    }
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var itemView: UIView!
    @IBOutlet var addInBusket: UIButton!
    @IBOutlet var rightSideView: UIView!
    @IBOutlet var countStack: UIStackView!
    @IBOutlet var countLabel: UILabel!
    
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
    
    func setup(model: Menu, count: Int? = nil) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        priceLabel.text = String(model.price) + "$"
        countLabel.text = count == nil ? "" : String(count!)
        self.count = count == nil ? 1 : count!
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
        delegate.saveItem(by: item, count: count)
        delegate.setNewCount(by: item)
    }
    @IBAction func minusCount(_ sender: Any) {
        guard let item = item, count > 1 else {return}
        count -= 1
        CoreDataManager.shared.setNewCount(count: count, menu: item)
    }
    @IBAction func plusCount(_ sender: Any) {
        guard let item = item else {return}
        count += 1
        CoreDataManager.shared.setNewCount(count: count, menu: item)
    }
}

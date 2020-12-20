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
    func didChangePrice(cell: MenuItemCell, newCount: Int)
}

extension MenuItemCellDelegate {
    func saveItem(by: Menu, count: Int) {}
    func setNewCount(by: Menu) {}
    func didChangePrice(cell: MenuItemCell, newCount: Int) {}
}

/// This class is created for the setting the menu cell.
class MenuItemCell: UITableViewCell {
    
    var count: Int = 1 {
        didSet {
            countLabel.text = String(count)
        }
    }
    
    /** This is IBOutlet for item image button*/
    @IBOutlet var itemImage: UIImageView!
    /** This is IBOutlet for name of food*/
    @IBOutlet var nameLabel: UILabel!
    /** This is IBOutlet for food description*/
    @IBOutlet var descriptionLabel: UILabel!
    /** This is IBOutlet for price of food*/
    @IBOutlet var priceLabel: UILabel!
    /** This is IBOutlet for View*/
    @IBOutlet var itemView: UIView!
    /** This is IBOutlet for ADD button*/
    @IBOutlet var addInBusket: UIButton!
    /** This is IBOutlet for right side view slide*/
    @IBOutlet var rightSideView: UIView!
    /** This is IBOutlet for count stack*/
    @IBOutlet var countStack: UIStackView!
    /** This is IBOutlet for count label*/
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
    
    /**
     Call this function for setup the cell.
     - Parameters:
        - model : This is menu model
        - count: This is count
     */
    func setup(model: Menu, count: Int? = nil) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        priceLabel.text = String(model.price * (count ?? 1)) + "$"
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
    
    /** Call this function when pressed buy button on the cell*/
    @IBAction func buyItem(_ sender: Any) {
        guard let item = item, let delegate = delegate else {
            return
        }
        delegate.saveItem(by: item, count: count)
        delegate.setNewCount(by: item)
    }
    
    /** Call this function when pressed "-" button*/
    @IBAction func minusCount(_ sender: Any) {
        guard let item = item, count > 1 else {return}
        count -= 1
        CoreDataManager.shared.setNewCount(count: count, menu: item)
        priceLabel.text = String(item.price * count) + "$"
        delegate?.didChangePrice(cell: self, newCount: count)
    }
    
    /** Call this function when pressed "+" button*/
    @IBAction func plusCount(_ sender: Any) {
        guard let item = item else {return}
        count += 1
        CoreDataManager.shared.setNewCount(count: count, menu: item)
        priceLabel.text = String(item.price * count) + "$"
        delegate?.didChangePrice(cell: self, newCount: count)
    }
}

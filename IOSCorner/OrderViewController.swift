//
//  OrderViewController.swift
//  IOSCorner
//
//  Created by Andrey on 25.09.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var totalPrice: UILabel!
    
    var orders = [(Menu, Int)]() {
        didSet {
            tableView.reloadData()
            var sum = 0
            for order in orders {
                sum += order.0.price
            }
            totalPrice.text = "Total: \(sum)$"
        }
    }
    
    var id = 00
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1, green: 0.7496221662, blue: 0, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: MenuItemCell.reuseID, bundle: nil), forCellReuseIdentifier: MenuItemCell.reuseID)
        
        buyButton.layer.cornerRadius = 10
        buyButton.clipsToBounds = true
        
        CoreDataManager.shared.getOrders { orders in
            
            self.orders = orders
            
        }
        
        if let id = UserDefaults.standard.value(forKey: "id") as? Int {
            self.id = id
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Order"
    }
    
    
    @IBAction func buyAction(_ sender: Any) {
        
        let alertController = UIAlertController(
            title: "Pay for the order",
            message: "Please enter your name",
            preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Order it!", style: .default, handler: { action in
            guard let name = alertController.textFields?[0].text else { return }
            
            for order in self.orders {
                NetworkManager.shared.order(order.0, name: name, id: String(self.id), count: order.1)
            }
            self.orders.removeAll()
            CoreDataManager.shared.removeAll()
            self.id += 1
            UserDefaults.standard.set(self.id, forKey: "id")
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
        
        
    }
    
    @IBAction func backToMenuAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseID, for: indexPath) as! MenuItemCell
        
        cell.addInBusket.isHidden = true
        cell.setup(model: orders[indexPath.row].0, count: orders[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = orders[indexPath.row]
            CoreDataManager.shared.removeOrder(item: model.0)
            orders.remove(at: indexPath.row)
        }
    }
    
}

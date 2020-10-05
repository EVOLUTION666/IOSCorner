import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet var busketBarButton: UIBarButtonItem!
    
    var items: [Menu] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.7496221662, blue: 0, alpha: 1)
        tableView.register(UINib(nibName: MenuItemCell.reuseID, bundle: nil), forCellReuseIdentifier: MenuItemCell.reuseID)
        tableView.separatorStyle = .none
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "EatCorner"
//        let image = UIImage(named: "basket")?.withRenderingMode(.alwaysOriginal)
//        busketBarButton.setBackgroundImage(image, for: .normal, barMetrics: .default)
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            print("Fetch")
            self.fetchData()
        }.fire()
    }
    
    func fetchData() {
        let url = URL(string: "http://localhost:8080/menu/get")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            
            if let eats = try? decoder.decode([Menu].self, from: data) {
                DispatchQueue.main.async {
                    self.items = eats
                    self.tableView.reloadData()
                    print("Loaded \(eats.count) positions.")
                }
            } else {
                print("Unable to parse JSON response.")
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseID, for: indexPath) as! MenuItemCell
        let item = items[indexPath.row]
        
        cell.setup(model: item)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    @IBAction func busketAction(_ sender: Any) {
        
    }
}

extension ViewController: MenuItemCellDelegate {
    func saveItem(by: Menu) {

        CoreDataManager.shared.saveOrder(item: by)
        
    }
    
}

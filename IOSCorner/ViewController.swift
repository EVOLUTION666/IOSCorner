import UIKit

//class SecondVC: UIViewController {
//    var items: [Menu] = []
//
//
//    @IBOutlet var tableView: UITableView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell1")
//    }
//
//    func fetchData() {
//        let url = URL(string: "http://localhost:8080/menu/get")!
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            do {
//                guard let data = data else {return}
//                let decoder = JSONDecoder()
//                let result = try decoder.decode([Menu].self, from: data)
//                self.items = result
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            } catch {
//
//            }
//        }.resume()
//    }
//
//}
//
//extension SecondVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
//        cell.textLabel?.text = items[indexPath.row].name
//        return cell
//    }
//}


class ViewController: UITableViewController {

    var items: [Menu] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = "\(item.name) - $\(item.price)"
        
        cell.detailTextLabel?.text = item.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


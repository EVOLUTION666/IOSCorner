import Foundation

// MARK: - NetworkManager

/// This class makes requests to the server and also handles incoming requests.
class NetworkManager {
    
    
    static let shared = NetworkManager()
    
    func fetchData(completion: @escaping ([Menu]) -> ())  {
        guard let url = URL(string: "http://localhost:8080/menu/get") else {
            print("Error URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            
            if let eats = try? decoder.decode([Menu].self, from: data) {
                completion(eats)
            } else {
                print("Unable to parse JSON response.")
            }
        }.resume()
    }
    
    /** Call this function for the download image*/
    func downloadImage(url: URL, completion: @escaping (Data) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            completion(data)
            
        }.resume()
    }
    
    /**
    Call this function to send the user's order to the server
    - Parameters:
       - eat : This is order model
       - name: This is name of user
       - id: This is order ID
       - count: This is count
    */
    func order(_ eat: Menu, name: String, id: String, count: Int) {
        let order = OrderItem(positionName: eat.name, buyerName: name, idOrder: id, count: String(count))
        let url = URL(string: "http://localhost:8080/order")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(order)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                if let item = try? decoder.decode(OrderItem.self, from: data) {
                    print(item.buyerName)
                } else {
                    print("Bad JSON received back.")
                }
            }
        }.resume()
    }
    
    
}

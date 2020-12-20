import Foundation

/// Structure for OrderItem model.
struct OrderItem: Codable {
    var positionName: String
    var buyerName: String
    var idOrder: String
    var count: String
}

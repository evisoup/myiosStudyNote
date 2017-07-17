

/// Swift 4 & Xcode 3 study note
import UIKit

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

/* JSON parsing for uwparking 2.0 */

import UIKit

struct UWParkingRequest: Codable {
    
    struct UWParkingData: Codable {
        let lotName: String
        let capacity: Int
        let currentCount: Int
        let percentFilled: Int
        let latitude: Double
        let longitude: Double
        let lastUpdated: String
        
        private enum CodingKeys : String, CodingKey {
            case lotName = "lot_name"
            case capacity
            case currentCount = "current_count"
            case percentFilled = "percent_filled"
            case latitude
            case longitude
            case lastUpdated = "last_updated"
        }
    }
    
    struct UWParkingMeta: Codable {
        let requests: Int
        let timestamp: Int
        let status: Int
        /// to-do: add coding keys maybe?
    }
    
    let meta: UWParkingMeta
    let data: [UWParkingData]
}

struct UWAPIcall {
    static func getURL() -> URL {
        let urlString = "https://api.uwaterloo.ca/v2/parking/watpark.json?key=95e206951aff0f6b6093b0a340c3185f"
        let url = URL(string: urlString)
        return url!
    }
}

func run1() {
    URLSession.shared.dataTask(with: UWAPIcall.getURL()) { (data, response, err) in
        
        guard let data = data else { return }
        
        do {
            let parkingLotsRequest = try JSONDecoder().decode(UWParkingRequest.self, from: data)
            //gold right here
            print(parkingLotsRequest.data[0].lotName)
            
        } catch let jsonParsingErr {
            print("parsing error: \(jsonParsingErr)")
        }
        }.resume()
}


////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

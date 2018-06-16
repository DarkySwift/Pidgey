import XCTest
@testable import Pidgey

final class PidgeyTests: XCTestCase {
    
    static var allTests = [
        ("testRequest", testRequest),
    ]
    
    func testRequest() {
        
        struct ProductResponse: Decodable {
            
        }
        
        struct ProductRequest: Requestable {
            
            typealias Response = ProductResponse
            
            var url: URL { return URL(string: "www.google.com")! }
            
            var id: Int
        }
        
        let request = ProductRequest(id: 10)
        SessionManager.default.request(request) { (result) in
            
        }
    }
}

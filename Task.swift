import Foundation
import UIKit
import CoreLocation

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted: Bool = false
    var attachedPhoto: UIImage? = nil
    var photoLocation: CLLocationCoordinate2D? = nil
}

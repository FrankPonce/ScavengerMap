import SwiftUI
import PhotosUI
import CoreLocation
import ImageIO

struct PhotoPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var coordinate: CLLocationCoordinate2D?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // Only images are selectable
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // No need to update
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerView

        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let uiImage = image as? UIImage {
                            self.parent.selectedImage = uiImage
                            self.extractPhotoLocation(from: provider)
                        }
                    }
                }
            }
        }

        private func extractPhotoLocation(from provider: NSItemProvider) {
            if let identifier = provider.registeredTypeIdentifiers.first {
                provider.loadDataRepresentation(forTypeIdentifier: identifier) { (data, error) in
                    if let data = data {
                        // Create a CGImageSource from the data
                        if let source = CGImageSourceCreateWithData(data as CFData, nil) {
                            // Extract metadata as a dictionary
                            if let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any],
                               let gps = metadata[String(kCGImagePropertyGPSDictionary)] as? [String: Any] {
                                
                                // Extract latitude and longitude from the GPS data
                                if let latitude = gps[String(kCGImagePropertyGPSLatitude)] as? CLLocationDegrees,
                                   let longitude = gps[String(kCGImagePropertyGPSLongitude)] as? CLLocationDegrees {
                                    DispatchQueue.main.async {
                                        self.parent.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

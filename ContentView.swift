import SwiftUI
import PhotosUI
import MapKit

struct ContentView: View {
    @State private var image: UIImage?
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var showImagePicker = false
    @State private var showAuthorizationAlert = false

    var body: some View {
        VStack {
            // Display the selected image
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            // Button to select a photo
            Button(action: {
                checkPhotoLibraryAuthorization()
            }) {
                Text("Select Photo")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $image, coordinate: $coordinate)
            }
            .alert(isPresented: $showAuthorizationAlert) {
                Alert(title: Text("Photo Library Access Required"),
                      message: Text("Please enable full photo library access in Settings."),
                      dismissButton: .default(Text("OK")))
            }

            // Display the map if there's a coordinate
            if let coordinate = coordinate {
                MapView(coordinate: coordinate)
                    .frame(height: 300)
            }
        }
        .padding()
    }

    private func checkPhotoLibraryAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            showImagePicker = true
        case .denied, .restricted:
            showAuthorizationAlert = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        showImagePicker = true
                    } else {
                        showAuthorizationAlert = true
                    }
                }
            }
        @unknown default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

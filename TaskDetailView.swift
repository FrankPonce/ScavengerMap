import SwiftUI
import MapKit

struct TaskDetailView: View {
    @Binding var task: Task
    @State private var showImagePicker = false

    var body: some View {
        VStack {
            Text(task.title)
                .font(.largeTitle)
                .padding()

            Text(task.description)
                .padding()

            if let image = task.attachedPhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Button(action: {
                showImagePicker = true
            }) {
                Text(task.attachedPhoto == nil ? "Attach Photo" : "Change Photo")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $task.attachedPhoto, coordinate: $task.photoLocation)
            }

            if let coordinate = task.photoLocation {
                Text("Photo Location:")
                MapView(coordinate: coordinate)
                    .frame(height: 300)
            }

            if task.isCompleted {
                Text("Task Completed!")
                    .foregroundColor(.green)
                    .font(.headline)
            }
        }
        .padding()
        .onChange(of: task.attachedPhoto) { newImage in
            if newImage != nil {
                task.isCompleted = true
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    @State static var task = Task(title: "Sample Task", description: "Sample Description")
    
    static var previews: some View {
        TaskDetailView(task: $task)
    }
}

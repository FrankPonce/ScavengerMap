import SwiftUI

struct TaskListView: View {
    @State private var tasks: [Task] = [
        Task(title: "Find the Statue", description: "Take a photo near the statue in the park."),
        Task(title: "City Hall", description: "Capture a photo at the City Hall."),
        Task(title: "Riverwalk", description: "Snap a picture by the river.")
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks.indices, id: \.self) { index in
                    NavigationLink(destination: TaskDetailView(task: $tasks[index])) {
                        HStack {
                            Text(tasks[index].title)
                            Spacer()
                            if tasks[index].isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Scavenger Hunt")
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}

import SwiftUI
import FirebaseFirestore

// Model for Class
struct ClassModel: Identifiable {
    var id: String
    var enrolledClasses: [String] // Array of class names
}

struct ClassListView: View {
    @State private var classes: [ClassModel] = []
    @State private var isLoading = true
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Fetching Classes...")
                        .padding()
                } else {
                    List(classes) { classItem in
                        VStack(alignment: .leading) {
                            Text("User ID: \(classItem.id)")
                                .font(.headline)
                            
                            // Display each enrolled class
                            ForEach(classItem.enrolledClasses, id: \.self) { enrolledClass in
                                Text(enrolledClass)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Class List")
            .onAppear(perform: fetchClasses)
        }
    }
    
    // Function to fetch classes from Firestore
    private func fetchClasses() {
        db.collection("Users").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No classes found")
                self.isLoading = false
                return
            }
            
            // Map the Firestore documents to ClassModel objects
            self.classes = documents.compactMap { doc -> ClassModel? in
                let data = doc.data()
                
                // Check and safely unwrap the required fields from Firestore
                guard let enrolledClasses = data["enrolledClasses"] as? [String] else {
                    return nil
                }
                
                // Return a ClassModel with the array of enrolled classes
                return ClassModel(id: doc.documentID, enrolledClasses: enrolledClasses)
            }
            
            self.isLoading = false
        }
    }
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassListView()
    }
}

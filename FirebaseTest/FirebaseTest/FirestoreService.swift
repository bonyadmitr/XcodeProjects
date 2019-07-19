import FirebaseFirestore

final class FirestoreService {
    
    /// https://firebase.google.com/docs/firestore/quickstart
    let db = Firestore.firestore()
    
    func getUsers() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let querySnapshot = querySnapshot {
                
                let users = querySnapshot.documents.map { $0.data() }
                print(users)
                
            } else {
                assertionFailure()
            }
        }
    }
    
    func createNewUser() {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "id": 2,
            "name": "some name of user"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}

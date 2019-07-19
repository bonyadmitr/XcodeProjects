import FirebaseDatabase

// TODO: !!! it is not working !!!
final class FIRDatabaseService {
    
    /// https://firebase.google.com/docs/database/ios/read-and-write
    let ref = Database.database().reference()
    
    func getUsers() {
        
        //        let userID = "qwe"
        //        let newName = "some name"
        
        /// rewrite all fields
        //ref.child("users").child(userID).setValue(["username": newName])
        
        /// update one field
        //ref.child("users/\(userID)/name").setValue(newName)
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let all = snapshot.value as? [String: Any]
            print(all ?? "nil")
            //            let username = value?["username"] as? String ?? ""
            //            let user = User(username: username)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

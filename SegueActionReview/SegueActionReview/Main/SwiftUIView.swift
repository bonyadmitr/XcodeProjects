import SwiftUI

struct SwiftUIView: View {
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        ZStack {
            Color.gray
            Button("Hello, \(text)!") {
                print("on SUI button: \(text)")
            }
            .font(.title)
            .foregroundColor(.white)
            .padding()
        }
        .edgesIgnoringSafeArea(.top)
        //.ignoresSafeArea()
        //        .navigationTitle("SwiftUI View")
    }
}

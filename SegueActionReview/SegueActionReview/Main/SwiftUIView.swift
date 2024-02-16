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

//final class SUIController: UIHostingController<SwiftUIView> {
//
//    init?(coder: NSCoder, text: String) {
//        super.init(coder: coder, rootView: SwiftUIView(text: text))
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder, rootView: SwiftUIView(text: "SwiftUI"))
//    }
//}

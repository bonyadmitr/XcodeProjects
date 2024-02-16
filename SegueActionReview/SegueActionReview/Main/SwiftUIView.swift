//
//  SwiftUIView.swift
//  SegueActionReview
//
//  Created by Yaroslav Bondar on 02.02.2024.
//

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

extension UIViewController {
    @IBSegueAction private func onSUIShared(_ coder: NSCoder) -> UIViewController? {
        UIHostingController(coder: coder, rootView: SwiftUIView(text: "SUI Shared"))
        //SUIController(coder: coder, text: "SUI Shared")
    }
}


/*
 SwiftUI in UIKit https://sarunw.com/posts/swiftui-in-uikit/
 SwiftUI in Storyboard https://sarunw.com/posts/swiftui-view-in-uikit-using-uihostingcontroller-subclass/
 IBSegueAction not working with UITabBarController https://sarunw.com/posts/custom-uihostingcontroller/
 ! SwiftUI in UIKit + Storyboard + Update UIKit layer from SwiftUI https://books.nilcoalescing.com/integrating-swiftui/swiftui-in-a-view-controller/hosting-controller-in-storyboards
 */
/// will remove `import SwiftUI` in UIKit file
extension View {
    func hostingController() -> UIHostingController<Self> {
        UIHostingController(rootView: self)
    }
    func hostingController(coder: NSCoder) -> UIHostingController<Self>? {
        UIHostingController(coder: coder, rootView: self)
    }
}

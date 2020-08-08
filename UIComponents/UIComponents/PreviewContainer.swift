import SwiftUI

struct CustomPreview: PreviewProvider {
    static var previews: some View {
        PreviewContainer()
            //        SendButton()
            .previewButtonPreset()
        //        .previewLayout(.fixed(width: 568, height: 320))
        
        //        VStack(spacing: 8) {
        //            CellPreviewContainer()
        //                .frame(width: UIScreen.main.bounds.width, height: 50, alignment: .center)
        //            CellPreviewContainer()
        //                .previewRightToLeft()
        //
        //        }
        //        .background(Color(.systemBackground))
        //        .environment(\.colorScheme, .dark)
        //        .previewDisplayName("Dark Theme")
        //        .padding()
        
        
        //        .environment(\.locale, locale)
        //        .previewDisplayName("Locale: \(locale.identifier)")
        //            .previewLayout(.sizeThatFits)
        //        .environment(\.locale, Locale(identifier: "RU"))
        //            .previewContentSize(.accessibilityExtraExtraExtraLarge)
        //        .environment(\.layoutDirection, .rightToLeft)
        
    }
    
    struct PreviewContainer: UIViewRepresentable {
        
        func makeUIView(context: Context) -> UIView {
            //            let label = UILabel()
            //            label.text = "some"
            //            label.adjustsFontForContentSizeCategory = true
            //            label.font = UIFont.preferredFont(forTextStyle: .body)
            //            return label
            
//            let textField = SecureTextField()
//            //            let textField = UITextField()
//            textField.placeholder = "Password"
//            return textField
            
            
            let textField2 = MainUnderlineTextField()
            textField2.placeholder = "Username d jfsjh bfjhsb jdj gjdbhgj"
            return textField2
            
//            let button6 = ButtonMain()
//            button6.setTitle("Ghost button 2 wwwww", for: .normal)
//            button6.image = UIImage(systemName: "square.and.arrow.up")
//            button6.imageEdgeInsets.right = 8
//            //button6.imageEdgeInsets.left = 8
//            return button6
            
            ////            let button3 = MultiLineButton(type: .system)
            //            let button3 = UIButton(type: .system)
            //            button3.setTitle("System Push\nqweqwe asdasd", for: .normal)
            //            button3.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            //            button3.tintColor = Colors.white
            //            button3.backgroundColor = Colors.main
            //            button3.titleLabel?.adjustsFontForContentSizeCategory = true
            //            button3.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            //            button3.heightAnchor.constraint(equalToConstant: 44).isActive = true
            //            button3.layer.cornerRadius = 8
            //            return button3
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            /// intrinsicContentSize https://stackoverflow.com/a/56745210/5893286
            uiView.setContentHuggingPriority(.required, for: .vertical)
            uiView.setContentHuggingPriority(.required, for: .horizontal)
            //            uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        //        typealias UIViewType = UIView
        
    }
}

struct ContentSizeCategoryPreview<Preview: View>: View {
    private let preview: Preview
    private let sizeCategory: ContentSizeCategory
    
    var body: some View {
        preview
            .previewLayout(.sizeThatFits)
            .environment(\.sizeCategory, sizeCategory)
            .previewDisplayName("Content Size Category: \(sizeCategory)")
    }
    
    init(_ sizeCategory: ContentSizeCategory, @ViewBuilder builder: @escaping () -> Preview) {
        self.sizeCategory = sizeCategory
        preview = builder()
    }
}


extension View {
    func previewContentSize(_ sizeCategory: ContentSizeCategory) -> some View {
        ContentSizeCategoryPreview(sizeCategory) { self }
    }
    
    func previewRightToLeft() -> some View {
        RightToLeftPreview { self }
    }
    
    func previewDarkTheme() -> some View {
        DarkThemePreview { self }
    }
    
    func previewButtonPreset() -> some View {
        let content = self.padding()
        
        return Group {
            //content.previewSupportedLocales()
            content.previewRightToLeft()
            content.previewDarkTheme()
            content.previewContentSize(.medium)
            content.previewContentSize(.extraExtraExtraLarge)
            content.previewContentSize(.accessibilityExtraExtraExtraLarge)
        }
    }
    
}

struct RightToLeftPreview<Preview: View>: View {
    private let preview: Preview
    
    var body: some View {
        preview
            .previewLayout(PreviewLayout.sizeThatFits)
            .environment(\.layoutDirection, .rightToLeft)
            .previewDisplayName("Right to Left")
    }
    
    init(@ViewBuilder builder: @escaping () -> Preview) {
        preview = builder()
    }
}

struct DarkThemePreview<Preview: View>: View {
    private let preview: Preview
    
    var body: some View {
        preview
            .previewLayout(PreviewLayout.sizeThatFits)
            .background(Color(.systemBackground))
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark Theme")
    }
    
    init(@ViewBuilder builder: @escaping () -> Preview) {
        preview = builder()
    }
}

struct SendButton: View {
    let onAction: () -> Void = {}
    
    var body: some View {
        Button(
            action: onAction,
            label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("common.button.send")
                }
        })
    }
}

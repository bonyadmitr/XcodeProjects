## ImageFormat


### Using
```swift
for file in ["1.jpg", "2.png", "3.gif", "4.svg", "5.TIF", "6.webp", "7.HEIC"] {
    if let data = Data(bundleFileName: file) {
        print(file, ImageFormat.get(from: data))
    }
}

/// Result
/// 1.jpg jpg
/// 2.png png
/// 3.gif gif
/// 4.svg unknown
/// 5.TIF tiff
/// 6.webp webp
/// 7.HEIC heic
```
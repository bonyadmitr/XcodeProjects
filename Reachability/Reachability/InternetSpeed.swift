import Foundation


extension InternetSpeed {
    static let shared = InternetSpeed()
}

public class InternetSpeed: NSObject {
    
    ///
    private var session = URLSession.shared
    
    private override init() {
        super.init()
        
        /// it will be copy of URLSessionConfiguration.default
        let configuration = URLSessionConfiguration.default
        
        session = URLSession(configuration: configuration,
                             delegate: self, delegateQueue: nil)
    }
    
    private var startTime: CFAbsoluteTime = 0
    private var stopTime: CFAbsoluteTime = 0
    private var bytesReceived: Int = 0
    //    var speedTestCompletionHandler: ((_ megabytesPerSecond: Double?, _ error: NSError?) -> ())!
    //
    //    /// Test speed of download
    //    ///
    //    /// Test the speed of a connection by downloading some predetermined resource. Alternatively, you could add the
    //    /// URL of what to use for testing the connection as a parameter to this method.
    //    ///
    //    /// - parameter timeout:             The maximum amount of time for the request.
    //    /// - parameter completionHandler:   The block to be called when the request finishes (or times out).
    //    ///                                  The error parameter to this closure indicates whether there was an error downloading
    //    ///                                  the resource (other than timeout).
    //    ///
    //    /// - note:                          Note, the timeout parameter doesn't have to be enough to download the entire
    //    ///                                  resource, but rather just sufficiently long enough to measure the speed of the download.
    //
    //    public func testDownloadSpeedWithTimout(timeout: TimeInterval, completionHandler:@escaping (_ megabytesPerSecond: Double?, _ error: NSError?) -> ()) {
    //        let url = NSURL(string: "http://insert.your.site.here/yourfile")!
    //
    //        startTime = CFAbsoluteTimeGetCurrent()
    //        stopTime = startTime
    //        bytesReceived = 0
    //        speedTestCompletionHandler = completionHandler
    //
    //        let configuration = URLSessionConfiguration.ephemeral
    //        configuration.timeoutIntervalForResource = timeout
    //        URLSession.
    //        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    //        session.dataTaskWithURL(url).resume()
    //    }
    //
    //    public func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: NSData){
    //        bytesReceived! += data.length
    //        stopTime = CFAbsoluteTimeGetCurrent()
    //    }
    //
    //    public func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
    //        let elapsed = stopTime - startTime
    //        guard elapsed != 0 && (error == nil || (error?.domain == NSURLErrorDomain && error?.code == NSURLErrorTimedOut)) else {
    //            speedTestCompletionHandler(megabytesPerSecond: nil, error: error)
    //            return
    //        }
    //
    //        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
    //        speedTestCompletionHandler(megabytesPerSecond: speed, error: nil)
    //    }
    //
    /////
    
    func testDownloadSpeedWithTimout() {
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0
        
        
        
        //        let task = URLSession.shared.dataTask(with: url) { _, _, _ in
        //            page.finishExecution()
        //        }
        //
        //        // Don't forget to invalidate the observation when you don't need it anymore.
        //        let observation = task.progress.observe(\.fractionCompleted) { progress, _ in
        //            print(progress.fractionCompleted)
        //        }
        //
        //        task.resume()
        
        
        
        let urlString = "https://www.google.com"
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 60
        urlRequest.httpMethod = "HEAD"
        //urlRequest.cachePolicy = .reloadRevalidatingCacheData
        //urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: urlRequest).resume()
        //        URLSession.shared.dataTask(with: urlRequest) { _, _, error in
        //
        //
        //
        //            //guard let error = error as? URLError else {
        //            //    self.view.backgroundColor = .green
        //            //    return
        //            //}
        //            //
        //            //switch error.code {
        //            //case .timedOut:
        //            //    print("there is no INTERNET connection or it is very slow")
        //            //case .notConnectedToInternet:
        //            //    print("there is no NETWORK connection at all")
        //            //default:
        //            //    print(error.localizedDescription)
        //            //}
        //            }.resume()
        
        
    }
}

extension InternetSpeed: URLSessionDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let elapsed = stopTime - startTime
        
        //        guard elapsed != 0 && (error == nil || (error?.domain == NSURLErrorDomain && error?.code == NSURLErrorTimedOut)) else {
        //            speedTestCompletionHandler(megabytesPerSecond: nil, error: error)
        //            return
        //        }
        
        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        print(speed)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
    }
}

extension InternetSpeed: URLSessionDataDelegate {
    
}


extension InternetSpeed2 {
    static let shared = InternetSpeed2()
}


// TODO: create callbacks or delegates
final class InternetSpeed2: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    /// not let due NSObject. setup in init
    private var session = URLSession.shared
    
    private var dataTask: URLSessionTask?
    
    private var startTime: CFAbsoluteTime = 0
    private var bufferSize: Int64 = 0
    
    private var expectedContentLength: Int64 = 0
    private var totalLengthString = ""
    
    private let dataFormatStyle = ByteCountFormatter.CountStyle.binary
    
    /// can be static values
    private let minuteInSeconds: Double = 60
    private let hourInSeconds: Double = 3600
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()
    
    private var isStarted = false
    
    private override init() {
        super.init()
        
        /// it will be copy of URLSessionConfiguration.default
        let configuration = URLSessionConfiguration.default
        
        /// if delegateQueue: nil there will not be dispatch queue but operation queue with threads in background
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func start() {
        guard !isStarted else {
            assertionFailure("don't call twice")
            return
        }
        isStarted = true
        /// big files but http
        /// http://speedtest.tele2.net/
        ///
        /// https test files
        /// https://speed.hetzner.de/
        //let urlString = "https://speed.hetzner.de/100MB.bin"
        let urlString = "https://speed.hetzner.de/1GB.bin"
        //let urlString = "https://speed.hetzner.de/10GB.bin"
        
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }
        fetchFile(url: url)
    }
    
    private func fetchFile(url: URL) {
        dataTask = session.dataTask(with: URLRequest(url: url))
        dataTask?.resume()
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func cancel() {
        dataTask?.cancel()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bufferSize += Int64(data.count)
        let timeNow = CFAbsoluteTimeGetCurrent()
        let passedTime = timeNow - startTime
        
        let downloaded = Int64(bufferSize)
        let speed = Double(downloaded) / passedTime
        let leftTime = Double(expectedContentLength - downloaded) / speed
        
        if leftTime < minuteInSeconds {
            timeFormatter.allowedUnits = [.second]
        } else if leftTime < hourInSeconds {
            timeFormatter.allowedUnits = [.minute]
        } else {
            timeFormatter.allowedUnits = [.hour]
        }
        
        let leftTimeString = timeFormatter.string(from: leftTime) ?? "..."
        
        let speedString = ByteCountFormatter.string(fromByteCount: Int64(speed), countStyle: dataFormatStyle)
        let downloadedString = ByteCountFormatter.string(fromByteCount: downloaded, countStyle: dataFormatStyle)
        
        
        /// to clear terminal
        for _ in 1...19 {
            print("\n")
        }
        
        /// google download text example
        //5.5 MB/s - 33.1 MB of 1,000 MB, 3 mins left
        print("\(speedString)/s, \(downloadedString) of \(totalLengthString), \(leftTimeString) left")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        expectedContentLength = response.expectedContentLength
        
        totalLengthString = ByteCountFormatter.string(fromByteCount: expectedContentLength, countStyle: dataFormatStyle)
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("finished")
        isStarted = false
    }
}

//extension Double {
//    /// Rounds the double to decimal places value
//    func rounded(toPlaces places: Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return (self * divisor).rounded() / divisor
//    }
//}

extension InternetSpeed3 {
    static let shared = InternetSpeed3()
}

final class InternetSpeed3: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    /// not let due NSObject. setup in init
    private var session = URLSession.shared
    
    private var dataTask: URLSessionTask?
    
    private var startTime: CFAbsoluteTime = 0
//    private var buffer = NSMutableData()
    
    private var expectedContentLength: Int64 = 0
    private var totalLengthString = ""
    
    private let dataFormatStyle = ByteCountFormatter.CountStyle.binary
    
    /// can be static values
    private let minuteInSeconds: Double = 60
    private let hourInSeconds: Double = 3600
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()
    
    private var isStarted = false
    
    private override init() {
        super.init()
        
        /// it will be copy of URLSessionConfiguration.default
        let configuration = URLSessionConfiguration.default
        if #available(iOS 11.0, *) {
            configuration.waitsForConnectivity = false
        }
        
        configuration.allowsCellularAccess = true
        
        /// if delegateQueue: nil there will not be dispatch queue but operation queue with threads in background
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func start() {
        guard !isStarted else {
            assertionFailure("don't call twice")
            return
        }
        isStarted = true
        /// big files but http
        /// http://speedtest.tele2.net/
        ///
        /// https test files
        /// https://speed.hetzner.de/
        let urlString = "https://speed.hetzner.de/100MB.bin"
//        let urlString = "https://speed.hetzner.de/1GB.bin"
        //let urlString = "https://speed.hetzner.de/10GB.bin"
        
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }
        fetchFile(url: url)
    }
    
    private func fetchFile(url: URL) {
        //dataTask = session.dataTask(with: URLRequest(url: url))
        dataTask = session.downloadTask(with: URLRequest(url: url))
        dataTask?.resume()
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func cancel() {
        dataTask?.cancel()
    }
    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        buffer.append(data)
//        let timeNow = CFAbsoluteTimeGetCurrent()
//        let passedTime = timeNow - startTime
//
//        let downloaded = Int64(buffer.length)
//        let speed = Double(downloaded) / passedTime
//        let leftTime = Double(expectedContentLength - downloaded) / speed
//
//        if leftTime < minuteInSeconds {
//            timeFormatter.allowedUnits = [.second]
//        } else if leftTime < hourInSeconds {
//            timeFormatter.allowedUnits = [.minute]
//        } else {
//            timeFormatter.allowedUnits = [.hour]
//        }
//
//        let leftTimeString = timeFormatter.string(from: leftTime) ?? "..."
//
//        let speedString = ByteCountFormatter.string(fromByteCount: Int64(speed), countStyle: dataFormatStyle)
//        let downloadedString = ByteCountFormatter.string(fromByteCount: downloaded, countStyle: dataFormatStyle)
//
//
//        /// to clear terminal
//        for _ in 1...19 {
//            print("\n")
//        }
//
//        /// google download text example
//        //5.5 MB/s - 33.1 MB of 1,000 MB, 3 mins left
//        print("\(speedString)/s, \(downloadedString) of \(totalLengthString), \(leftTimeString) left")
//    }
    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
//        expectedContentLength = response.expectedContentLength
//
//        totalLengthString = ByteCountFormatter.string(fromByteCount: expectedContentLength, countStyle: dataFormatStyle)
//        completionHandler(URLSession.ResponseDisposition.allow)
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        print("finished")
//        isStarted = false
//    }
    
    
    /// will be called before
    /// "func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)"
    /// will NOT be called for error
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("finished")
//        isStarted = false
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
//                buffer.append(data)
                let timeNow = CFAbsoluteTimeGetCurrent()
                let passedTime = timeNow - startTime
        
                let downloaded = totalBytesWritten
                let speed = Double(downloaded) / passedTime
                let leftTime = Double(expectedContentLength - downloaded) / speed
        
                if leftTime < minuteInSeconds {
                    timeFormatter.allowedUnits = [.second]
                } else if leftTime < hourInSeconds {
                    timeFormatter.allowedUnits = [.minute]
                } else {
                    timeFormatter.allowedUnits = [.hour]
                }
        
                let leftTimeString = timeFormatter.string(from: leftTime) ?? "..."
        
                let speedString = ByteCountFormatter.string(fromByteCount: Int64(speed), countStyle: dataFormatStyle)
                let downloadedString = ByteCountFormatter.string(fromByteCount: downloaded, countStyle: dataFormatStyle)
        
        
                /// to clear terminal
                for _ in 1...19 {
                    print("\n")
                }
        
                /// google download text example
                //5.5 MB/s - 33.1 MB of 1,000 MB, 3 mins left
                print("\(speedString)/s, \(downloadedString) of \(totalLengthString), \(leftTimeString) left")
        
        if expectedContentLength != totalBytesExpectedToWrite {
            expectedContentLength = totalBytesExpectedToWrite
            totalLengthString = ByteCountFormatter.string(fromByteCount: expectedContentLength, countStyle: dataFormatStyle)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("finished")
        isStarted = false
    }
}

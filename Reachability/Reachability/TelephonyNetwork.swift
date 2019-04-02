import CoreTelephony

extension TelephonyNetwork {
    static let shared = TelephonyNetwork()
}

/// !!! CTRadioAccessTechnologyDidChange called on every creation of CTTelephonyNetworkInfo
/// will be a lot of errors on the simulator due creation of CTTelephonyNetworkInfo
/// so use "#if !targetEnvironment(simulator) #endif"
final class TelephonyNetwork {
    
    /// can't be named cases like 3G or 4G due the language
    enum CellularType: CustomStringConvertible {
        case none, g2, g3, g4, unknown
        
        var description: String {
            switch self {
            case .none:
                return "No Connection"
            case .g2:
                return "2G"
            case .g3:
                return "3G"
            case .g4:
                return "4G"
            case .unknown:
                return "5G or Unknown"
            }
        }
    }
    
    var cellularType: CellularType = .none
    
    private let networkInfo = CTTelephonyNetworkInfo()
    private var notificationToken: NSObjectProtocol?
    
    init() {
        cellularType = cellularType(for: networkInfo.currentRadioAccessTechnology)
    }
    
    deinit {
        stopListening()
    }
    
    func startListening() {
        guard notificationToken == nil else {
            assertionFailure("don't need to start twice")
            return
        }
        
        /// object can contains currentRadioAccessTechnology or nil
        /// queue is CTTelephonyNetworkInfo(serial)
        NotificationCenter.default.addObserver(forName: .CTRadioAccessTechnologyDidChange, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else {
                return
            }
            self.cellularType = self.cellularType(for: notification.object as? String)
            print("Cellular changed:", self.cellularType)
        }
    }
    
    func stopListening() {
        if let notificationToken = notificationToken {
            NotificationCenter.default.removeObserver(notificationToken, name: .CTRadioAccessTechnologyDidChange, object: nil)
        }
    }
    
    private func cellularType(for technology: String?) -> CellularType {
        /// can be .none when changing to 2G
        guard let technology = technology else {
            return .none
        }
        
        /// https://stackoverflow.com/a/44646476/5893286
        switch technology {
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyCDMA1x:
            return .g2
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return .g3
        case CTRadioAccessTechnologyLTE:
            return .g4
        default:
            /// never called during the tests
            /// can be called for new networks like 5G
            return .unknown
        }
    }
}

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


class InternetSpeed2: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    
    
    func start() {
        /// big files but http
        /// http://speedtest.tele2.net/
        ///
        /// https test files
        /// https://speed.hetzner.de/
//        let url = URL(string: "https://speed.hetzner.de/100MB.bin")!
        let url = URL(string: "https://speed.hetzner.de/1GB.bin")!
//        let url = URL(string: "https://speed.hetzner.de/10GB.bin")!
        fetchFile(url: url)
    }
    
    func fetchFile(url: URL) {
        /// it will be copy of URLSessionConfiguration.default
        let configuration = URLSessionConfiguration.default
        
        /// if delegateQueue: nil there will not be dispatch queue but operation queue with threads in background
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        dataTask = session?.dataTask(with: URLRequest(url: url))
        dataTask?.resume()
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func cancel() {
        dataTask?.cancel()
    }
    
    private var startTime: CFAbsoluteTime = 0
    private var buffer = NSMutableData()
    private var session: URLSession?
    var dataTask: URLSessionDataTask?
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
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer.append(data)
        let timeNow = CFAbsoluteTimeGetCurrent()
        let passedTime = timeNow - startTime
        
        let downloaded = Int64(buffer.length)
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
        
        
//        let downloaded = buffer.length / 1024 / 1024
//
//        // in mb/s
//        let speed = Double(downloaded) / passedTime
//        let leftTime = (Double(totalLength - Int64(downloaded)) / speed / 60).rounded(toPlaces: 2)
////        let leftTime = (Double(expectedContentLength - Int64(buffer.length)) / 60).rounded(toPlaces: 2)
////        let leftTime = (Double(expectedContentLength - Int64(buffer.length)) / speed).rounded()
////        print(speed)
//
//        /// google download text example
//        //5.5 MB/s - 33.1 MB of 1,000 MB, 3 mins left
//        print("\(speed.rounded(toPlaces: 2)) MB/s, \(downloaded) MB of \(totalLength) MB, \(leftTime) mins left")
        
        
//        let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
//        progress.progress =  percentageDownloaded
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        expectedContentLength = response.expectedContentLength
        
        totalLengthString = ByteCountFormatter.string(fromByteCount: expectedContentLength, countStyle: dataFormatStyle)
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        progress.progress = 1.0
        print("finished")
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

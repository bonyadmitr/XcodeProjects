import Foundation
import Crashlytics

func log(_ text: String) {
    /// add log to file
    crashlyticsLogs(text)
}

func logLine(file: String = #file, line: UInt = #line, functionName: String = #function) {
    /// add log to file
    crashlyticsLogsLine(file: file, line: line, functionName: functionName)
}

func logError(_ error: NSError) {
    /// add log to file
    Crashlytics.sharedInstance().recordError(error)
}

// TODO: NSError only or Error too
private func crashlyticsLogError(_ error: NSError) {
    Crashlytics.sharedInstance().recordError(error)
}

private func crashlyticsLogsLine(file: String = #file, line: UInt = #line, functionName: String = #function) {
    let fileName = (file as NSString).lastPathComponent
    crashlyticsLogs("\(fileName) \(line) \(functionName)")
}

/// https://firebase.google.com/docs/crashlytics/customize-crash-reports
///
/// don't call before "Fabric.with([Crashlytics.self])"
private func crashlyticsLogs(_ string: String) {
    CLSLogv("%@", getVaList([string]))
}

import Foundation

typealias ResultHandler<T> = (Result<T>) -> Void

enum Result<T> {
    case success(T)
    case failure(Error)
}

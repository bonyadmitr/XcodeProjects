//
//  DispatchIOWrapper.swift
//  FileManagerReview
//
//  Created by Yaroslav Bondar on 14.05.2022.
//

import Foundation





/// https://github.com/vitali-kurlovich/DispatchIOWrapper/blob/main/Sources/DispatchIOWrapper/DispatchIOWrapper.swift
// TODO: check error in `progress.completedUnitCount += Int64(writedData.count)`. i think it should be `progress.completedUnitCount = progress.totalUnitCount - Int64(data.count)`
/** usage write
 
             let dw = DispatchIOWrapper(type: .stream, filePath: fileUrl.path, options: [.createIfNotExists, .writeOnly], permission: .userWrite, queue: .global()) { result in
                print(result)
            }
            dw?.write(offset: 0, data: data, progressHandler: { progress in
                print(progress)
            }, completion: { result in
                print(result)
            })
 */


import Dispatch
import Foundation

public
struct FileOpenOption: OptionSet {
    public let rawValue: Int32
    
    public
    init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
}

extension FileOpenOption {
    public static let append = FileOpenOption(rawValue: O_APPEND)
    public static let createIfNotExists = FileOpenOption(rawValue: O_CREAT)
    public static let noDelay = FileOpenOption(rawValue: O_NONBLOCK)
    public static let errorIfExists = FileOpenOption(rawValue: O_EXCL)
    
    public static let readOnly = FileOpenOption(rawValue: O_RDONLY)
    public static let writeOnly = FileOpenOption(rawValue: O_WRONLY)
    public static let readAndWrite = FileOpenOption(rawValue: O_RDWR)
}

public
struct IOPermission: OptionSet {
    public let rawValue: mode_t
    
    public
    init(rawValue: mode_t) {
        self.rawValue = rawValue
    }
    
    public static let userReadWriteExec = IOPermission(rawValue: S_IRWXU)
    public static let userRead = IOPermission(rawValue: S_IRUSR)
    public static let userWrite = IOPermission(rawValue: S_IWUSR)
    public static let userExec = IOPermission(rawValue: S_IXUSR)
    
    public static let groupReadWriteExec = IOPermission(rawValue: S_IRWXG)
    public static let groupRead = IOPermission(rawValue: S_IRGRP)
    public static let groupWrite = IOPermission(rawValue: S_IWGRP)
    public static let groupExec = IOPermission(rawValue: S_IXGRP)
    
    public static let othersReadWriteExec = IOPermission(rawValue: S_IRWXO)
    public static let othersRead = IOPermission(rawValue: S_IROTH)
    public static let othersWrite = IOPermission(rawValue: S_IWOTH)
    public static let othersExec = IOPermission(rawValue: S_IXOTH)
}

public
final class DispatchIOWrapper {
    public typealias FileError = PosixError
    public typealias StreamType = DispatchIO.StreamType
    
    internal let dispatchIO: DispatchIO
    internal let dispatchQueue: DispatchQueue
    internal let cleanupHandler: (Result<Void, FileError>) -> Void
    
    private
    init(dispatchIO: DispatchIO, queue: DispatchQueue, cleanupHandler: @escaping (Result<Void, FileError>) -> Void) {
        self.dispatchIO = dispatchIO
        dispatchQueue = queue
        self.cleanupHandler = cleanupHandler
    }
}

extension DispatchIOWrapper {
    public
    convenience init?(type: StreamType,
                      filePath: String,
                      options: FileOpenOption = [.createIfNotExists, .readAndWrite],
                      permission: IOPermission = [.userRead, .userWrite],
                      queue: DispatchQueue,
                      cleanupHandler: @escaping (Result<Void, FileError>) -> Void)
    {
        let oflag = options.rawValue
        let mode = permission.rawValue
        
        let io = filePath.withCString { (cStr) -> DispatchIO? in
            DispatchIO(type: type, path: cStr, oflag: oflag, mode: mode, queue: queue) { errorCode in
                if let error = FileError(rawValue: errorCode) {
                    cleanupHandler(.failure(error))
                } else {
                    cleanupHandler(.success(()))
                }
            }
        }
        
        guard let dispatchIO = io else {
            return nil
        }
        
        self.init(dispatchIO: dispatchIO, queue: queue, cleanupHandler: cleanupHandler)
    }
}

extension DispatchIOWrapper {
    public
    convenience init(type: StreamType, fileDescriptor: Int32, queue: DispatchQueue, cleanupHandler: @escaping (Result<Void, FileError>) -> Void) {
        let dispatchIO = DispatchIO(type: type, fileDescriptor: fileDescriptor, queue: queue) { errorCode in
            if let error = FileError(rawValue: errorCode) {
                cleanupHandler(.failure(error))
                
            } else {
                cleanupHandler(.success(()))
            }
        }
        
        self.init(dispatchIO: dispatchIO, queue: queue, cleanupHandler: cleanupHandler)
    }
    
    public
    convenience init(type: StreamType, io: DispatchIO, queue: DispatchQueue, cleanupHandler: @escaping (Result<Void, FileError>) -> Void) {
        let dispatchIO = DispatchIO(type: type, io: io, queue: queue) { errorCode in
            
            if let error = FileError(rawValue: errorCode) {
                cleanupHandler(.failure(error))
                
            } else {
                cleanupHandler(.success(()))
            }
        }
        
        self.init(dispatchIO: dispatchIO, queue: queue, cleanupHandler: cleanupHandler)
    }
}

extension DispatchIOWrapper {
    public
    func channel(type: StreamType, queue _: DispatchQueue, cleanupHandler: @escaping (Result<Void, FileError>) -> Void) -> DispatchIOWrapper {
        DispatchIOWrapper(type: type, io: dispatchIO, queue: dispatchQueue, cleanupHandler: cleanupHandler)
    }
    
    public
    func channel(type: StreamType, cleanupHandler: @escaping (Result<Void, FileError>) -> Void) -> DispatchIOWrapper {
        channel(type: type, queue: dispatchQueue, cleanupHandler: cleanupHandler)
    }
    
    public
    func channel(type: StreamType, queue: DispatchQueue) -> DispatchIOWrapper {
        channel(type: type, queue: queue, cleanupHandler: cleanupHandler)
    }
    
    public
    func channel(type: StreamType) -> DispatchIOWrapper {
        channel(type: type, queue: dispatchQueue, cleanupHandler: cleanupHandler)
    }
}

extension DispatchIOWrapper {
    public
    func close() {
        dispatchIO.close()
    }
    
    public
    func read(offset: Int,
              length: Int = Int(bitPattern: Dispatch.SIZE_MAX),
              progressHandler: @escaping ((Progress) -> Void),
              completion: @escaping (Result<Data, FileError>) -> Void)
    {
        let totalUnitCount = Int64(length)
        let progress = Progress(totalUnitCount: totalUnitCount)
        
        progressHandler(progress)
        
        var data = Data()
        if length > 0 {
            data.reserveCapacity(length)
        }
        
        dispatchIO.read(offset: off_t(offset), length: length, queue: dispatchQueue, ioHandler: { done, readedData, errorCode in
            
            if let error = FileError(rawValue: errorCode) {
                progress.cancel()
                progressHandler(progress)
                
                completion(.failure(error))
                return
            }
            
            if done {
                progress.completedUnitCount = totalUnitCount
                progressHandler(progress)
                
                if let readedData = readedData {
                    data.append(contentsOf: readedData)
                }
                
                completion(.success(data))
                
            } else {
                if let readedData = readedData {
                    data.append(contentsOf: readedData)
                    progress.completedUnitCount += Int64(readedData.count)
                }
                
                progressHandler(progress)
            }
            
        })
    }
    
    public
    func write(offset: Int, data: Data,
               progressHandler: @escaping ((Progress) -> Void),
               completion: @escaping (Result<Void, FileError>) -> Void)
    {
        let totalUnitCount = Int64(data.count)
        let progress = Progress(totalUnitCount: totalUnitCount)
        
        // let ioqueue = dispatchQueue
        let dispatchData = data.withUnsafeBytes { (buffer) -> DispatchData in
            DispatchData(bytes: buffer)
        }
        
        struct DataHolder {
            var data: Data?
        }
        
        var holder = DataHolder(data: data)
        
        progressHandler(progress)
        
        dispatchIO.write(offset: off_t(offset),
                         data: dispatchData,
                         queue: dispatchQueue,
                         ioHandler: { done, writedData, errorCode in
            
            if let error = FileError(rawValue: errorCode) {
                progress.cancel()
                progressHandler(progress)
                
                completion(.failure(error))
                return
            }
            
            if let writedData = writedData {
                progress.completedUnitCount += Int64(writedData.count)
            }
            
            if done {
                progress.completedUnitCount = totalUnitCount
                progressHandler(progress)
                completion(.success(()))
                holder.data = nil
            } else {
                progressHandler(progress)
            }
        })
    }
}


//
//  File 2.swift
//
//
//  Created by Vitali Kurlovich on 25.11.20.
//

import Foundation

public
enum PosixError: Int32, Error {
    /// Operation not permitted.
    case EPERM = 1
    
    /// No such file or directory.
    case ENOENT = 2
    
    /// No such process.
    case ESRCH = 3
    
    /// Interrupted system call.
    case EINTR = 4
    
    /// Input/output error.
    case EIO = 5
    
    /// Device not configured.
    case ENXIO = 6
    
    /// Argument list too long.
    case E2BIG = 7
    
    /// Exec format error.
    case ENOEXEC = 8
    
    /// Bad file descriptor.
    case EBADF = 9
    
    /// No child processes.
    case ECHILD = 10
    
    /// Resource deadlock avoided.
    case EDEADLK = 11
    
    /// 11 was EAGAIN.
    /// Cannot allocate memory.
    case ENOMEM = 12
    
    /// Permission denied.
    case EACCES = 13
    
    /// Bad address.
    case EFAULT = 14
    
    /// Block device required.
    case ENOTBLK = 15
    
    /// Device / Resource busy.
    case EBUSY = 16
    
    /// File exists.
    case EEXIST = 17
    
    /// Cross-device link.
    case EXDEV = 18
    
    /// Operation not supported by device.
    case ENODEV = 19
    
    /// Not a directory.
    case ENOTDIR = 20
    
    /// Is a directory.
    case EISDIR = 21
    
    /// Invalid argument.
    case EINVAL = 22
    
    /// Too many open files in system.
    case ENFILE = 23
    
    /// Too many open files.
    case EMFILE = 24
    
    /// Inappropriate ioctl for device.
    case ENOTTY = 25
    
    /// Text file busy.
    case ETXTBSY = 26
    
    /// File too large.
    case EFBIG = 27
    
    /// No space left on device.
    case ENOSPC = 28
    
    /// Illegal seek.
    case ESPIPE = 29
    
    /// Read-only file system.
    case EROFS = 30
    
    /// Too many links.
    case EMLINK = 31
    
    /// Broken pipe.
    case EPIPE = 32
    
    /// math software.
    /// Numerical argument out of domain.
    case EDOM = 33
    
    /// Result too large.
    case ERANGE = 34
    
    /// non-blocking and interrupt i/o.
    /// Resource temporarily unavailable.
    case EAGAIN = 35
    
    /// Operation now in progress.
    case EINPROGRESS = 36
    
    /// Operation already in progress.
    case EALREADY = 37
    
    /// ipc/network software -- argument errors.
    /// Socket operation on non-socket.
    case ENOTSOCK = 38
    
    /// Destination address required.
    case EDESTADDRREQ = 39
    
    /// Message too long.
    case EMSGSIZE = 40
    
    /// Protocol wrong type for socket.
    case EPROTOTYPE = 41
    
    /// Protocol not available.
    case ENOPROTOOPT = 42
    
    /// Protocol not supported.
    case EPROTONOSUPPORT = 43
    
    /// Socket type not supported.
    case ESOCKTNOSUPPORT = 44
    
    /// Operation not supported.
    case ENOTSUP = 45
    
    /// Protocol family not supported.
    case EPFNOSUPPORT = 46
    
    /// Address family not supported by protocol family.
    case EAFNOSUPPORT = 47
    
    /// Address already in use.
    case EADDRINUSE = 48
    
    /// Can't assign requested address.
    case EADDRNOTAVAIL = 49
    
    /// ipc/network software -- operational errors
    /// Network is down.
    case ENETDOWN = 50
    
    /// Network is unreachable.
    case ENETUNREACH = 51
    
    /// Network dropped connection on reset.
    case ENETRESET = 52
    
    /// Software caused connection abort.
    case ECONNABORTED = 53
    
    /// Connection reset by peer.
    case ECONNRESET = 54
    
    /// No buffer space available.
    case ENOBUFS = 55
    
    /// Socket is already connected.
    case EISCONN = 56
    
    /// Socket is not connected.
    case ENOTCONN = 57
    
    /// Can't send after socket shutdown.
    case ESHUTDOWN = 58
    
    /// Too many references: can't splice.
    case ETOOMANYREFS = 59
    
    /// Operation timed out.
    case ETIMEDOUT = 60
    
    /// Connection refused.
    case ECONNREFUSED = 61
    
    /// Too many levels of symbolic links.
    case ELOOP = 62
    
    /// File name too long.
    case ENAMETOOLONG = 63
    
    /// Host is down.
    case EHOSTDOWN = 64
    
    /// No route to host.
    case EHOSTUNREACH = 65
    
    /// Directory not empty.
    case ENOTEMPTY = 66
    
    /// quotas & mush.
    /// Too many processes.
    case EPROCLIM = 67
    
    /// Too many users.
    case EUSERS = 68
    
    /// Disc quota exceeded.
    case EDQUOT = 69
    
    /// Network File System.
    /// Stale NFS file handle.
    case ESTALE = 70
    
    /// Too many levels of remote in path.
    case EREMOTE = 71
    
    /// RPC struct is bad.
    case EBADRPC = 72
    
    /// RPC version wrong.
    case ERPCMISMATCH = 73
    
    /// RPC prog. not avail.
    case EPROGUNAVAIL = 74
    
    /// Program version wrong.
    case EPROGMISMATCH = 75
    
    /// Bad procedure for program.
    case EPROCUNAVAIL = 76
    
    /// No locks available.
    case ENOLCK = 77
    
    /// Function not implemented.
    case ENOSYS = 78
    
    /// Inappropriate file type or format.
    case EFTYPE = 79
    
    /// Authentication error.
    case EAUTH = 80
    
    /// Need authenticator.
    case ENEEDAUTH = 81
    
    /// Intelligent device errors.
    /// Device power is off.
    case EPWROFF = 82
    
    /// Device error, e.g. paper out.
    case EDEVERR = 83
    
    /// Value too large to be stored in data type.
    case EOVERFLOW = 84
    
    /// Bad executable.
    case EBADEXEC = 85
    
    /// Bad CPU type in executable.
    case EBADARCH = 86
    
    /// Shared library version mismatch.
    case ESHLIBVERS = 87
    
    /// Malformed Macho file.
    case EBADMACHO = 88
    
    /// Operation canceled.
    case ECANCELED = 89
    
    /// Identifier removed.
    case EIDRM = 90
    
    /// No message of desired type.
    case ENOMSG = 91
    
    /// Illegal byte sequence.
    case EILSEQ = 92
    
    /// Attribute not found.
    case ENOATTR = 93
    
    /// Bad message.
    case EBADMSG = 94
    
    /// Reserved.
    case EMULTIHOP = 95
    
    /// No message available on STREAM.
    case ENODATA = 96
    
    /// Reserved.
    case ENOLINK = 97
    
    /// No STREAM resources.
    case ENOSR = 98
    
    /// Not a STREAM.
    case ENOSTR = 99
    
    /// Protocol error.
    case EPROTO = 100
    
    /// STREAM ioctl timeout.
    case ETIME = 101
    
    /// No such policy registered.
    case ENOPOLICY = 103
    
    /// State not recoverable.
    case ENOTRECOVERABLE = 104
    
    /// Previous owner died.
    case EOWNERDEAD = 105
    
    /// Interface output queue is full.
    case EQFULL = 106
}

extension PosixError: LocalizedError {
    public
    var errorDescription: String? {
        switch self {
        case .EPERM:
            return "Operation not permitted."
            
        case .ENOENT:
            return "No such file or directory."
            
        case .ESRCH:
            return "No such process."
            
        case .EINTR:
            return "Interrupted system call."
            
        case .EIO:
            return "Input/output error."
            
        case .ENXIO:
            return "Device not configured."
            
        case .E2BIG:
            return "Argument list too long."
            
        case .ENOEXEC:
            return "Exec format error."
            
        case .EBADF:
            return "Bad file descriptor."
            
        case .ECHILD:
            return "No child processes."
            
        case .EDEADLK:
            return "Resource deadlock avoided."
            
        case .ENOMEM:
            return "11 was EAGAIN.\nCannot allocate memory."
            
        case .EACCES:
            return "Permission denied."
            
        case .EFAULT:
            return "Bad address."
            
        case .ENOTBLK:
            return "Block device required."
            
        case .EBUSY:
            return "Device / Resource busy."
            
        case .EEXIST:
            return "File exists."
            
        case .EXDEV:
            return "Cross-device link."
            
        case .ENODEV:
            return "Operation not supported by device."
            
        case .ENOTDIR:
            return "Not a directory."
            
        case .EISDIR:
            return "Is a directory."
            
        case .EINVAL:
            return "Invalid argument."
            
        case .ENFILE:
            return "Too many open files in system."
            
        case .EMFILE:
            return "Too many open files."
            
        case .ENOTTY:
            return "Inappropriate ioctl for device."
            
        case .ETXTBSY:
            return "Text file busy."
            
        case .EFBIG:
            return "File too large."
            
        case .ENOSPC:
            return "No space left on device."
            
        case .ESPIPE:
            return "Illegal seek."
            
        case .EROFS:
            return "Read-only file system."
            
        case .EMLINK:
            return "Too many links."
            
        case .EPIPE:
            return "Broken pipe."
            
        case .EDOM:
            return "math software.\nNumerical argument out of domain."
            
        case .ERANGE:
            return "Result too large."
            
        case .EAGAIN:
            return "non-blocking and interrupt i/o.\nResource temporarily unavailable."
            
        case .EINPROGRESS:
            return "Operation now in progress."
            
        case .EALREADY:
            return "Operation already in progress."
            
        case .ENOTSOCK:
            return "ipc/network software -- argument errors.\nSocket operation on non-socket."
            
        case .EDESTADDRREQ:
            return "Destination address required."
            
        case .EMSGSIZE:
            return "Message too long."
            
        case .EPROTOTYPE:
            return "Protocol wrong type for socket."
            
        case .ENOPROTOOPT:
            return "Protocol not available."
            
        case .EPROTONOSUPPORT:
            return "Protocol not supported."
            
        case .ESOCKTNOSUPPORT:
            return "Socket type not supported."
            
        case .ENOTSUP:
            return "Operation not supported."
            
        case .EPFNOSUPPORT:
            return "Protocol family not supported."
            
        case .EAFNOSUPPORT:
            return "Address family not supported by protocol family."
            
        case .EADDRINUSE:
            return "Address already in use."
            
        case .EADDRNOTAVAIL:
            return "Can't assign requested address."
            
        case .ENETDOWN:
            return "ipc/network software -- operational errors\nNetwork is down."
            
        case .ENETUNREACH:
            return "Network is unreachable."
            
        case .ENETRESET:
            return "Network dropped connection on reset."
            
        case .ECONNABORTED:
            return "Software caused connection abort."
            
        case .ECONNRESET:
            return "Connection reset by peer."
            
        case .ENOBUFS:
            return "No buffer space available."
            
        case .EISCONN:
            return "Socket is already connected."
            
        case .ENOTCONN:
            return "Socket is not connected."
            
        case .ESHUTDOWN:
            return "Can't send after socket shutdown."
            
        case .ETOOMANYREFS:
            return "Too many references: can't splice."
            
        case .ETIMEDOUT:
            return "Operation timed out."
            
        case .ECONNREFUSED:
            return "Connection refused."
            
        case .ELOOP:
            return "Too many levels of symbolic links."
            
        case .ENAMETOOLONG:
            return "File name too long."
            
        case .EHOSTDOWN:
            return "Host is down."
            
        case .EHOSTUNREACH:
            return "No route to host."
            
        case .ENOTEMPTY:
            return "Directory not empty."
            
        case .EPROCLIM:
            return "quotas & mush.\nToo many processes."
            
        case .EUSERS:
            return "Too many users."
            
        case .EDQUOT:
            return "Disc quota exceeded."
            
        case .ESTALE:
            return "Network File System.\nStale NFS file handle."
            
        case .EREMOTE:
            return "Too many levels of remote in path."
            
        case .EBADRPC:
            return "RPC struct is bad."
            
        case .ERPCMISMATCH:
            return "RPC version wrong."
            
        case .EPROGUNAVAIL:
            return "RPC prog.\n not avail."
            
        case .EPROGMISMATCH:
            return "Program version wrong."
            
        case .EPROCUNAVAIL:
            return "Bad procedure for program."
            
        case .ENOLCK:
            return "No locks available."
            
        case .ENOSYS:
            return "Function not implemented."
            
        case .EFTYPE:
            return "Inappropriate file type or format."
            
        case .EAUTH:
            return "Authentication error."
            
        case .ENEEDAUTH:
            return "Need authenticator."
            
        case .EPWROFF:
            return "Intelligent device errors.\nDevice power is off."
            
        case .EDEVERR:
            return "Device error, e.g. paper out."
            
        case .EOVERFLOW:
            return "Value too large to be stored in data type."
            
        case .EBADEXEC:
            return "Bad executable."
            
        case .EBADARCH:
            return "Bad CPU type in executable."
            
        case .ESHLIBVERS:
            return "Shared library version mismatch."
            
        case .EBADMACHO:
            return "Malformed Macho file."
            
        case .ECANCELED:
            return "Operation canceled."
            
        case .EIDRM:
            return "Identifier removed."
            
        case .ENOMSG:
            return "No message of desired type."
            
        case .EILSEQ:
            return "Illegal byte sequence."
            
        case .ENOATTR:
            return "Attribute not found."
            
        case .EBADMSG:
            return "Bad message."
            
        case .EMULTIHOP:
            return "Reserved."
            
        case .ENODATA:
            return "No message available on STREAM."
            
        case .ENOLINK:
            return "Reserved."
            
        case .ENOSR:
            return "No STREAM resources."
            
        case .ENOSTR:
            return "Not a STREAM."
            
        case .EPROTO:
            return "Protocol error."
            
        case .ETIME:
            return "STREAM ioctl timeout."
            
        case .ENOPOLICY:
            return "No such policy registered."
            
        case .ENOTRECOVERABLE:
            return "State not recoverable."
            
        case .EOWNERDEAD:
            return "Previous owner died."
            
        case .EQFULL:
            return "Interface output queue is full."
        }
    }
}

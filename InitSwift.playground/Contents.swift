final class Object {}

extension Object: ExpressibleByNilLiteral {
    convenience init(nilLiteral: ()) {
        print("nil")
        self.init()
    }
}
extension Object: ExpressibleByFloatLiteral {
    convenience init(floatLiteral value: FloatLiteralType) {
        print(value)
        self.init()
    }
}
extension Object: ExpressibleByIntegerLiteral {
    convenience init(integerLiteral value: IntegerLiteralType) {
        print(value)
        self.init()
    }
}
extension Object: ExpressibleByBooleanLiteral {
    convenience init(booleanLiteral value: BooleanLiteralType) {
        print(value)
        self.init()
    }
}
extension Object: ExpressibleByArrayLiteral {
    /// or 1
    //typealias ArrayLiteralElement = Int
    //convenience init(arrayLiteral elements: ArrayLiteralElement...) {
    //    self.init()
    //}
    
    /// or 2
    /// will call "convenience init(integerLiteral value: IntegerLiteralType)"
    convenience init(arrayLiteral elements: Int...) {
        print(elements)
        self.init()
    }
}
extension Object: ExpressibleByStringLiteral {
    typealias StringLiteralType = String
    
    convenience init(stringLiteral value: StringLiteralType) {
        print(value)
        self.init()
    }
}
extension Object: ExpressibleByDictionaryLiteral {
    typealias Key = String
    typealias Value = Int
    
    convenience init(dictionaryLiteral elements: (Key, Value)...) {
        print(elements)
        self.init()
    }
}

//protocol ExpressibleByUnicodeScalarLiteral
//protocol ExpressibleByExtendedGraphemeClusterLiteral
/// there is no SetLiteral //let someObject: Object = Set(arrayLiteral: 1, 2, 3)

let someObject0: Object = nil
let someObject1: Object = 1.1
let someObject2: Object = 1
let someObject3: Object = true
let someObject4_1: [Object] = [1, 2, 3]
let someObject4_2: Object = [1, 2, 3]
let someObject5: Object = "qwerty"
let someObject6_1: Object = ["someKey": 0]
let someObject6_2: [Object] = [["someKey1": 1], ["someKey2": 2]]
let someObject6_3: Object = ["someKey3": 3, "someKey4": 4]

enum Food {
    case beef
    case broccoli
    case chicken
    case greenPepper
    case lettuce
    case onion
    case redPepper
    case spinach
    case artichoke
    case cabbage
    case celery
    case kale
    case radish
    case squash
    case parsley
    case yellowPepper
    
    func isVegetable() -> Bool {
        return self == .broccoli ||
            self == .greenPepper ||
            self == .lettuce ||
            self == .onion ||
            self == .redPepper ||
            self == .spinach ||
            self == .artichoke ||
            self == .cabbage ||
            self == .celery ||
            self == .kale ||
            self == .radish ||
            self == .squash ||
            self == .parsley ||
            self == .yellowPepper
    }
    
    func isVegetableSwitch() -> Bool {
        switch self {
        case .broccoli, .greenPepper, .lettuce, .onion, .redPepper, .spinach, .artichoke, .cabbage, .celery, .kale, .radish, .squash, .parsley, .yellowPepper:
            return true
        case .beef, .chicken:
            return false
        }
    }

}

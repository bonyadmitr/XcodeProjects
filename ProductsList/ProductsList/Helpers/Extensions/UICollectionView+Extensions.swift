import UIKit

// MARK: - register nib

extension UICollectionView {
    
    func registerNibCell<T: UICollectionViewCell>(_ identifier: T.Type) {
        let identifierString = String(describing: identifier)
        let nib = UINib(nibName: identifierString, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifierString)
    }
    
    func registerNibHeader<T: UICollectionReusableView>(_ identifier: T.Type) {
        register(nibSupplementaryView: identifier, kind: UICollectionView.elementKindSectionHeader)
    }
    
    func registerNibFooter<T: UICollectionReusableView>(_ identifier: T.Type) {
        register(nibSupplementaryView: identifier, kind: UICollectionView.elementKindSectionFooter)
    }
    
    private func register<T: UICollectionReusableView>(nibSupplementaryView identifier: T.Type, kind: String) {
        let identifierString = String(describing: identifier)
        let nib = UINib(nibName: identifierString, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifierString)
    }
}

// MARK: - register cell

extension UICollectionView {
    
    func registerHeader<T: UICollectionReusableView>(_ identifier: T.Type) {
        register(supplementaryView: identifier, kind: UICollectionView.elementKindSectionHeader)
    }
    
    func registerFooter<T: UICollectionReusableView>(_ identifier: T.Type) {
        register(supplementaryView: identifier, kind: UICollectionView.elementKindSectionFooter)
    }
    
    private func register<T: UICollectionReusableView>(supplementaryView identifier: T.Type, kind: String) {
        let identifierString = String(describing: identifier)
        register(identifier, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifierString)
    }
}

// MARK: - dequeue

extension UICollectionView {
    
    func dequeue <T: UICollectionViewCell>(cell identifier: T.Type, for indexPath: IndexPath) -> T? {
        let identifierString = String(describing: identifier)
        return dequeueReusableCell(withReuseIdentifier: identifierString, for: indexPath) as? T
    }
    
    func dequeue <T: UICollectionReusableView>(supplementaryView identifier: T.Type, kind: String, for indexPath: IndexPath) -> T? {
        let identifierString = String(describing: identifier)
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierString, for: indexPath) as? T
    }
}

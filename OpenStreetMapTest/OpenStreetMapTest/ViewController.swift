import UIKit
import MapKit

class ViewController: UIViewController {
    
    let mapView = OSMMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.bounds
        view.addSubview(mapView)
        
        
        
    }


}

/**
 Custom Tiles https://www.raywenderlich.com/9697133-advanced-mapkit-tutorial-custom-mapkit-tiles
 cache map tiles https://github.com/merlos/MapCache
 app example https://github.com/merlos/iOS-Open-GPX-Tracker
 GPX location files https://github.com/vincentneo/CoreGPX
 */
final class OSMMapView: MKMapView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        let template = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
        let overlay = MKTileOverlay(urlTemplate: template)
        overlay.canReplaceMapContent = true
        addOverlay(overlay, level: .aboveLabels)
        //let tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
        delegate = self
        
    }
    
}

extension OSMMapView: MKMapViewDelegate {
    
    /// called once
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKTileOverlay.self) {
            return MKTileOverlayRenderer(overlay: overlay)
        } else {
            assertionFailure()
            return MKOverlayRenderer()
        }
    }
}

import UIKit

import Foundation
import Metal
import MetalPerformanceShaders
import MetalKit

class ViewController: UIViewController {}

/// for macOS
/// http://metalkit.org/
/// https://github.com/MetalKit/metal
/// https://github.com/MetalKit/metal/blob/master/ch08/chapter08.playground/Sources/MetalView.swift
///
/// game https://github.com/hollance/pumpkin
///
/// MTKView, Camera, MetalKit
/// https://navoshta.com/metal-camera-part-1-camera-session/
/// https://www.raywenderlich.com/5493-metal-rendering-pipeline-tutorial
/// https://www.clientresourcesinc.com/2018/07/27/rendering-graphics-with-metalkit-swift-4-part-2/
/// https://stackoverflow.com/questions/33844130/take-a-snapshot-of-current-screen-with-metal-in-swift
///
/// http://metalbyexample.com/up-and-running-1/
/// https://www.raywenderlich.com/7475-metal-tutorial-getting-started
/// https://github.com/BradLarson/GPUImage3
/// https://weblog.jamisbuck.org/2016/2/27/bloom-effect-in-metal.html
final class MetalView: UIView {
    
    override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }
    
    private lazy var metalLayer: CAMetalLayer = {
        if let layer = self.layer as? CAMetalLayer {
            return layer
        } else {
            assertionFailure("override func loadView")
            return CAMetalLayer()
        }
    }()
    
    private let device = MTLCreateSystemDefaultDevice()!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        //metalLayer.framebufferOnly = true
        
        timer = CADisplayLink(target: self, selector: #selector(gameloop))
        timer.add(to: RunLoop.main, forMode: .default)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
    
    @objc private func gameloop() {
        autoreleasepool {
            self.render()
        }
    }
    
    private lazy var commandQueue = device.makeCommandQueue()!
    
    private var timer: CADisplayLink!
    
    private func render() {
        let color = (timer.timestamp * 100).truncatingRemainder(dividingBy: 255)
        
        guard let drawable = metalLayer.nextDrawable() else {
            assertionFailure()
            return
        }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: color, green: color/255.0, blue: 255.0 - color, alpha: 1.0)
        //renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

//import UIKit
//import Metal
//
///// https://www.raywenderlich.com/7475-metal-tutorial-getting-started
//class ViewController: UIViewController {
//    let vertexData:[Float] =
//        [0.0, 1.0, 0.0,
//         -1.0, -1.0, 0.0,
//         1.0, -1.0, 0.0]
//
//    var device: MTLDevice!
//    var metalLayer: CAMetalLayer!
//    var vertexBuffer: MTLBuffer!
//    var pipelineState: MTLRenderPipelineState!
//    var commandQueue: MTLCommandQueue!
//    var timer: CADisplayLink!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        device = MTLCreateSystemDefaultDevice()
//
//        metalLayer = CAMetalLayer()          // 1
//        metalLayer.device = device           // 2
//        metalLayer.pixelFormat = .bgra8Unorm // 3
//        metalLayer.framebufferOnly = true    // 4
//        metalLayer.frame = view.layer.frame  // 5
//        view.layer.addSublayer(metalLayer)   // 6
//
//        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 1
//        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 2
//
//        // 1
//        let defaultLibrary = device.makeDefaultLibrary()!
//        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
//        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
//
//        // 2
//        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
//        pipelineStateDescriptor.vertexFunction = vertexProgram
//        pipelineStateDescriptor.fragmentFunction = fragmentProgram
//        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
//
//        // 3
//        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
//
//        commandQueue = device.makeCommandQueue()
//
//        timer = CADisplayLink(target: self, selector: #selector(gameloop))
//        timer.add(to: RunLoop.main, forMode: .default)
//    }
//
//    func render() {
//        guard let drawable = metalLayer?.nextDrawable() else { return }
//        let renderPassDescriptor = MTLRenderPassDescriptor()
//        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
//        renderPassDescriptor.colorAttachments[0].loadAction = .clear
//        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
//
//        let commandBuffer = commandQueue.makeCommandBuffer()!
//        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
//        renderEncoder.setRenderPipelineState(pipelineState)
//        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
//        renderEncoder.endEncoding()
//
//        commandBuffer.present(drawable)
//        commandBuffer.commit()
//    }
//
//    @objc func gameloop() {
//        autoreleasepool {
//            self.render()
//        }
//    }
//}













//#if targetEnvironment(simulator)
//class ViewController: UIViewController {}
//#else
//
//class ViewController: UIViewController {
//
//    var timer: CADisplayLink!
//
//    private let metalLayer: CAMetalLayer = {
//        let metalLayer = CAMetalLayer()
//        metalLayer.device = sharedMetalRenderingDevice.device
//        metalLayer.pixelFormat = .bgra8Unorm
//        metalLayer.framebufferOnly = true
//        return metalLayer
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
//        view.backgroundColor = UIColor.magenta
//        view.layer.addSublayer(metalLayer)
//
//
//        timer = CADisplayLink(target: self, selector: #selector(gameloop))
//        timer.add(to: RunLoop.main, forMode: .default)
//
//
//
//
//
//        //let texture: MTLTexture = textureLoader.newTextureWithContentsOfURL(filePath, options: nil)
//
//
//    }
//
//    let image = UIImage.circle(diameter: 100, color: UIColor.cyan).cgImage!
//
//    let textureLoader = MTKTextureLoader(device: sharedMetalRenderingDevice.device)
//    lazy var texture = try! textureLoader.newTexture(cgImage: image, options: nil)
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        metalLayer.frame = view.layer.frame
//    }
//
//    @objc func gameloop() {
//        autoreleasepool {
//            self.render()
//        }
//    }
//
//    func render() {
//        myBlurTextureInPlace(metalLayer: metalLayer, inTexture: texture, blurRadius: 10, queue: sharedMetalRenderingDevice.commandQueue)
//
//    }
//
//
//}
//#endif
//
//
//public let sharedMetalRenderingDevice = MetalRenderingDevice()
//
//public class MetalRenderingDevice {
//    // MTLDevice
//    // MTLCommandQueue
//
//    public let device: MTLDevice
//    public let commandQueue: MTLCommandQueue
//    public let shaderLibrary: MTLLibrary
//    public let metalPerformanceShadersAreSupported: Bool
//
//    lazy var passthroughRenderState: MTLRenderPipelineState = {
//        let (pipelineState, _) = generateRenderPipelineState(device:self, vertexFunctionName:"oneInputVertex", fragmentFunctionName:"passthroughFragment", operationName:"Passthrough")
//        return pipelineState
//    }()
//
//    lazy var colorSwizzleRenderState: MTLRenderPipelineState = {
//        let (pipelineState, _) = generateRenderPipelineState(device:self, vertexFunctionName:"oneInputVertex", fragmentFunctionName:"colorSwizzleFragment", operationName:"ColorSwizzle")
//        return pipelineState
//    }()
//
//    init() {
//
//        guard let device = MTLCreateSystemDefaultDevice() else {fatalError("Could not create Metal Device")}
//        self.device = device
//
//        guard let queue = self.device.makeCommandQueue() else {fatalError("Could not create command queue")}
//        self.commandQueue = queue
//
//        if #available(iOS 9, macOS 10.13, *) {
//            self.metalPerformanceShadersAreSupported = MPSSupportsMTLDevice(device)
//        } else {
//            self.metalPerformanceShadersAreSupported = false
//        }
//
//        self.shaderLibrary = device.makeDefaultLibrary()!
////        do {
////            let frameworkBundle = Bundle(for: MetalRenderingDevice.self)
////            let metalLibraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!
////
////            self.shaderLibrary = try device.makeLibrary(filepath:metalLibraryPath)
////
////
////        } catch {
////            fatalError("Could not load library")
////        }
//    }
//}
//
//func generateRenderPipelineState(device:MetalRenderingDevice, vertexFunctionName:String, fragmentFunctionName:String, operationName:String) -> (MTLRenderPipelineState, [String:(Int, MTLDataType)]) {
//    guard let vertexFunction = device.shaderLibrary.makeFunction(name: vertexFunctionName) else {
//        fatalError("\(operationName): could not compile vertex function \(vertexFunctionName)")
//    }
//
//    guard let fragmentFunction = device.shaderLibrary.makeFunction(name: fragmentFunctionName) else {
//        fatalError("\(operationName): could not compile fragment function \(fragmentFunctionName)")
//    }
//
//    let descriptor = MTLRenderPipelineDescriptor()
//    descriptor.colorAttachments[0].pixelFormat = MTLPixelFormat.bgra8Unorm
//    descriptor.rasterSampleCount = 1
//    descriptor.vertexFunction = vertexFunction
//    descriptor.fragmentFunction = fragmentFunction
//
//    do {
//        var reflection:MTLAutoreleasedRenderPipelineReflection?
//        let pipelineState = try device.device.makeRenderPipelineState(descriptor: descriptor, options: [.bufferTypeInfo, .argumentInfo], reflection: &reflection)
//
//        var uniformLookupTable:[String:(Int, MTLDataType)] = [:]
//        if let fragmentArguments = reflection?.fragmentArguments {
//            for fragmentArgument in fragmentArguments where fragmentArgument.type == .buffer {
//                if (fragmentArgument.bufferDataType == .struct) {
//                    for (index, uniform) in fragmentArgument.bufferStructType!.members.enumerated() {
//                        uniformLookupTable[uniform.name] = (index, uniform.dataType)
//                    }
//                }
//            }
//        }
//
//        return (pipelineState, uniformLookupTable)
//    } catch {
//        fatalError("Could not create render pipeline state for vertex:\(vertexFunctionName), fragment:\(fragmentFunctionName), error:\(error)")
//    }
//}
//
//let myAllocator: MPSCopyAllocator = {
//    (kernel: MPSKernel, buffer: MTLCommandBuffer, texture: MTLTexture) -> MTLTexture in
//
//    let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: texture.pixelFormat,
//                                                              width: texture.width,
//                                                              height: texture.height,
//                                                              mipmapped: false)
//
//    return buffer.device.makeTexture(descriptor: descriptor)!
//}
//
//
///// https://developer.apple.com/documentation/metalperformanceshaders/image_filters
//func myBlurTextureInPlace(metalLayer: CAMetalLayer, inTexture: MTLTexture, blurRadius: Float, queue: MTLCommandQueue) {
//    guard let drawable = metalLayer.nextDrawable() else { return }
//    let renderPassDescriptor = MTLRenderPassDescriptor()
//    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
//    renderPassDescriptor.colorAttachments[0].loadAction = .clear
//    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
//        red: 0.0,
//        green: 104.0/255.0,
//        blue: 55.0/255.0,
//        alpha: 1.0)
//
//
//    // Create the usual Metal objects.
//    // MPS does not need a dedicated MTLCommandBuffer or MTLComputeCommandEncoder.
//    // This is a trivial example. You should reuse the MTL objects you already have, if you have them.
//    let device = queue.device;
//    let buffer = queue.makeCommandBuffer()!
//
//    // Create a MPS filter.
//    let blur = MPSImageGaussianBlur(device: device, sigma: blurRadius)
//
//    // Defaults are okay here for other MPSKernel properties (clipRect, origin, edgeMode).
//
//    // Attempt to do the work in place.  Since we provided a copyAllocator as an out-of-place
//    // fallback, we don’t need to check to see if it succeeded or not.
//    // See the "Minimal MPSCopyAllocator Implementation" code listing for a sample myAllocator.
//    let inPlaceTexture = UnsafeMutablePointer<MTLTexture>.allocate(capacity: 1)
//    inPlaceTexture.initialize(to: inTexture)
//
//    blur.encode(commandBuffer: buffer,
//                inPlaceTexture: inPlaceTexture,
//                fallbackCopyAllocator: myAllocator)
//
//    // The usual Metal enqueue process.
//    buffer.present(drawable)
//    buffer.commit()
//    buffer.waitUntilCompleted()
//}
//
//
//
///// https://stackoverflow.com/a/40561499/5893286
//extension UIImage {
//    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
//        let ctx = UIGraphicsGetCurrentContext()!
//        ctx.saveGState()
//
//        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
//        ctx.setFillColor(color.cgColor)
//        ctx.fillEllipse(in: rect)
//
//        ctx.restoreGState()
//        let img = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        return img
//    }
//}

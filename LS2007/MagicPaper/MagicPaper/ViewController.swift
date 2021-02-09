//
//  ViewController.swift
//  MagicPaper
//
//  Created by punky on 2020/06/29.
//  Copyright © 2020 punky. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewsPagerImages", bundle: Bundle.main) {
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            // Create a SKVideoNode
            let videoNode = SKVideoNode(fileNamed: "HarryPotter.mp4")
            videoNode.play()
            
            // Create a SKScene
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            
            // Adjust the video position
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            
            // Reverse the video 
            videoNode.yScale = -1.0
            
            // Add videoNode to videoScene
            videoScene.addChild(videoNode)
            
            // Create a SCNPlane
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
//            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            plane.firstMaterial?.diffuse.contents = videoScene
            
            // Create a SCNNode
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2
            
            // Add planeNode to node
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
}

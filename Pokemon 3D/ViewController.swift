//
//  ViewController.swift
//  Pokemon 3D
//
//  Created by Nayan Khadase on 15/12/21.
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

        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Card", bundle: Bundle.main){
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
            print("successful..")
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
        
        if let imageAnchor = anchor as? ARImageAnchor{
            //create the plane with size of the physical size of the reference image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // color / material to the material
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            // create node and apply the geometry at that node
            let imageNode = SCNNode(geometry: plane)
            // make plane parallel to the image plane
            imageNode.eulerAngles.x = -.pi/2
           // add node
            node.addChildNode(imageNode)
            
            if let pokiScene = SCNScene(named: "art.scnassets/eevee.scn"){
                if let pokiNode = pokiScene.rootNode.childNodes.first{
                    pokiNode.eulerAngles.x = .pi/2
                    imageNode.addChildNode(pokiNode)
                }
            }
            
            
        }
        return node
    }
}

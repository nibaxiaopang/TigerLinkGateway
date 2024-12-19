//
//  ThirdGame.swift
//  TigerLink Gateway
//
//  Created by TigerLink Gateway on 2024/12/19.
//


import UIKit

class TigerLinkThirdGameController: UIViewController {

    // MARK: - Outlets for Sticks
        @IBOutlet weak var stick1: UIImageView!
        @IBOutlet weak var stick2: UIImageView!
        @IBOutlet weak var stick3: UIImageView!
        @IBOutlet weak var stick4: UIImageView!
        @IBOutlet weak var stick5view   : UIView!
        
        // MARK: - Outlets for Buttons and Labels
        @IBOutlet weak var checkButton: UIButton!
        @IBOutlet weak var timerLabel: UILabel!
        @IBOutlet weak var progressLabel: UILabel!

    
    // MARK: - Variables
    var targetFrames: [CGRect] = []
    var sticks: [UIImageView] = []
    var timer: Timer?
    var timeRemaining = 60  // 60 seconds time limit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize sticks
        sticks = [stick1, stick2, stick3, stick4]
        
        // Capture initial positions
        captureInitialStickPositions()
        
        // Enable drag and rotation
        sticks.forEach { enableDragAndRotate(for: $0) }
        
        // Add green target placeholders
        createTargetMarkers()
        
        // Randomize initial stick positions
        randomizeStickPositions()
        
        // Start countdown timer
        startTimer()
    }
    
    // MARK: - Capture Initial Positions as Targets
    func captureInitialStickPositions() {
        targetFrames = sticks.map { $0.frame }
    }
    
    @IBAction func btnBack(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Create Green Target Markers Near Sticks
    func createTargetMarkers() {
        for (index, stick) in sticks.enumerated() {
            let stickFrame = stick.frame // Get the size and position of each stick

            // Offset values for positioning markers near the sticks
            let offsetX: CGFloat = stickFrame.width / 2 + 20  // Horizontal offset
            let offsetY: CGFloat = stickFrame.height / 2 + 20 // Vertical offset

            // Calculate marker position based on index
            var targetPosition = stickFrame.origin
            switch index {
            case 0: // Top-left of stick 1
                targetPosition.x -= offsetX
                targetPosition.y -= offsetY
            case 1: // Top-right of stick 2
                targetPosition.x += offsetX
                targetPosition.y -= offsetY
            case 2: // Bottom-left of stick 3
                targetPosition.x -= offsetX
                targetPosition.y += offsetY
            case 3: // Bottom-right of stick 4
                targetPosition.x += offsetX
                targetPosition.y += offsetY
            default:
                break
            }

            // Create a UIView marker with the same size as the stick
            let marker = UIView(frame: CGRect(origin: targetPosition, size: stickFrame.size))
            marker.backgroundColor = UIColor.green.withAlphaComponent(0.3) // Translucent green background
            marker.layer.cornerRadius = stick.layer.cornerRadius // Match stick's corner radius
            marker.layer.borderColor = UIColor.green.cgColor
            marker.layer.borderWidth = 2

            // Add marker to the view and send it behind the sticks
            view.addSubview(marker)
            view.sendSubviewToBack(marker)
        }
    }
    
    // MARK: - Enable Dragging and Rotation on Sticks
    func enableDragAndRotate(for stick: UIImageView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        stick.isUserInteractionEnabled = true
        stick.addGestureRecognizer(panGesture)
        stick.addGestureRecognizer(rotationGesture)
    }
    
    @objc func handleDrag(_ gesture: UIPanGestureRecognizer) {
        guard let stick = gesture.view else { return }
        let translation = gesture.translation(in: view)
        
        if gesture.state == .changed {
            stick.center = CGPoint(x: stick.center.x + translation.x, y: stick.center.y + translation.y)
            gesture.setTranslation(.zero, in: view)
        }
    }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let stick = gesture.view else { return }
        
        if gesture.state == .changed || gesture.state == .ended {
            stick.transform = stick.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }
    
    // MARK: - Randomize Stick Positions
    func randomizeStickPositions() {
        let maxX = view.frame.width - 100
        let maxY = view.frame.height - 100
        
        for stick in sticks {
            let randomX = CGFloat.random(in: 50...maxX)
            let randomY = CGFloat.random(in: 50...maxY)
            UIView.animate(withDuration: 0.5) {
                stick.frame.origin = CGPoint(x: randomX, y: randomY)
                stick.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0...CGFloat.pi))
            }
        }
    }
    
    // MARK: - Start Countdown Timer
    func startTimer() {
        timerLabel.text = "Time: \(timeRemaining)s"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.timerLabel.text = "Time: \(self.timeRemaining)s"
            
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.showAlert(title: "Time's Up!", message: "You ran out of time!")
            }
        }
    }
    
    // MARK: - Check Puzzle Solution
    @IBAction func checkSolution(_ sender: UIButton) {
        var allCorrect = true
        
        for (index, stick) in sticks.enumerated() {
            let targetFrame = targetFrames[index]
            
            // Check position and rotation accuracy
            if abs(stick.frame.origin.x - targetFrame.origin.x) <= 20 &&
               abs(stick.frame.origin.y - targetFrame.origin.y) <= 20 &&
               abs(stick.transform.rotationAngle) <= 0.2 {
                stick.layer.borderColor = UIColor.green.cgColor // Highlight green
                stick.layer.borderWidth = 5
            } else {
                stick.layer.borderColor = UIColor.clear.cgColor // Remove highlight
                stick.layer.borderWidth = 0
                allCorrect = false
            }
        }
        
        if allCorrect {
            timer?.invalidate()
            showAlert(title: "Success!", message: "You perfectly aligned all the sticks!")
        } else {
            updateProgress()
            showAlert(title: "Not Yet", message: "Keep trying, some sticks are not in position.")
        }
    }
    
    // MARK: - Update Progress
    func updateProgress() {
        let correctlyPlaced = sticks.enumerated().filter { (index, stick) in
            let targetFrame = targetFrames[index]
            return abs(stick.frame.origin.x - targetFrame.origin.x) <= 20 &&
                   abs(stick.frame.origin.y - targetFrame.origin.y) <= 20 &&
                   abs(stick.transform.rotationAngle) <= 0.2
        }.count
        
        progressLabel.text = "Progress: \(correctlyPlaced)/\(sticks.count)"
    }
    
    // MARK: - Show Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

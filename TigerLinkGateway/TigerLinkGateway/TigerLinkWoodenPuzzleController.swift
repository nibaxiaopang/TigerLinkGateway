//
//  WoodenPuzzleGameViewController.swift
//  TigerLink Gateway
//
//  Created by TigerLink Gateway on 2024/12/19.
//


import UIKit

class TigerLinkWoodenPuzzleController: UIViewController {
    
    // Outlets
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var gameBoard: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // Game Data
    var currentLevel = 1
    var gameProgress: Float = 0.0
    var isGameOver = false
    var timer: Timer?
    var timeRemaining = 20 // 20 seconds per level
    var obstacles: [String] = []
    var bonusItem = "goldenNut"
    var tasks = [
        "Solve the wooden stack puzzle",
        "Untangle bolts and nuts",
        "Unlock the secrets within the wood",
        "Overcome plumber crack obstacles",
        "Outsmart wood wasps",
        "Avoid the whimsical squirrel nuts",
        "Discover the hidden treasure"
    ]
    var completedTasks: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        setupCollectionView()
    }
    
    // Initialize the Game
    func setupGame() {
        currentLevel = 1
        gameProgress = 0.0
        completedTasks = []
        isGameOver = false
        timeRemaining = 20
        generateObstacles()
        updateGameStatus()
        progressView.progress = gameProgress
        startTimer()
    }
    
    func setupCollectionView() {
        gameBoard.delegate = self
        gameBoard.dataSource = self
        gameBoard.register(UINib(nibName: "PuzzleTileCell", bundle: nil), forCellWithReuseIdentifier: "PuzzleTileCell")
    }
    
    func generateObstacles() {
        // Randomly generate obstacles for the current level
        let obstacleTypes = ["bolt", "nut", "wood", "wasp", "crack", "squirrel"]
        let numberOfObstacles = Int.random(in: 3...8)
        obstacles = (0..<numberOfObstacles).map { _ in
            Int.random(in: 1...10) == 1 ? bonusItem : obstacleTypes.randomElement()!
        }
    }
    
    func updateGameStatus() {
        if isGameOver {
            gameStatusLabel.text = "Game Over! You reached level \(currentLevel)."
        } else if completedTasks.count == tasks.count {
            gameStatusLabel.text = "Congratulations! You completed all levels!"
            isGameOver = true
        } else {
            gameStatusLabel.text = "Level \(currentLevel): \(tasks[currentLevel - 1])"
            
            // Show alert if it's level 8
            if currentLevel == 8 {
                showGameOverAlert()
            }
        }
    }

    func showGameOverAlert() {
        let alertController = UIAlertController(
            title: "Game Over",
            message: "You've reached Level 8. The game is complete. Great job!",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.restartGame()
        }))
        alertController.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func startTimer() {
        timer?.invalidate()
        timeRemaining = 20 // Reset timer for each level
        timerLabel.text = "Time: \(timeRemaining)s"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async { // Ensure UI update happens on the main thread
                self.timeRemaining -= 1
                self.timerLabel.text = "Time: \(self.timeRemaining)s"
                
                if self.timeRemaining <= 0 {
                    self.timer?.invalidate()
                    self.endGame()
                }
            }
        }
    }
    
    func completeTask() {
        guard !isGameOver else { return }
        
        completedTasks.append(tasks[currentLevel - 1])
        currentLevel += 1
        gameProgress += 1.0 / Float(tasks.count)
        progressView.setProgress(gameProgress, animated: true)
        
        if currentLevel > tasks.count {
            isGameOver = true
            updateGameStatus()
        } else {
            generateObstacles()
            updateGameStatus()
            startTimer()
            gameBoard.reloadData()
        }
    }
    
    @IBAction func btnBack(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func endGame() {
        isGameOver = true
        timer?.invalidate()
        gameStatusLabel.text = "Game Over! Tap to restart."
    }
    
    func restartGame() {
        setupGame()
    }
    
    // Handle obstacle interaction
    func handleObstacleTap(at index: Int) {
        let tappedObstacle = obstacles[index]
        
        if tappedObstacle == bonusItem {
            gameStatusLabel.text = "Bonus! Skipping this level!"
            completeTask()
        } else {
            obstacles.remove(at: index)
            gameBoard.reloadData()
            
            if obstacles.isEmpty {
                gameStatusLabel.text = "Level \(currentLevel) completed!"
                completeTask()
            }
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension TigerLinkWoodenPuzzleController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return obstacles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleTileCell", for: indexPath) as! PuzzleTileCell
        let obstacle = obstacles[indexPath.row]
        
        cell.cellbg.image = UIImage(named: "ic_cellbg")
        cell.cellTile.image = UIImage(named: obstacle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleObstacleTap(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

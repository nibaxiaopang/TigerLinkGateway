//
//  TileMatchingGameViewController.swift
//  TigerLink Gateway
//
//  Created by jin fu on 2024/12/19.
//


import UIKit

class TigerLinkTileMatchingController: UIViewController {
    
    // Outlets
    @IBOutlet weak var puzzleBoard: UICollectionView!
    @IBOutlet weak var selectedBoard: UICollectionView!
    @IBOutlet weak var gameStatusLabel: UILabel!
    
    // Data models
    var puzzleTiles: [String] = []
    var selectedTiles: [String] = []
    var tileImages = ["tile1", "tile2", "tile3", "tile4", "tile5","tile6", "tile7", "tile8", "tile9", "tile10","tile11", "tile12", "tile13", "tile14", "tile15","tile16", "tile17"]
    var isGameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        setupCollectionView()
    }
    
    func setupGame() {
        // Initialize the game board with random tiles
        puzzleTiles = (0..<36).map { _ in tileImages.randomElement()! }
        selectedTiles = []
        isGameOver = false
        gameStatusLabel.text = "Match 3 tiles to clear!"
        puzzleBoard.reloadData()
        selectedBoard.reloadData()
    }
    
    func setupCollectionView() {
        puzzleBoard.delegate = self
        puzzleBoard.dataSource = self
        puzzleBoard.register(UINib(nibName: "PuzzleTileCell", bundle: nil), forCellWithReuseIdentifier: "PuzzleTileCell")
        
        selectedBoard.delegate = self
        selectedBoard.dataSource = self
        selectedBoard.register(UINib(nibName: "PuzzleTileCell", bundle: nil), forCellWithReuseIdentifier: "PuzzleTileCell")
    }
    
    func selectTile(at indexPath: IndexPath) {
        // If the game is over, prevent further actions
        guard !isGameOver else { return }
        
        // Get the selected tile
        let selectedTile = puzzleTiles[indexPath.row]
        
        // Ensure the tile is not empty
        guard !selectedTile.isEmpty else {
            gameStatusLabel.text = "This tile is already empty."
            return
        }
        
        // Check if the selected board is full
        guard selectedTiles.count < 7 else {
            endGame()
            return
        }
        
        // Add the selected tile to the selected board
        selectedTiles.append(selectedTile)
        puzzleTiles[indexPath.row] = "" // Remove the tile from the puzzle board
        puzzleTiles.remove(at: indexPath.row)
        // Check for matches
        checkForMatchingTiles()
        
        // Reload the puzzle and selected boards
        puzzleBoard.reloadData()
        selectedBoard.reloadData()
    }
    
    @IBAction func btnBack(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkForMatchingTiles() {
        // Count the occurrences of each tile
        let tileCounts = Dictionary(selectedTiles.map { ($0, 1) }, uniquingKeysWith: +)
        
        // Remove tiles that match 3 or more
        for (tile, count) in tileCounts where count >= 3 {
            selectedTiles.removeAll { $0 == tile }
            gameStatusLabel.text = "Matched 3 \(tile)s! Keep going!"
        }
    }
    
    func endGame() {
        isGameOver = true
        gameStatusLabel.text = "Game Over! Tap to restart."
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        // Restart the game when the player taps the restart button
        setupGame()
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension TigerLinkTileMatchingController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == puzzleBoard {
            return puzzleTiles.count
        } else if collectionView == selectedBoard {
            return selectedTiles.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == puzzleBoard {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleTileCell", for: indexPath) as! PuzzleTileCell
            let tile = puzzleTiles[indexPath.row]
            cell.cellbg.image = UIImage(named: "ic_cellbg")
            cell.cellTile.image = tile.isEmpty ? nil : UIImage(named: tile)
            return cell
        } else if collectionView == selectedBoard {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleTileCell", for: indexPath) as! PuzzleTileCell
            let tile = selectedTiles[indexPath.row]
            cell.cellbg.image = UIImage(named: "ic_cellbg")
            cell.cellTile.image = UIImage(named: tile)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == puzzleBoard {
            selectTile(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == puzzleBoard {
            return CGSize(width: puzzleBoard.bounds.width / 3 - 8, height: 120)
        } else {
            return CGSize(width: 120, height: 120)
        }
        
    }
    
}

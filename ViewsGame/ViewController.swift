//
//  ViewController.swift
//  ViewsGame
//
//  Created by Sergei Isaikin on 28.12.2020.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var gameFieldView: GameFieldView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameControle: GameControlViewClass!
    
    func actionButtonTapped() {
        if gameControle.isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    
    func objectTapped() {
        guard gameControle.isGameActive else { return }
        repositionImageWithTimer()
        score += 1
    }

    
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 2
    private var score = 0
    
    private func startGame() {
        score = 0
        repositionImageWithTimer()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimerTick), userInfo: nil, repeats: true)
        gameControle.gameTimeLeft = gameControle.gameDuration
        gameControle.isGameActive = true
        updateUI()
        scoreLabel.text = "Последний счет: \(score)"
    }
    
    private func stopGame() {
        gameControle.isGameActive = false
        updateUI()
        gameTimer?.invalidate()
        timer?.invalidate()
        scoreLabel.text = "Последний счет: \(score)"
    }
    
    private func repositionImageWithTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: displayDuration, target: self, selector: #selector(moveImage), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !gameControle.isGameActive
        
    }
    
    @objc private func gameTimerTick() {
        gameControle.gameTimeLeft -= 1
        if gameControle.gameTimeLeft <= 0 {
            stopGame()
        } else {
            updateUI()
        }
        
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        updateUI()
        gameFieldView.shapeHithandler = { [weak self] in
            self?.objectTapped()
        }
        gameControle.startStopHandler = { [weak self] in
            self?.actionButtonTapped()
        }
        gameControle.gameDuration = 20
    }


}


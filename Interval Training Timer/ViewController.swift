//
//  ViewController.swift
//  Interval Training Timer
//
//  Created by Jacob Posner on 5/23/20.
//  Copyright © 2020 Kaizen Human Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var activeTimerValue: UILabel!
    @IBOutlet weak var restTimerValue: UILabel!
    @IBOutlet weak var cyclesRemainingLabel: UILabel!
    @IBOutlet weak var workoutControlButton: UIButton!
    
    @IBOutlet weak var restTimerPlusMinus: UIStepper!
    @IBOutlet weak var activeTimerPlusMinus: UIStepper!
    var activeTimerInitialValue = 5
    var restTimerInitialValue = 2
    var seconds = 30
    var cyclesRemaining = 10
    var timerState = "active"
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cyclesRemainingLabel.text = "cycles remaining: " + String(cyclesRemaining)
    }
    @IBAction func activeStepperChanged(_ sender: UIStepper) {
        let newActiveTimerValueAsInt = Int(sender.value)
        let newActiveTimerValueAsString = String(newActiveTimerValueAsInt)
        print("value changed: " + newActiveTimerValueAsString)
        activeTimerValue.text = newActiveTimerValueAsString
        activeTimerInitialValue = newActiveTimerValueAsInt
    }
    
    @IBAction func restStepperChanged(_ sender: UIStepper) {
        let newRestTimerValueAsInt = Int(sender.value)
        let newRestTimerValueAsString = String(newRestTimerValueAsInt)
        print("value changed: " + newRestTimerValueAsString)
        restTimerValue.text = newRestTimerValueAsString
        restTimerInitialValue = newRestTimerValueAsInt
    }
    @IBAction func buttonWasPressed(_ sender: Any) {
        if workoutControlButton.titleLabel?.text == "start workout" {
            startWorkout()
        } else {
            stopWorkout()
        }
    }
    
    func startWorkout() {
        activeLabel.textColor = UIColor.green
        restLabel.textColor = UIColor.white
        
        activeTimerPlusMinus.isHidden = true
        restTimerPlusMinus.isHidden = true
        
        restLabel.font = restLabel.font.withSize(30)
        restTimerValue.font = restTimerValue.font.withSize(60)
        activeTimerValue.text = String(activeTimerInitialValue)
        restTimerValue.text = String(restTimerInitialValue)
        
        seconds = activeTimerInitialValue
        
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self, selector:
            #selector(ViewController.activeCounter),
            userInfo: nil,
            repeats: true)
        
        workoutControlButton.setTitle("stop workout", for: .normal)
        workoutControlButton.setTitleColor(UIColor.red, for: .normal)
    }
    
    func stopWorkout() {
        workoutControlButton.setTitle("start workout", for: .normal)
        workoutControlButton.setTitleColor(UIColor.green, for: .normal)
        resetTimers()
        timer?.invalidate()
        restLabel.font = restLabel.font.withSize(42)
        restTimerValue.font = restTimerValue.font.withSize(100)
        activeLabel.font = activeLabel.font.withSize(42)
        activeTimerValue.font = activeTimerValue.font.withSize(100)
        resetCyclesRemaining()
        timerState = "active"
        activeTimerPlusMinus.isHidden = false
        restTimerPlusMinus.isHidden = false
    }
    
    @objc func activeCounter()
    {
        seconds -= 1
        if seconds == 0 {
            resetTimers()
            swapTimers()
        } else {
            if timerState == "active" {
                activeTimerValue.text = String(seconds)
            } else {
                restTimerValue.text = String(seconds)
            }
        }
    }
    
    func resetTimers() {
        activeTimerValue.text = String(activeTimerInitialValue)
        restTimerValue.text = String(restTimerInitialValue)
        activeLabel.textColor = UIColor.white
        restLabel.textColor = UIColor.white
        seconds = activeTimerInitialValue
    }
    
    func swapTimers() {
        if timerState == "active" {
            timerState = "rest"
            seconds = restTimerInitialValue
            activeLabel.textColor = UIColor.white
            restLabel.textColor = UIColor.green
            activeLabel.font = activeLabel.font.withSize(30)
            activeTimerValue.font = activeTimerValue.font.withSize(60)
            restLabel.font = restLabel.font.withSize(42)
            restTimerValue.font = restTimerValue.font.withSize(100)
        } else {
            timerState = "active"
            seconds = activeTimerInitialValue
            restLabel.textColor = UIColor.white
            activeLabel.textColor = UIColor.green
            restLabel.font = restLabel.font.withSize(30)
            restTimerValue.font = restTimerValue.font.withSize(60)
            activeLabel.font = activeLabel.font.withSize(42)
            activeTimerValue.font = activeTimerValue.font.withSize(100)
            decrementCyclesRemaining()
        }
    }
    
    func decrementCyclesRemaining() {
        cyclesRemaining -= 1
        if cyclesRemaining > 0 {
            cyclesRemainingLabel.text = "cycles remaining: " + String(cyclesRemaining)
        } else {
            stopWorkout()
        }
        
    }
    
    func resetCyclesRemaining() {
        cyclesRemaining = 10
        cyclesRemainingLabel.text = "cycles remaining: " + String(cyclesRemaining)
    }


}


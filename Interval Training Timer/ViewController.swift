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
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var cyclesRemainingLabel: UILabel!
    @IBOutlet weak var workoutControlButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var restTimerPlusMinus: UIStepper!
    @IBOutlet weak var activeTimerPlusMinus: UIStepper!
    @IBOutlet weak var cyclesPlusMinus: UIStepper!
    
    var activeTimerInitialValue = 30.00
    var restTimerInitialValue = 10.00
    var seconds = 30.00
    var cyclesRemaining = 10
    var timerState = "active"
    var totalTime = 0.00
    var timer : Timer?
    var userSelectedCycles : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.isHidden = true
        resetButton.isHidden = true
        activeTimerPlusMinus.value = Double(activeTimerInitialValue)
        restTimerPlusMinus.value = Double(restTimerInitialValue)
        cyclesPlusMinus.value = Double(cyclesRemaining)
        cyclesRemainingLabel.text = String(cyclesRemaining)
    }
    
    //    ====================================================
    //    workout controls
    //    ====================================================
    
    func startWorkout() {
        activeLabel.textColor = UIColor.green
        restLabel.textColor = UIColor.white
        
        activeTimerPlusMinus.isHidden = true
        restTimerPlusMinus.isHidden = true
        cyclesPlusMinus.isHidden = true
        resetButton.isHidden = true
        pauseButton.isHidden = false
        
        activeTimerValue.text =
            String(format: "%04.2f", activeTimerInitialValue)
        restTimerValue.text = String(format: "%04.2f", restTimerInitialValue)
        userSelectedCycles = cyclesPlusMinus.value
        
        seconds = activeTimerInitialValue
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self, selector:
            #selector(ViewController.activeCounter),
            userInfo: nil,
            repeats: true)
        
        workoutControlButton.setTitle("STOP", for: .normal)
        workoutControlButton.backgroundColor = UIColor.red
    }
    
    @IBAction func pauseWorkout(_ sender: Any) {
        if pauseButton.titleLabel?.text == "PAUSE" {
            timer?.invalidate()
            pauseButton.setTitle("RESUME", for: .normal)
            pauseButton.backgroundColor = UIColor.green
        } else {
            resumeWorkout()
        }
    }
    
    func resumeWorkout() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self, selector:
            #selector(ViewController.activeCounter),
            userInfo: nil,
            repeats: true)
        pauseButton.backgroundColor = UIColor.systemOrange
        pauseButton.setTitle("PAUSE", for: .normal)
    }
    
    func stopWorkout() {
        workoutControlButton.setTitle("START", for: .normal)
        workoutControlButton.backgroundColor = UIColor.green
        resetTimers()
        timer?.invalidate()
        resetCyclesRemaining()
        timerState = "active"
        activeTimerPlusMinus.isHidden = false
        restTimerPlusMinus.isHidden = false
        cyclesPlusMinus.isHidden = false
        resetButton.isHidden = false
        pauseButton.isHidden = true
        pauseButton.setTitle("PAUSE", for: .normal)
        pauseButton.backgroundColor = UIColor.systemOrange
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        totalTime = 0
        totalTimeLabel.text = "00:00.00"
        resetButton.isHidden = true
    }
    
    
    @IBAction func buttonWasPressed(_ sender: Any) {
        if workoutControlButton.titleLabel?.text == "START" {
            startWorkout()
        } else {
            stopWorkout()
        }
    }
    
    @objc func activeCounter()
    {
        seconds -= 0.01
        totalTimeLabel.text = calculateTimeValues(seconds: totalTime)
        if seconds <= 0 {
            resetTimers()
            swapTimers()
        } else {
            totalTime += 0.01
            if timerState == "active" {
                activeTimerValue.text = String(format: "%04.2f", seconds)
            } else {
                restTimerValue.text = String(format: "%04.2f", seconds)
            }
        }
    }
    
//    ====================================================
//    Steppers
//    ====================================================
    
    
    @IBAction func activeStepperChanged(_ sender: UIStepper) {
        let newActiveTimerValueAsDouble = Double(sender.value)
        let newActiveTimerValueAsString = String(format: "%04.2f", newActiveTimerValueAsDouble)
        
        activeTimerValue.text = newActiveTimerValueAsString
        activeTimerInitialValue = newActiveTimerValueAsDouble
    }
    
    @IBAction func restStepperChanged(_ sender: UIStepper)
    {
        let newRestTimerValueAsDouble = Double(sender.value)
        let newRestTimerValueAsString = String(format: "%04.2f", newRestTimerValueAsDouble)
        print("value changed: " + newRestTimerValueAsString)
        restTimerValue.text = newRestTimerValueAsString
        restTimerInitialValue = newRestTimerValueAsDouble
    }
    
    @IBAction func cyclesStepperChanged(_ sender: UIStepper) {
        let newCyclesRemaining = Int(sender.value)
        cyclesRemainingLabel.text = String(newCyclesRemaining)
        cyclesRemaining = newCyclesRemaining
    }
    
    //    ====================================================
    //    timers
    //    ====================================================
    
    func resetTimers() {
        activeTimerValue.text = String(format: "%04.2f", activeTimerInitialValue)
        restTimerValue.text = String(format: "%04.2f", restTimerInitialValue)
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
        } else {
            timerState = "active"
            seconds = activeTimerInitialValue
            restLabel.textColor = UIColor.white
            activeLabel.textColor = UIColor.green
            decrementCyclesRemaining()
        }
    }
    
    //    ====================================================
    //    cycles remaining
    //    ====================================================
    
    func decrementCyclesRemaining() {
        cyclesRemaining -= 1
        if cyclesRemaining > 0 {
            cyclesRemainingLabel.text = String(cyclesRemaining)
        } else {
            stopWorkout()
        }
    }
    
    func resetCyclesRemaining() {
        cyclesRemaining = Int(userSelectedCycles!)
        cyclesPlusMinus.value = Double(cyclesRemaining)
        cyclesRemainingLabel.text = String(cyclesRemaining)
    }
    
    //    ====================================================
    //    helpers
    //    ====================================================

    func calculateTimeValues(seconds : Double) -> (String) {
        let finalMinutes = Int(seconds) / 60 % 60
        let finalSeconds = Int(seconds) % 60
        let finalMilli = seconds.truncatingRemainder(dividingBy: 1.0)
    
        print(seconds)
        let finalTimeString = String(format: "%02d", finalMinutes) + ":" + String(format: "%02d", finalSeconds) + "." + String(format: "%.2f", finalMilli).dropFirst(2)
        print(finalTimeString)
        return finalTimeString
    }

}


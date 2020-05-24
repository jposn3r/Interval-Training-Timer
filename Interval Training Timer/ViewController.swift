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
    @IBOutlet weak var cyclesPlusMinus: UIStepper!
    
    var activeTimerInitialValue = 30.00
    var restTimerInitialValue = 10.00
    var seconds = 30.00
    var cyclesRemaining = 10
    var timerState = "active"
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundGradient()
        
        activeTimerPlusMinus.value = Double(activeTimerInitialValue)
        restTimerPlusMinus.value = Double(restTimerInitialValue)
        cyclesPlusMinus.value = Double(cyclesRemaining)
        cyclesRemainingLabel.text = String(cyclesRemaining)
    }
    
    func setBackgroundGradient() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.view.bounds
//        gradientLayer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func activeStepperChanged(_ sender: UIStepper) {
        let newActiveTimerValueAsDouble = Double(sender.value)
        let newActiveTimerValueAsString = String(format: "%04.2f", newActiveTimerValueAsDouble)
        
        print("initialValue: " + String(activeTimerInitialValue))
        print("value changed: " + newActiveTimerValueAsString)
        
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
    
    
    @IBAction func buttonWasPressed(_ sender: Any) {
        if workoutControlButton.titleLabel?.text == "START" {
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
        cyclesPlusMinus.isHidden = true
        
        activeTimerValue.text =
            String(format: "%04.2f", activeTimerInitialValue)
        restTimerValue.text = String(format: "%04.2f", restTimerInitialValue)
        
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
    }
    
    @objc func activeCounter()
    {
        seconds -= 0.01
        if seconds <= 0 {
            resetTimers()
            swapTimers()
        } else {
            if timerState == "active" {
                activeTimerValue.text = String(format: "%04.2f", seconds)
            } else {
                restTimerValue.text = String(format: "%04.2f", seconds)
            }
        }
    }
    
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
    
    func decrementCyclesRemaining() {
        cyclesRemaining -= 1
        if cyclesRemaining > 0 {
            cyclesRemainingLabel.text = String(cyclesRemaining)
        } else {
            stopWorkout()
        }
    }
    
    func resetCyclesRemaining() {
        cyclesRemaining = 10
        cyclesRemainingLabel.text = String(cyclesRemaining)
    }


}


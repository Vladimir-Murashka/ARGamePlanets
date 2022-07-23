//
//  TimerManager.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 22.07.2022.
//

import Foundation
import UIKit

final class TimerManager {
    
     var timer = Timer()
     var count = 0
     var timerCounting = false

    func startStopTimer(_ label: UILabel) {
        if(timerCounting)
        {
            timerCounting = false
            timer.invalidate()
        }
        else
        {
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    func timerCounter(_ label: UILabel) -> Void {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        label.text = timeString
    }
    
    private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int) {
        return (((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    private func makeTimeString(minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}

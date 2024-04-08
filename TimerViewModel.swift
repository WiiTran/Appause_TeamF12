//
//  TimerViewModel.swift
//  Project190
//
//  Created by Vlad Puriy on 10/27/23.
//

import Foundation
class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Int = 600 // 10 minutes * 60 seconds
    @Published var timeString: String = "10:00"
    var timer: Timer?

    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.timeString = self.timeFormatted(self.timeRemaining)
            } else {
                self.invalidateCode()
                self.stopTimer()
            }
        }
    }

    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes: Int = totalSeconds / 60
        let seconds: Int = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    func invalidateCode() {
        // Invalidate the code here
        ForgotPassword.shared.codeIn = ""
    }
}

//
//  TimerManager.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/26.
//

import Foundation
import SwiftUI

/**
 Timer의 시간을 감지하는 객체
 */
class TimerManager: ObservableObject {
    
    var viewModel: CustomSoundViewModel?
    var timerDidFinish: (() -> Void)?
    
    @Published var selectedTimeIndexHours: Int = 0
    @Published var selectedTimeIndexMinutes: Int = 15
    @Published var remainingSeconds: Int = 0
    @Published var textTimer: Timer?
    @Published var progressTimer: Timer?
    @Published var progress: Double = 1.0
    
    init(viewModel: CustomSoundViewModel) {
        self.viewModel = viewModel
    }
    
    // 타이머객체 실행
    func startTimer(timerManager: TimerManager) {
        timerManager.remainingSeconds = getTime(timerManager: timerManager)
        
        timerManager.textTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerManager.remainingSeconds -= 1
            
            if timerManager.remainingSeconds <= 0 {
                timer.invalidate()
                timerManager.remainingSeconds = 0
                self.viewModel?.stopSound()
                self.timerDidFinish?()
            }
        }
    }
    // 설정한 시간을 초로 변환
    func getTime(timerManager: TimerManager) -> Int {
        var hour = timerManager.selectedTimeIndexHours
        var minute = timerManager.selectedTimeIndexMinutes
        
        hour = hour * 3600
        minute = minute * 60
        
        return hour + minute
    }
    // 타이머 중지
    func stopTimer(timerManager: TimerManager) {
        timerManager.textTimer?.invalidate()
        timerManager.progressTimer?.invalidate()
        timerManager.remainingSeconds = 0
        timerManager.progress = 1.0
        self.viewModel?.stopSound()
    }
    
    func pauseTimer(timerManager: TimerManager) {
        timerManager.textTimer?.invalidate()
        timerManager.textTimer = nil
        timerManager.progressTimer?.invalidate()
        timerManager.progressTimer = nil
        self.viewModel?.stopSound()
    }
    
    // 타이머 재개
    func resumeTimer(timerManager: TimerManager) {
        timerManager.textTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerManager.remainingSeconds -= 1
            
            if timerManager.remainingSeconds <= 0 {
                timer.invalidate()
                timerManager.remainingSeconds = 0
                self.viewModel?.stopSound()
                self.timerDidFinish?()
            }
        }
        startTimeprogressBar(timerManager: timerManager)
    }
    
    // 타이머 진행바 실행
    func startTimeprogressBar(timerManager: TimerManager) {
        let settingTime: Double = Double(timerManager.getTime(timerManager: timerManager))
        var secondPercentage: Double = 0
        secondPercentage = Double((1 / settingTime) * 1.0)
        
        timerManager.progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerManager.progress -= secondPercentage
            if timerManager.progress <= 0 {
                timer.invalidate()
                timerManager.progress = 1.0
                self.viewModel?.stopSound()
                self.timerDidFinish?()
            }
        }
    }
    // 타이머 시간 뷰
    func getTimeText(timerManager: TimerManager) -> some View {
        if remainingSeconds > 3599 {
            return AnyView (
                Text(String(format: "%02d:%02d:%02d", max(timerManager.remainingSeconds / 3600, 0), max((timerManager.remainingSeconds % 3600) / 60, 0), max(timerManager.remainingSeconds % 60, 0)))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.system(size: 50, weight: .light))
                    .onAppear {
                        timerManager.startTimer(timerManager: timerManager)
                    }
                    .onDisappear { }
            )
        } else {
            return AnyView (
                Text(String(format: "%02d:%02d", max((timerManager.remainingSeconds % 3600) / 60, 0), max(timerManager.remainingSeconds % 60, 0)))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.system(size: 60, weight: .light))
                    .onAppear {
                        timerManager.startTimer(timerManager: timerManager)
                    }
                    .onDisappear { }
            )
        }
    }
    // 타이머 원형바 뷰
    func getCircularProgressBar(timerManager: TimerManager) -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 7)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(timerManager.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(.TimerMyListBackground))
                .rotationEffect(Angle(degrees: 270.0))
                .onAppear {
                    timerManager.startTimeprogressBar(timerManager: timerManager)
                }
                .onDisappear { }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

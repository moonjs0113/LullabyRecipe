//
//  TimerMainView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

/**
 타이머 View
 타이머를 설정하기 전의 View
 설정한 시간만큼 특정 음원을 반복 재생하는 기능
 */
struct TimerMainView: View {
    
    @ObservedObject var timerManager = TimerManager()
    @State private var hours : [Int] = Array(0...23)
    @State private var minutes : [Int] = Array(0...59)
    @State var isShowingListenListView: Bool = false
    @State var isShowingTimerProgressView: Bool = false
    @State var progress: Double = 1.0
    
    var body: some View {
        
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text(TabItems.timer.rawValue)
                    .foregroundColor(Color(.TitleText))
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 4)
                
                Spacer()
                
                VStack(spacing: 80) {
                    if isShowingTimerProgressView == false {
                        TimePickerView(hours: $hours,
                                       minutes: $minutes,
                                       selectedTimeIndexHours: $timerManager.selectedTimeIndexHours,
                                       selectedTimeIndexMinutes: $timerManager.selectedTimeIndexMinutes)
                    } else {
                        TimerProgressView(timerManager: timerManager)
                            .padding(.top, 60)
                    }
                    
                    VStack(spacing: 50) {
                        Button {
                            isShowingListenListView.toggle()
                        } label: {
                            selectSoundButton()
                                .cornerRadius(10)
                                .padding(.horizontal, 38)
                        }
                        
                        .sheet(isPresented: $isShowingListenListView) {
                            ListenListView()
                        }
                        
                        HStack {
                            Button {
                                timerManager.stopTimer(timerManager: timerManager)
                                isShowingTimerProgressView = false
                            } label: {
                                Image("button_reset-deactivated")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            
                            Spacer ()
                            
                            Button {
                                isShowingTimerProgressView = true
                            } label: {
                                if isShowingTimerProgressView == false {
                                    Image("button_start")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                } else {
                                    Image("button_resume")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectSoundButton() -> some View {
        HStack {
            Text("나만의 소리를 선택해주세요")
                .foregroundColor(Color(.TimerMyListText))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color(.TimerMyListText))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 15)
        .background(Color(.TimerMyListBackground))
    }
    
}

struct RelaxView_Previews: PreviewProvider {
    static var previews: some View {
        TimerMainView()
    }
}


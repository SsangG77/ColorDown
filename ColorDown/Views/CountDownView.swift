//
//  CountDownView.swift
//  ColorDown
//
//  Created by 차상진 on 2/6/25.
//

import SwiftUI

import SwiftUI

struct CountDownView: View {
    @State private var countdown: Int = -1 // 초기 카운트다운 값
    @State private var progress: CGFloat = 1.0 // 배경 경계선 진행도
    @State private var showPicker = false // 시간 선택 페이지 표시 여부
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 0
    
    @State var timeHours: Int = 0
    @State var timeMinutes: Int = 0
    @State var timeSeconds: Int = 0
    
    @State var color: Color = .blue
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var totalSeconds: Int {
        (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
    }
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            let borderY = height * progress
            
            ZStack {
                VStack(spacing: 0) {
                    color.frame(height: borderY)
                    Color.black.frame(height: height - borderY)
                }
                .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    Text(countdown == -1 ? "터치!" : "\(/*countdown*/ timeHours):\(timeMinutes):\(timeSeconds)")
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(color)
                        .blendMode(.difference) // 색상 반전 효과
                }
                .frame(width: width, height: height)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            showPicker = true
        }
        .onChange(of: countdown) {
            timeHours = countdown / (60 * 60)
            timeMinutes = countdown / 60 % 60
            timeSeconds = countdown % 60
            
        }
        .sheet(isPresented: $showPicker) {
            VStack {
            
                Text("시간을 설정하세요").font(.headline)
                HStack {
                    Picker("시", selection: $selectedHours) {
                        ForEach(0..<24) { Text("\($0) 시간") }
                    }.pickerStyle(WheelPickerStyle())
                    Picker("분", selection: $selectedMinutes) {
                        ForEach(0..<60) { Text("\($0) 분") }
                    }.pickerStyle(WheelPickerStyle())
                    Picker("초", selection: $selectedSeconds) {
                        ForEach(0..<60) { Text("\($0) 초") }
                    }.pickerStyle(WheelPickerStyle())
                }
                .padding(.bottom, 130)
                
                HStack {
                    ColorPicker("색상을 설정하세요", selection: $color)
                        .padding(.horizontal, 100)
                    
                }
                .padding(.bottom, 40)
                            
                
                Button("저장") {
                    countdown = totalSeconds
                    progress = 0.0
                    showPicker = false
                }
                .padding()
            }
        }
        .onReceive(timer) { _ in
            if countdown > 0 {
                countdown -= 1
                progress += 1.0 / CGFloat(totalSeconds)
            } else if countdown == 0 {
                countdown = -1
            }
        }
    }
}



#Preview {
    CountDownView()
}

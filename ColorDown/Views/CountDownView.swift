//
//  CountDownView.swift
//  ColorDown
//
//  Created by 차상진 on 2/6/25.
//

import SwiftUI

struct CountDownView: View {
    @State private var countdown: Int = 100 // 초기 카운트다운 값
        @State private var progress: CGFloat = 0.0 // 배경 경계선 진행도
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        var body: some View {
            GeometryReader { geometry in
                let height = geometry.size.height
                let width = geometry.size.width
                let borderY = height * progress
                
                ZStack {
                    VStack(spacing: 0) {
                        Color.red.frame(height: borderY)
                        Color.black.frame(height: height - borderY)
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    ZStack {
                        Text("\(countdown)")
                            .font(.system(size: 130, weight: .bold))
                            .foregroundColor(.red)
                            .blendMode(.difference) // 색상 반전 효과
                    }
                    .frame(width: width, height: height)
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onReceive(timer) { _ in
                if countdown > 0 {
                    countdown -= 1
                    progress += 0.01
                }
            }
        }
}

#Preview {
    CountDownView()
}

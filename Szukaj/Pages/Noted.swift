//
//  Noted.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 18.12.2024.
//

import SwiftUI

struct Noted: View {
    @EnvironmentObject private var app: Szukaj
    @Environment(\.colorScheme) private var scheme
    @State private var displayLink = DisplayLink()
    @State private var velocity: CGVector = CGVector(dx: 1, dy: 1)
    @State private var position: CGPoint = .zero
    @State private var color: Color = .gray
    
    var body: some View {
        ScrollView {
            Logo.standart(bg: scheme == .light ? .white : .black)
                .padding(.bottom, 30)
            StackOffers(source: .noted)
                .padding(.top, -8)
        }
        .background(
            VStack {
                if app.noted.isEmpty {
                    emptyCase
                }
            }
        )
    }
    
    private var emptyCase: some View {
        //https://digitalbunker.dev/dvd-screensaver-swiftui/
        GeometryReader { geometry in
            Text("S Z U K A J")
                .position(position)
                .font(.system(size: 32)).fontWeight(.heavy)
                .foregroundStyle(color)
                .onAppear {
                    position = geometry.frame(in: .local).center
                    displayLink.start {
                        position.x += velocity.dx
                        position.y += velocity.dy
                        
                        if position.x + 32*2.4 >= geometry.frame(in: .local).width || position.x <= 32*2.4  {
                            velocity.dx *= -1
                            color = .random()
                        }
                        
                        if position.y + 32*2.6 >= geometry.frame(in: .local).height || position.y <= 32*2.6 {
                            velocity.dy *= -1
                            color = .random()
                        }
                    }
                }
                .onDisappear {
                    displayLink.stop()
                }
        }
    }
}



@MainActor
final class DisplayLink {
    private var displaylink: CADisplayLink?
    private var update: (() -> Void)?

    func start(update: @escaping () -> Void) {
        self.update = update
        
        displaylink = CADisplayLink(
            target: self,
            selector: #selector(frame)
        )
        displaylink?.add(to: .current, forMode: .default)
    }

    func stop() {
        displaylink?.invalidate()
        update = nil
    }

    @objc func frame() {
        update?()
    }
}

//#Preview {
//    Noted()
//}

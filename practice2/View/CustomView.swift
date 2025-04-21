import SwiftUI

// MARK: - Custom UI Components

struct GlassMorphicCard<Content: View>: View {
    let content: Content
    var height: CGFloat? = nil
    
    init(height: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.height = height
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.2))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.1))
                        .blur(radius: 10)
                )
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            
            content
                .padding()
        }
        .frame(height: height)
    }
}

struct NeonBorder: ViewModifier {
    var color: Color
    var active: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(active ? color : Color.clear, lineWidth: 2)
                    .blur(radius: active ? 2 : 0)
            )
    }
}

extension View {
    func neonBorder(color: Color, active: Bool = true) -> some View {
        self.modifier(NeonBorder(color: color, active: active))
    }
}

struct PulseAnimation: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .opacity(isAnimating ? 0.8 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}

extension View {
    func pulseAnimation() -> some View {
        self.modifier(PulseAnimation())
    }
}

struct CircularProgressBar: View {
    var progress: Double
    var color: Color
    var lineWidth: CGFloat = 8
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
        }
    }
}

struct NeumorphicToggle: View {
    @Binding var isOn: Bool
    var onColor: Color = .blue
    var offColor: Color = .gray
    var size: CGFloat = 60
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isOn.toggle()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: size / 2)
                    .fill(Color.black.opacity(0.2))
                    .frame(width: size * 2, height: size)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5)
                
                Circle()
                    .fill(isOn ? onColor : offColor)
                    .frame(width: size - 10, height: size - 10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 2)
                    .offset(x: isOn ? size / 2 : -size / 2)
                
                if isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .offset(x: size / 2)
                } else {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .offset(x: -size / 2)
                }
            }
        }
    }
}

struct FloatingActionButton: View {
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct WaveView: View {
    @State private var phase = 0.0
    var color: Color
    var amplitude: CGFloat = 10
    var frequency: CGFloat = 10
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let timeInterval = timeline.date.timeIntervalSince1970
                let phase = timeInterval.remainder(dividingBy: 2)
                
                let path = Path { path in
                    path.move(to: CGPoint(x: 0, y: size.height / 2))
                    
                    for x in stride(from: 0, to: size.width, by: 1) {
                        let relativeX = x / size.width
                        let sine = sin(relativeX * frequency + phase * 2 * .pi)
                        let y = size.height / 2 + sine * amplitude
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                    path.addLine(to: CGPoint(x: 0, y: size.height))
                    path.closeSubpath()
                }
                
                context.fill(path, with: .color(color))
            }
        }
    }
}




struct QuickSettingButton: View {
    var icon: String
    var title: String
    var isActive: Bool
    var color: Color
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            VStack {
                ZStack {
                    Circle()
                        .fill(isActive ? color.opacity(0.2) : Color.black.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(isActive ? color : .gray)
                }
                .overlay(
                    Circle()
                        .stroke(isActive ? color : Color.clear, lineWidth: 2)
                        .blur(radius: isActive ? 2 : 0)
                )
                
                Text(title)
                    .font(.custom("Avenir", size: 12))
                    .foregroundColor(isActive ? .white : .gray)
            }
        }
    }
}


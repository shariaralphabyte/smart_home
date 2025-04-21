import SwiftUI

struct AutomationView: View {
    @State private var animatedGradient = false
    @State private var holographicOffset: CGFloat = 0
    @State private var gridRotation: Double = 0
    @State private var pulseScale: CGFloat = 1
    @State private var nodes: [CGPoint] = []
    
    let gridSize: CGFloat = 40
    let nodeCount = 12
    
    var body: some View {
        ZStack {
            // Futuristic background with animated grid
            Color(.systemBackground)
                .overlay(
                    GridView(gridSize: gridSize, rotation: gridRotation)
                        .foregroundColor(Color.blue.opacity(0.15))
                .edgesIgnoringSafeArea(.all),
            
            // Animated gradient overlay
            LinearGradient(gradient: Gradient(colors: [
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.3),
                Color.blue.opacity(0.3)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .hueRotation(.degrees(animatedGradient ? 45 : 0))
            .opacity(0.7)
            .blur(radius: 20)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animatedGradient.toggle()
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Futuristic header with animated elements
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("AUTOMATION")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(
                                        Text("AUTOMATION")
                                            .font(.system(size: 28, weight: .black, design: .rounded))
                                            .blur(radius: 0.5)
                                    )
                                )
                            
                            Spacer()
                            
                            // Animated status indicator
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [.green, .green.opacity(0)]),
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 10
                                    )
                                )
                                .frame(width: 20, height: 20)
                                .scaleEffect(pulseScale)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                        pulseScale = 1.2
                                    }
                                }
                        }
                        
                        Text("SYSTEM CONTROL PANEL")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.blue)
                            .kerning(2)
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    
                    // Holographic display area
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.8),
                                        Color(.systemGray6).opacity(0.3)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue, .purple, .blue]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 2
                                    )
                                    .blur(radius: 1)
                            )
                            .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 10)
                        
                        VStack {
                            // Animated network nodes
                            if !nodes.isEmpty {
                                ZStack {
                                    ForEach(0..<nodes.count, id: \.self) { index in
                                        NodeView(position: nodes[index])
                                            .foregroundColor(
                                                Color(
                                                    hue: Double(index)/Double(nodeCount),
                                                    saturation: 0.8,
                                                    brightness: 1
                                                )
                                            )
                                    }
                                    
                                    // Connecting lines
                                    ForEach(0..<nodes.count-1, id: \.self) { index in
                                        Path { path in
                                            path.move(to: nodes[index])
                                            path.addLine(to: nodes[index+1])
                                        }
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.blue.opacity(0.8),
                                                    Color.purple.opacity(0.8)
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            style: StrokeStyle(lineWidth: 1, dash: [5])
                                        )
                                    }
                                }
                                .frame(height: 200)
                                .padding()
                            }
                            
                            // Coming soon with holographic effect
                            VStack(spacing: 20) {
                                Text("SYSTEM INITIALIZING")
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                    .offset(x: holographicOffset)
                                    .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                    .onAppear {
                                        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                                            holographicOffset = 10
                                        }
                                    }
                                
                                Text("v2.5.0")
                                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                                    .foregroundColor(.gray)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .scaleEffect(1.5)
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 400)
                    
                    // Control panels placeholder
                    VStack(spacing: 20) {
                        ForEach(0..<3) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.3))
                                .frame(height: 80)
                                .overlay(
                                    HStack {
                                        Circle()
                                            .fill(Color.blue.opacity(0.5))
                                            .frame(width: 40, height: 40)
                                            .padding(.leading)
                                        
                                        Text("MODULE LOCKED")
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "lock")
                                            .foregroundColor(.blue)
                                            .padding(.trailing)
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // Generate random node positions
            var newNodes: [CGPoint] = []
            for _ in 0..<nodeCount {
                newNodes.append(CGPoint(
                    x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
                    y: CGFloat.random(in: 100...300)
                ))
            }
            nodes = newNodes
            
            // Animate grid rotation
            withAnimation(Animation.linear(duration: 120).repeatForever(autoreverses: false)) {
                gridRotation = 360
            }
        }
    }
}

// Supporting views
struct GridView: View {
    let gridSize: CGFloat
    let rotation: Double
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Vertical lines
                for i in 0..<Int(width / gridSize) {
                    path.move(to: CGPoint(x: CGFloat(i) * gridSize, y: 0))
                    path.addLine(to: CGPoint(x: CGFloat(i) * gridSize, y: height))
                }
                
                // Horizontal lines
                for i in 0..<Int(height / gridSize) {
                    path.move(to: CGPoint(x: 0, y: CGFloat(i) * gridSize))
                    path.addLine(to: CGPoint(x: width, y: CGFloat(i) * gridSize))
                }
            }
            .stroke(Color.blue.opacity(0.1), lineWidth: 1)
            .rotationEffect(.degrees(rotation))
        }
    }
}

struct NodeView: View {
    let position: CGPoint
    @State private var pulse: Bool = false
    
    var body: some View {
        Circle()
            .frame(width: 12, height: 12)
            .position(position)
            .shadow(color: .blue, radius: pulse ? 8 : 4)
            .scaleEffect(pulse ? 1.2 : 1)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulse)
            .onAppear {
                pulse = true
            }
    }
}

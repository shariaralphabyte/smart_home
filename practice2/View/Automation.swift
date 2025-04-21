import SwiftUI

struct AutomationView: View {
    @State private var gridRotation: Double = 0
    @State private var pulseGlow: CGFloat = 1
    @State private var activeTab: Int = 0
    
    var body: some View {
        ZStack {
            // Futuristic background
            Color.black
                .overlay(
                    GridView(gridSize: 60, rotation: gridRotation)
                        .foregroundColor(Color.teal.opacity(0.1))
                )
                .edgesIgnoringSafeArea(.all)
            
            // Main content
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Header with animated glow
                    VStack(alignment: .leading, spacing: 8) {
                        Text("HOME AUTOMATION")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .overlay(
                                LinearGradient(
                                    colors: [.teal, .mint],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .mask(
                                    Text("HOME AUTOMATION")
                                        .font(.system(size: 28, weight: .black, design: .rounded))
                                )
                            )
                            .shadow(color: .teal.opacity(0.7), radius: pulseGlow * 8)
                        
                        Text("Control your smart ecosystem")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.teal)
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                            pulseGlow = pulseGlow > 1 ? 0.8 : 1.2
                        }
                    }
                    
                    // Tab selector
                    HStack(spacing: 20) {
                        ForEach(Array(["Scenes", "Routines", "Devices"].enumerated()), id: \.offset) { index, tab in
                            Text(tab)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(activeTab == index ? .white : .gray)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(
                                    activeTab == index ?
                                    Capsule().fill(LinearGradient(colors: [.teal, .mint], startPoint: .leading, endPoint: .trailing)) :
                                    nil
                                )
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        activeTab = index
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Coming Soon Panel (Enhanced)
                    ZStack {
                        // Glass panel with shadow in overlay
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.teal.opacity(0.5), .mint.opacity(0.5)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                                    .shadow(color: .teal.opacity(0.3), radius: 20, x: 0, y: 10)
                            )
                        
                        VStack(spacing: 25) {
                            // Animated icon
                            ZStack {
                                Circle()
                                    .stroke(LinearGradient(colors: [.teal, .mint],
                                            startPoint: .top,
                                            endPoint: .bottom),
                                            lineWidth: 3)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 40))
                                    .foregroundStyle(LinearGradient(colors: [.teal, .mint],
                                                                  startPoint: .top,
                                                                  endPoint: .bottom))
                                    .symbolEffect(.pulse)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Automation Hub")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("Coming in next update")
                                    .font(.system(size: 16, design: .monospaced))
                                    .foregroundColor(.gray)
                                
                                Text("v2.5.0")
                                    .font(.system(size: 12, weight: .light, design: .monospaced))
                                    .foregroundColor(.teal)
                            }
                            
                            // Progress indicator
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .teal))
                                .scaleEffect(1.5)
                        }
                        .padding(40)
                    }
                    .frame(height: 350)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Placeholder cards
                    VStack(spacing: 20) {
                        AutomationCard(icon: "lightbulb", title: "Lighting Groups", status: "Syncing...")
                        AutomationCard(icon: "thermometer", title: "Climate Control", status: "Offline")
                        AutomationCard(icon: "lock", title: "Security", status: "Active")
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
                gridRotation = 360
            }
        }
    }
}

struct AutomationCard: View {
    let icon: String
    let title: String
    let status: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(LinearGradient(colors: [.teal, .mint],
                                              startPoint: .top,
                                              endPoint: .bottom))
                .frame(width: 40, height: 40)
                .background(Circle().fill(.ultraThinMaterial))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(status)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(status == "Active" ? .teal : .gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
        )
            )
    }
}

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
            .stroke(Color.teal.opacity(0.15), lineWidth: 1)
            .rotationEffect(.degrees(rotation))
        }
    }
}

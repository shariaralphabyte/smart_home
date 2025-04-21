import SwiftUI
import Combine

// MARK: - Data Models
struct SmartDevice: Identifiable {
    let id = UUID()
    let name: String
    let type: DeviceType
    var isActive: Bool
    var value: Double?
    var status: String?
    
    enum DeviceType {
        case light, thermostat, security, entertainment, appliance
    }
}

class SmartHomeViewModel: ObservableObject {
    @Published var devices: [SmartDevice] = [
        SmartDevice(name: "Living Room Lights", type: .light, isActive: true),
        SmartDevice(name: "Kitchen Lights", type: .light, isActive: false),
        SmartDevice(name: "Main Thermostat", type: .thermostat, isActive: true, value: 72.5),
        SmartDevice(name: "Front Door Camera", type: .security, isActive: true, status: "Motion Detected"),
        SmartDevice(name: "Media Center", type: .entertainment, isActive: false),
        SmartDevice(name: "Refrigerator", type: .appliance, isActive: true, status: "Optimal"),
        SmartDevice(name: "Bedroom Lights", type: .light, isActive: false),
        SmartDevice(name: "Garage Door", type: .security, isActive: true, status: "Closed")
    ]
    
    @Published var activeScene: HomeScene = .standard
    @Published var energyUsage: Double = 42.3
    @Published var securityStatus: SecurityStatus = .partial
    
    enum HomeScene: String, CaseIterable {
        case standard = "Standard"
        case away = "Away"
        case night = "Night"
        case entertainment = "Entertainment"
        case custom = "Custom"
    }
    
    enum SecurityStatus {
        case armed, disarmed, partial
        
        var icon: String {
            switch self {
            case .armed: return "lock.shield.fill"
            case .disarmed: return "lock.open.fill"
            case .partial: return "lock.slash.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .armed: return .green
            case .disarmed: return .red
            case .partial: return .yellow
            }
        }
    }
    
    func toggleDevice(_ device: SmartDevice) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].isActive.toggle()
        }
    }
    
    func applyScene(_ scene: HomeScene) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            activeScene = scene
            
            // Simulate scene changes
            for index in devices.indices {
                switch scene {
                case .standard:
                    if devices[index].type == .light {
                        devices[index].isActive = [true, false].randomElement()!
                    }
                case .away:
                    devices[index].isActive = devices[index].type == .security
                case .night:
                    devices[index].isActive = devices[index].type != .entertainment
                case .entertainment:
                    devices[index].isActive = devices[index].type == .light || devices[index].type == .entertainment
                case .custom:
                    break
                }
            }
            
            securityStatus = scene == .away ? .armed : (scene == .night ? .partial : .disarmed)
        }
    }
}

// MARK: - Custom Views
struct GlassCardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                ZStack {
                    // Glass morphism effect
                    Color.black.opacity(0.4)
                    BlurView(style: .systemUltraThinMaterialDark)
                }
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                )
    }
}

struct DeviceControlView: View {
    let device: SmartDevice
    let action: () -> Void
    
    var body: some View {
        GlassCardView {
            VStack(spacing: 12) {
                HStack {
                    deviceIcon(for: device.type)
                        .font(.title2)
                        .foregroundColor(device.isActive ? .white : .gray)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: { device.isActive },
                        set: { _ in action() }
                    ))
                    .labelsHidden()
                    .toggleStyle(FuturisticToggleStyle())
                }
                
                Text(device.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let value = device.value {
                    CircularProgressView(progress: value / 100,
                                       color: device.type == .thermostat ? .blue : .purple,
                                       size: .small)
                } else if let status = device.status {
                    Text(status)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func deviceIcon(for type: SmartDevice.DeviceType) -> Image {
        switch type {
        case .light: return Image(systemName: "lightbulb.fill")
        case .thermostat: return Image(systemName: "thermometer")
        case .security: return Image(systemName: "shield.fill")
        case .entertainment: return Image(systemName: "tv.fill")
        case .appliance: return Image(systemName: "refrigerator.fill")
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    let size: Size
    
    enum Size {
        case small, medium, large
        
        var dimension: CGFloat {
            switch self {
            case .small: return 30
            case .medium: return 50
            case .large: return 80
            }
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: size == .small ? 3 : 5)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: size == .small ? 3 : 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            if size != .small {
                Text("\(Int(progress * 100))")
                    .font(.system(size: size == .medium ? 14 : 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .frame(width: size.dimension, height: size.dimension)
    }
}

struct FuturisticToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .shadow(radius: 1)
                            .padding(2)
                            .offset(x: configuration.isOn ? 10 : -10)
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isOn)
                    .onTapGesture { configuration.isOn.toggle() }
            }
        }
    }
}

struct SceneSelectorView: View {
    @ObservedObject var viewModel: SmartHomeViewModel
    
    var body: some View {
        GlassCardView {
            VStack(alignment: .leading, spacing: 15) {
                Text("HOME SCENES")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(SmartHomeViewModel.HomeScene.allCases, id: \.self) { scene in
                            SceneButton(scene: scene,
                                       isActive: viewModel.activeScene == scene,
                                       action: { viewModel.applyScene(scene) })
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
    }
}

struct SceneButton: View {
    let scene: SmartHomeViewModel.HomeScene
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isActive ? LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: iconForScene(scene))
                        .font(.system(size: 20))
                        .foregroundColor(isActive ? .white : .gray)
                }
                
                Text(scene.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(isActive ? .white : .gray)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private func iconForScene(_ scene: SmartHomeViewModel.HomeScene) -> String {
        switch scene {
        case .standard: return "house.fill"
        case .away: return "figure.walk"
        case .night: return "moon.fill"
        case .entertainment: return "film.fill"
        case .custom: return "slider.horizontal.3"
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct EnergyUsageView: View {
    let usage: Double
    
    var body: some View {
        GlassCardView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("ENERGY USAGE")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", usage)) kWh")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
                
                CircularProgressView(progress: usage / 100,
                                   color: usage > 80 ? .red : (usage > 50 ? .yellow : .green),
                                   size: .medium)
                    .frame(maxWidth: .infinity)
                
                HStack(spacing: 20) {
                    EnergyStatView(value: "\(Int(usage * 1.8))", label: "CO₂ (g)")
                    EnergyStatView(value: "$\(String(format: "%.2f", usage * 0.15))", label: "COST")
                }
                .padding(.top, 5)
            }
        }
    }
}

struct EnergyStatView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct SecurityStatusView: View {
    let status: SmartHomeViewModel.SecurityStatus
    
    var body: some View {
        GlassCardView {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("SECURITY")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(status == .armed ? "Armed" : (status == .partial ? "Partial" : "Disarmed"))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: status.icon)
                    .font(.system(size: 30))
                    .foregroundColor(status.color)
            }
        }
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

// MARK: - Main View
struct SmartHomeDashboardView: View {
    @StateObject private var viewModel = SmartHomeViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.05, green: 0.05, blue: 0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("SMART HOME")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("Welcome Home")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                // Status Cards
                HStack(spacing: 15) {
                    EnergyUsageView(usage: viewModel.energyUsage)
                    
                    SecurityStatusView(status: viewModel.securityStatus)
                }
                .padding(.horizontal)
                
                // Scene Selector
                SceneSelectorView(viewModel: viewModel)
                    .padding(.horizontal)
                
                // Devices Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                        ForEach(viewModel.devices) { device in
                            DeviceControlView(device: device) {
                                viewModel.toggleDevice(device)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// MARK: - Preview
struct SmartHomeDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        SmartHomeDashboardView()
            .preferredColorScheme(.dark)
    }
}

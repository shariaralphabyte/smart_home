import SwiftUI
import Combine


// MARK: - Models

struct Room: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    var temperature: Double
    var humidity: Double
    var lights: [Light]
    var activeDevices: Int
    var energyUsage: Double // kWh
}

struct Light: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var isOn: Bool
    var brightness: Double
    var color: Color
}

struct DeviceActivity: Identifiable {
    let id = UUID()
    let time: Date
    let deviceName: String
    let action: String
    let icon: String
}


// MARK: - Data Models

struct Device: Identifiable {
    let id = UUID()
    let name: String
    let type: DeviceCategory
    var isOn: Bool
    let powerUsage: String
    let icon: String
}

enum DeviceCategory: String, CaseIterable {
    case all = "All"
    case light = "Lights"
    case climate = "Climate"
    case security = "Security"
    case entertainment = "Media"
    case appliance = "Appliances"
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .light: return "lightbulb.fill"
        case .climate: return "thermometer"
        case .security: return "lock.fill"
        case .entertainment: return "tv.fill"
        case .appliance: return "house.fill"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .all: return .blue
        case .light: return .yellow
        case .climate: return .teal
        case .security: return .red
        case .entertainment: return .purple
        case .appliance: return .orange
        }
    }
}

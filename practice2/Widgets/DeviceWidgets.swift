import SwiftUI

// MARK: - Components

// Keep this single implementation in a file like `DeviceComponents.swift`
struct DeviceCard2: View {
    let device: Device
    
    var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.25)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            device.isOn ? device.type.accentColor.opacity(0.5) : Color.gray.opacity(0.3),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Icon with colored background
                    ZStack {
                        Circle()
                            .fill(device.type.accentColor.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: device.icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(device.type.accentColor)
                    }
                    
                    Spacer()
                    
                    // Power status indicator
                    Circle()
                        .fill(device.isOn ? device.type.accentColor : Color.gray.opacity(0.5))
                        .frame(width: 12, height: 12)
                        .shadow(color: device.isOn ? device.type.accentColor.opacity(0.8) : .clear, radius: 4)
                }
                
                Text(device.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Spacer()
                
                HStack {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                    
                    Text(device.powerUsage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text(device.isOn ? "ON" : "OFF")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(device.isOn ? .white : .gray)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(device.isOn ? device.type.accentColor : Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
            }
            .padding(15)
        }
        .frame(height: 150)
        .overlay(
            Group {
                if device.isOn {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(device.type.accentColor.opacity(0.8), lineWidth: 1.5)
                        .shadow(color: device.type.accentColor.opacity(0.6), radius: 8, x: 0, y: 0)
                }
            }
        )
    }
}
struct CategoryPill: View {
    let category: DeviceCategory
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .bold))
                
                Text(category.rawValue.capitalized)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isActive ? .white : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isActive ? category.accentColor.opacity(0.3) : Color.clear)
            )
            .overlay(
                Capsule()
                    .stroke(isActive ? category.accentColor : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}


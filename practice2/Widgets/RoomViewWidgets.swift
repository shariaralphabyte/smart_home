import SwiftUI
struct RoomCard: View {
    var room: Room
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
            
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: room.icon)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("\(room.activeDevices) active")
                        .font(.custom("Avenir", size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Text(room.name)
                    .font(.custom("Avenir-Medium", size: 16))
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "thermometer")
                        .foregroundColor(.orange)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f°C", room.temperature))
                        .font(.custom("Avenir", size: 12))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "humidity.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.0f%%", room.humidity))
                        .font(.custom("Avenir", size: 12))
                        .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                }
                                .neonBorder(color: .blue, active: room.activeDevices > 0)
                            }
                        }



struct RoomCardDetailed: View {
    var room: Room
    
    var body: some View {
        ZStack {
            // Card background
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
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.2),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                // Top row
                HStack {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.3),
                                    Color.blue.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: room.icon)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    // Status indicator
                    Capsule()
                        .fill(
                            room.lights.contains { $0.isOn } ?
                            Color.green.opacity(0.2) :
                            Color.gray.opacity(0.2)
                        )
                        .frame(width: 70, height: 28)
                        .overlay(
                            Text(room.lights.contains { $0.isOn } ? "ACTIVE" : "OFF")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(
                                    room.lights.contains { $0.isOn } ?
                                    .green :
                                    .gray.opacity(0.8)
                                )
                        )
                }
                
                // Room name
                Text(room.name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Spacer()
                
                // Stats row
                HStack(spacing: 15) {
                    StatItem(
                        icon: "thermometer",
                        value: "\(String(format: "%.1f°C", room.temperature))",
                        label: "Temp",
                        color: .orange
                    )
                    
                    Divider()
                        .frame(height: 40)
                        .background(Color.white.opacity(0.2))
                    
                    StatItem(
                        icon: "humidity.fill",
                        value: "\(String(format: "%.0f%%", room.humidity))",
                        label: "Humidity",
                        color: .blue
                    )
                }
                .frame(height: 50)
                
                // Bottom row
                HStack {
                    StatItem(
                        icon: "powerplug.fill",
                        value: "\(room.activeDevices)",
                        label: "Devices",
                        color: .purple
                    )
                    
                    Spacer()
                    
                    StatItem(
                        icon: "bolt.fill",
                        value: "\(String(format: "%.1f", room.energyUsage))",
                        label: "kWh",
                        color: .yellow
                    )
                }
            }
            .padding(20)
        }
        .overlay(
            Group {
                if room.activeDevices > 0 {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1.5)
                        .shadow(color: .blue.opacity(0.8), radius: 8, x: 0, y: 0)
                }
            }
        )
    }
}

private struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

struct DeviceCard: View {
    var icon: String
    var name: String
    var isOn: Bool
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isOn ? Color.blue.opacity(0.2) : Color.black.opacity(0.3))
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 36))
                    .foregroundColor(isOn ? .blue : .gray)
            }
            .neonBorder(color: .blue, active: isOn)
            
            Text(name)
                .font(.custom("Avenir-Medium", size: 14))
                .foregroundColor(isOn ? .white : .gray)
        }
    }
}




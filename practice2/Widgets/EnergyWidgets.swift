import SwiftUI

struct EnergySummaryView: View {
    let devices: [Device]
    
    var activeDevices: Int {
        devices.filter { $0.isOn }.count
    }
    
    var totalPower: String {
        let total = devices.filter { $0.isOn }.reduce(0) { sum, device in
            sum + (Double(device.powerUsage.replacingOccurrences(of: " kW", with: "")) ?? 0)
        }
        return String(format: "%.1f kW", total)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("ACTIVE DEVICES")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(activeDevices)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("/\(devices.count)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .offset(y: -2)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("POWER USAGE")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
                
                HStack(alignment: .center, spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)
                    
                    Text(totalPower)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}



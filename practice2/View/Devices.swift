import SwiftUI

struct DevicesView: View {
    @State private var activeCategory: DeviceCategory = .all
    @State private var searchText = ""
    
    // Sample data
    @State private var devices: [Device] = [
        Device(name: "Living Room Lights", type: .light, isOn: true, powerUsage: "1.2 kW", icon: "lightbulb.fill"),
        Device(name: "Smart Thermostat", type: .climate, isOn: true, powerUsage: "0.5 kW", icon: "thermometer"),
        Device(name: "Security Camera", type: .security, isOn: false, powerUsage: "0.8 kW", icon: "video.fill"),
        Device(name: "Smart Speaker", type: .entertainment, isOn: true, powerUsage: "0.3 kW", icon: "speaker.wave.2.fill"),
        Device(name: "Refrigerator", type: .appliance, isOn: true, powerUsage: "2.1 kW", icon: "refrigerator.fill"),
        Device(name: "Garage Door", type: .security, isOn: false, powerUsage: "1.5 kW", icon: "garage.open")
    ]
    
    var filteredDevices: [Device] {
        if activeCategory == .all { return devices }
        return devices.filter { $0.type == activeCategory }
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.08, green: 0.08, blue: 0.16),
                Color(red: 0.12, green: 0.12, blue: 0.24)
            ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Devices")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 25)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search devices...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(DeviceCategory.allCases, id: \.self) { category in
                                CategoryPill(
                                    category: category,
                                    isActive: activeCategory == category,
                                    action: { activeCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Device Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible())], spacing: 15) {
                        ForEach(filteredDevices) { device in
                            DeviceCard2(device: device)
                                .onTapGesture {
                                    // Toggle device state
                                    if let index = devices.firstIndex(where: { $0.id == device.id }) {
                                        withAnimation(.spring()) {
                                            devices[index].isOn.toggle()
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    // Energy Summary
                    EnergySummaryView(devices: devices)
                        .padding(.horizontal, 15)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

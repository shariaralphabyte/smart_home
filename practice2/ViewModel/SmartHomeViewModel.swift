import SwiftUI
import Combine


// MARK: - View Models

class HomeViewModel: ObservableObject {
    @Published var rooms: [Room]
    @Published var selectedRoom: Room?
    @Published var recentActivities: [DeviceActivity]
    @Published var energyUsage: [Double]
    @Published var ambientMode: Bool = false
    @Published var securityMode: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Demo data
        let livingRoom = Room(
            name: "Living Room",
            icon: "sofa.fill",
            temperature: 22.5,
            humidity: 45.0,
            lights: [
                Light(name: "Main Light", isOn: true, brightness: 0.8, color: .white),
                Light(name: "Ambient Light", isOn: true, brightness: 0.5, color: Color(red: 0.2, green: 0.6, blue: 1.0))
            ],
            activeDevices: 3,
            energyUsage: 1.2
        )
        
        let kitchen = Room(
            name: "Kitchen",
            icon: "cooktop.fill",
            temperature: 23.0,
            humidity: 50.0,
            lights: [
                Light(name: "Ceiling Light", isOn: true, brightness: 0.9, color: .white),
                Light(name: "Under Cabinet", isOn: false, brightness: 0.7, color: .white)
            ],
            activeDevices: 2,
            energyUsage: 0.8
        )
        
        let bedroom = Room(
            name: "Bedroom",
            icon: "bed.double.fill",
            temperature: 21.0,
            humidity: 40.0,
            lights: [
                Light(name: "Main Light", isOn: false, brightness: 0.6, color: .white),
                Light(name: "Reading Light", isOn: true, brightness: 0.4, color: Color(red: 1.0, green: 0.9, blue: 0.7))
            ],
            activeDevices: 1,
            energyUsage: 0.5
        )
        
        let bathroom = Room(
            name: "Bathroom",
            icon: "shower.fill",
            temperature: 24.0,
            humidity: 65.0,
            lights: [
                Light(name: "Main Light", isOn: false, brightness: 1.0, color: .white),
                Light(name: "Mirror Light", isOn: false, brightness: 0.8, color: .white)
            ],
            activeDevices: 0,
            energyUsage: 0.2
        )
        
        let now = Date()
        
        self.rooms = [livingRoom, kitchen, bedroom, bathroom]
        self.selectedRoom = livingRoom
        self.recentActivities = [
            DeviceActivity(time: now.addingTimeInterval(-5 * 60), deviceName: "Living Room Light", action: "Turned On", icon: "lightbulb.fill"),
            DeviceActivity(time: now.addingTimeInterval(-30 * 60), deviceName: "Thermostat", action: "Temperature Adjusted", icon: "thermometer"),
            DeviceActivity(time: now.addingTimeInterval(-60 * 60), deviceName: "Front Door", action: "Unlocked", icon: "lock.open.fill"),
            DeviceActivity(time: now.addingTimeInterval(-2 * 60 * 60), deviceName: "Kitchen Light", action: "Turned Off", icon: "lightbulb.slash"),
            DeviceActivity(time: now.addingTimeInterval(-3 * 60 * 60), deviceName: "Bedroom TV", action: "Turned Off", icon: "tv.fill")
        ]
        self.energyUsage = [2.1, 1.8, 2.5, 3.0, 2.2, 1.9, 2.7]
        
        // Simulate changes
        Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.simulateChanges()
            }
            .store(in: &cancellables)
    }
    
    func simulateChanges() {
        // Simulate small changes to temperature and humidity
        for i in 0..<rooms.count {
            rooms[i].temperature += Double.random(in: -0.2...0.2)
            rooms[i].humidity += Double.random(in: -1.0...1.0)
            
            // Keep values in reasonable ranges
            rooms[i].temperature = max(18, min(26, rooms[i].temperature))
            rooms[i].humidity = max(30, min(70, rooms[i].humidity))
        }
        
        // Update selected room if needed
        if let selectedRoom = selectedRoom {
            self.selectedRoom = rooms.first(where: { $0.name == selectedRoom.name })
        }
    }
    
    func toggleLight(_ light: Light, in room: Room) {
        guard let roomIndex = rooms.firstIndex(where: { $0.id == room.id }),
              let lightIndex = rooms[roomIndex].lights.firstIndex(where: { $0.id == light.id }) else {
            return
        }
        
        rooms[roomIndex].lights[lightIndex].isOn.toggle()
        
        // Add activity
        let action = rooms[roomIndex].lights[lightIndex].isOn ? "Turned On" : "Turned Off"
        let newActivity = DeviceActivity(
            time: Date(),
            deviceName: "\(room.name) \(light.name)",
            action: action,
            icon: "lightbulb.\(rooms[roomIndex].lights[lightIndex].isOn ? "fill" : "slash")"
        )
        
        recentActivities.insert(newActivity, at: 0)
        if recentActivities.count > 10 {
            recentActivities.removeLast()
        }
        
        // Update selected room if needed
        if selectedRoom?.id == room.id {
            selectedRoom = rooms[roomIndex]
        }
    }
    
    func updateLightBrightness(_ light: Light, in room: Room, brightness: Double) {
        guard let roomIndex = rooms.firstIndex(where: { $0.id == room.id }),
              let lightIndex = rooms[roomIndex].lights.firstIndex(where: { $0.id == light.id }) else {
            return
        }
        
        rooms[roomIndex].lights[lightIndex].brightness = brightness
        
        // Update selected room if needed
        if selectedRoom?.id == room.id {
            selectedRoom = rooms[roomIndex]
        }
    }
    
    func updateLightColor(_ light: Light, in room: Room, color: Color) {
        guard let roomIndex = rooms.firstIndex(where: { $0.id == room.id }),
              let lightIndex = rooms[roomIndex].lights.firstIndex(where: { $0.id == light.id }) else {
            return
        }
        
        rooms[roomIndex].lights[lightIndex].color = color
        
        // Update selected room if needed
        if selectedRoom?.id == room.id {
            selectedRoom = rooms[roomIndex]
        }
    }
}

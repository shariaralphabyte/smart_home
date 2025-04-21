import SwiftUI


struct RoomDetailView: View {
    @ObservedObject var viewModel: HomeViewModel
    var room: Room
    @Binding var isShowingRoomDetail: Bool
    @State private var temperatureOffset: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 6)
                .padding(.top, 10)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text(room.name)
                                .font(.custom("Avenir-Heavy", size: 28))
                                .foregroundColor(.white)
                            
                            Text("\(room.activeDevices) devices active")
                                .font(.custom("Avenir", size: 16))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: room.icon)
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Climate Control
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Climate Control")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 30) {
                                VStack {
                                    ZStack {
                                        CircularProgressBar(progress: room.temperature / 30, color: .orange)
                                            .frame(width: 100, height: 100)
                                        
                                        VStack {
                                            Text(String(format: "%.1f°C", room.temperature + temperatureOffset))
                                                .font(.custom("Avenir-Heavy", size: 24))
                                                .foregroundColor(.white)
                                            
                                            Text("Temperature")
                                                .font(.custom("Avenir", size: 12))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    HStack {
                                        Button(action: {
                                            temperatureOffset -= 0.5
                                        }) {
                                            Image(systemName: "minus")
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(Color.black.opacity(0.3))
                                                .cornerRadius(10)
                                        }
                                        
                                        Button(action: {
                                            temperatureOffset += 0.5
                                        }) {
                                            Image(systemName: "plus")
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(Color.black.opacity(0.3))
                                                .cornerRadius(10)
                                        }
                                    }
                                    .padding(.top, 10)
                                }
                                
                                VStack {
                                    ZStack {
                                        CircularProgressBar(progress: room.humidity / 100, color: .blue)
                                            .frame(width: 100, height: 100)
                                        
                                        VStack {
                                            Text(String(format: "%.0f%%", room.humidity))
                                                .font(.custom("Avenir-Heavy", size: 24))
                                                .foregroundColor(.white)
                                            
                                            Text("Humidity")
                                                .font(.custom("Avenir", size: 12))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    HStack {
                                        Text("Auto")
                                            .font(.custom("Avenir", size: 14))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(Color.blue.opacity(0.3))
                                            .cornerRadius(10)
                                    }
                                    .padding(.top, 10)
                                }
                            }
                        }
                    }
                    
                    // Lights
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Lights")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            ForEach(room.lights) { light in
                                LightControlView(viewModel: viewModel, light: light, room: room)
                            }
                        }
                    }
                    
                    // Energy Usage
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Energy Usage")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Current")
                                        .font(.custom("Avenir", size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Text("\(String(format: "%.1f", room.energyUsage)) kWh")
                                        .font(.custom("Avenir-Heavy", size: 24))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text("Daily Average")
                                        .font(.custom("Avenir", size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Text("\(String(format: "%.1f", room.energyUsage * 24)) kWh")
                                        .font(.custom("Avenir-Heavy", size: 24))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.3))
                                    .frame(height: 10)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.green, Color.yellow, Color.orange]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 200, height: 10)
                            }
                            
                            HStack {
                                Text("Eco")
                                    .font(.custom("Avenir", size: 12))
                                    .foregroundColor(.green)
                                
                                Spacer()
                                
                                Text("Normal")
                                    .font(.custom("Avenir", size: 12))
                                    .foregroundColor(.yellow)
                                
                                Spacer()
                                
                                Text("High")
                                    .font(.custom("Avenir", size: 12))
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    // Devices
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Devices")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    DeviceCard(icon: "tv.fill", name: "TV", isOn: true)
                                    DeviceCard(icon: "speaker.wave.3.fill", name: "Speaker", isOn: false)
                                    DeviceCard(icon: "fan.fill", name: "Fan", isOn: true)
                                    DeviceCard(icon: "air.purifier.fill", name: "Air Purifier", isOn: false)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 0.08, green: 0.08, blue: 0.15))
                .ignoresSafeArea()
        )
        .frame(height: UIScreen.main.bounds.height * 0.85)
    }
}

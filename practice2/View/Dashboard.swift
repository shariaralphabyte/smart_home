import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                // Welcome Banner
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome Home")
                            .font(.custom("Avenir-Heavy", size: 24))
                            .foregroundColor(.white)
                        
                        Text("Monday, April 21")
                            .font(.custom("Avenir", size: 16))
                            .foregroundColor(.gray)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Inside")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Image(systemName: "thermometer")
                                        .foregroundColor(.orange)
                                    Text("22.5°C")
                                        .font(.custom("Avenir-Medium", size: 18))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Outside")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Image(systemName: "cloud.sun.fill")
                                        .foregroundColor(.yellow)
                                    Text("19.2°C")
                                        .font(.custom("Avenir-Medium", size: 18))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Humidity")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Image(systemName: "humidity.fill")
                                        .foregroundColor(.blue)
                                    Text("45%")
                                        .font(.custom("Avenir-Medium", size: 18))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                
                // Quick Settings
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Quick Settings")
                            .font(.custom("Avenir-Heavy", size: 18))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            QuickSettingButton(
                                icon: "house.fill",
                                title: "Home Mode",
                                isActive: true,
                                color: .blue
                            )
                            
                            QuickSettingButton(
                                icon: "moon.stars.fill",
                                title: "Night Mode",
                                isActive: viewModel.ambientMode,
                                color: .purple,
                                action: {
                                    viewModel.ambientMode.toggle()
                                }
                            )
                            
                            QuickSettingButton(
                                icon: "lock.shield.fill",
                                title: "Security",
                                isActive: viewModel.securityMode,
                                color: .red,
                                action: {
                                    viewModel.securityMode.toggle()
                                }
                            )
                            
                            QuickSettingButton(
                                icon: "leaf.fill",
                                title: "Eco Mode",
                                isActive: false,
                                color: .green
                            )
                        }
                    }
                }
                
                // Rooms Status
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Rooms")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            NavigationLink(destination: RoomsView(viewModel: viewModel, isShowingRoomDetail: .constant(false))) {
                                Text("See All")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.rooms) { room in
                                    RoomCard(room: room)
                                        .frame(width: 160, height: 120)
                                }
                            }
                        }
                    }
                }
                
                // Recent Activities
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Recent Activities")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("See All")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        ForEach(viewModel.recentActivities.prefix(3)) { activity in
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: activity.icon)
                                        .foregroundColor(.blue)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(activity.deviceName)
                                        .font(.custom("Avenir-Medium", size: 16))
                                        .foregroundColor(.white)
                                    
                                    Text(activity.action)
                                        .font(.custom("Avenir", size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text(formatTime(activity.time))
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                            
                            if activity.id != viewModel.recentActivities.prefix(3).last?.id {
                                Divider()
                                    .background(Color.gray.opacity(0.3))
                            }
                        }
                    }
                }
                
                // Energy Usage
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Energy Usage")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            NavigationLink(destination: EnergyView(viewModel: viewModel)) {
                                Text("Details")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        HStack(alignment: .bottom, spacing: 5) {
                            ForEach(0..<viewModel.energyUsage.count, id: \.self) { index in
                                VStack {
                                    let value = viewModel.energyUsage[index]
                                    let maxValue = viewModel.energyUsage.max() ?? 3.0
                                    let normalizedHeight = (value / maxValue) * 100
                                    
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                        )
                                        .frame(height: normalizedHeight)
                                        .cornerRadius(4)
                                    
                                    Text(getDayOfWeek(index))
                                        .font(.custom("Avenir", size: 10))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .frame(height: 120)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Today")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack(alignment: .bottom) {
                                    Text("2.7")
                                        .font(.custom("Avenir-Heavy", size: 24))
                                        .foregroundColor(.white)
                                    
                                    Text("kWh")
                                        .font(.custom("Avenir", size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("This Week")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack(alignment: .bottom) {
                                    Text("16.2")
                                        .font(.custom("Avenir-Heavy", size: 24))
                                        .foregroundColor(.white)
                                    
                                    Text("kWh")
                                        .font(.custom("Avenir", size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    
                    }
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.16),
                    Color(red: 0.12, green: 0.12, blue: 0.24)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func getDayOfWeek(_ index: Int) -> String {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return days[index]
    }
}

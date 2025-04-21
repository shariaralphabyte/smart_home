import SwiftUI

struct EnergyView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Energy")
                        .font(.custom("Avenir-Heavy", size: 24))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Energy Summary
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Today")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack(alignment: .bottom) {
                                    Text("2.7")
                                        .font(.custom("Avenir-Heavy", size: 28))
                                        .foregroundColor(.white)
                                    
                                    Text("kWh")
                                        .font(.custom("Avenir", size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Monthly Estimate")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack(alignment: .bottom) {
                                    Text("81.0")
                                        .font(.custom("Avenir-Heavy", size: 28))
                                        .foregroundColor(.white)
                                    
                                    Text("kWh")
                                        .font(.custom("Avenir", size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        HStack {
                            WaveView(color: Color.blue.opacity(0.3), amplitude: 10, frequency: 20)
                                .frame(height: 50)
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Cost Today")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                Text("$0.54")
                                    .font(.custom("Avenir-Medium", size: 18))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Monthly Estimate")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                Text("$16.20")
                                    .font(.custom("Avenir-Medium", size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Weekly Graph
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Weekly Usage")
                            .font(.custom("Avenir-Heavy", size: 18))
                            .foregroundColor(.white)
                        
                        HStack(alignment: .bottom, spacing: 10) {
                            ForEach(0..<7, id: \.self) { index in
                                let value = viewModel.energyUsage[index]
                                let maxValue = viewModel.energyUsage.max() ?? 3.0
                                let normalizedHeight = (value / maxValue) * 150
                                
                                VStack {
                                    ZStack(alignment: .bottom) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black.opacity(0.3))
                                            .frame(height: 150)
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]),
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .frame(height: normalizedHeight)
                                    }
                                    
                                    Text(getDayOfWeek(index))
                                        .font(.custom("Avenir", size: 12))
                                        .foregroundColor(.gray)
                                        .padding(.top, 5)
                                }
                            }
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.vertical, 10)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                Text("16.2 kWh")
                                    .font(.custom("Avenir-Medium", size: 18))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Average")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.gray)
                                
                                Text("2.3 kWh/day")
                                    .font(.custom("Avenir-Medium", size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Room Energy Usage
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Room Energy Usage")
                            .font(.custom("Avenir-Heavy", size: 18))
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.rooms) { room in
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: room.icon)
                                        .foregroundColor(.blue)
                                }
                                
                                Text(room.name)
                                    .font(.custom("Avenir-Medium", size: 16))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(String(format: "%.1f", room.energyUsage)) kWh")
                                    .font(.custom("Avenir-Medium", size: 16))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 5)
                            
                            if room.id != viewModel.rooms.last?.id {
                                Divider()
                                    .background(Color.gray.opacity(0.3))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Eco Tips
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Energy Saving Tips")
                            .font(.custom("Avenir-Heavy", size: 18))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            EcoTipView(
                                icon: "lightbulb.fill",
                                title: "Smart Lighting",
                                description: "Turn off lights in the Living Room when not in use to save up to 0.5 kWh daily."
                            )
                            
                            EcoTipView(
                                icon: "thermometer",
                                title: "Temperature Control",
                                description: "Lower the temperature by 1°C to save up to 10% on heating energy."
                            )
                            
                            EcoTipView(
                                icon: "clock.fill",
                                title: "Scheduling",
                                description: "Schedule your devices to turn off automatically during night hours."
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
            .padding(.bottom, 30)
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
    
    func getDayOfWeek(_ index: Int) -> String {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return days[index]
    }
}

struct EcoTipView: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.custom("Avenir-Medium", size: 16))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.custom("Avenir", size: 14))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }
}




                

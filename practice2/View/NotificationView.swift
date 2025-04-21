import SwiftUI

struct NotificationsView: View {
    var activities: [DeviceActivity]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Text("Notifications")
                    .font(.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
            
                    presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.black.opacity(0.3))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
                                
                                ScrollView {
                                    VStack(spacing: 15) {
                                        ForEach(activities) { activity in
                                            HStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.blue.opacity(0.2))
                                                        .frame(width: 40, height: 40)
                                                    
                                                    Image(systemName: activity.icon)
                                                        .foregroundColor(.blue)
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 5) {
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
                                            .padding()
                                            .background(Color.black.opacity(0.2))
                                            .cornerRadius(15)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Clear All")
                                        .font(.custom("Avenir-Medium", size: 16))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 15)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(15)
                                        .padding()
                                }
                            }
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.05, green: 0.05, blue: 0.1)]),
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
                    }

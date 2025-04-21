import SwiftUI


struct SettingsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
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
                VStack(spacing: 20) {
                    // Profile
                    GlassMorphicCard {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Alex Johnson")
                                    .font(.custom("Avenir-Heavy", size: 20))
                                    .foregroundColor(.white)
                                
                                Text("Home Owner")
                                    .font(.custom("Avenir", size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 10)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("Edit")
                                    .font(.custom("Avenir", size: 14))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(20)
                            }
                        }
                    }
                    
                    // System Settings
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("System")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            SettingsItemToggle(icon: "moon.stars.fill", title: "Night Mode", isOn: $viewModel.ambientMode)
                            
                            SettingsItemToggle(icon: "lock.shield.fill", title: "Security System", isOn: $viewModel.securityMode)
                            
                            SettingsItem(icon: "wifi", title: "Network Settings", value: "Connected")
                            
                            SettingsItem(icon: "bell.fill", title: "Notifications", value: "On")
                            
                            SettingsItem(icon: "person.2.fill", title: "Users & Permissions", value: "3 Users")
                        }
                    }
                    
                    // Devices
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Devices")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            SettingsItem(icon: "plus.circle.fill", title: "Add New Device", value: "")
                            
                            SettingsItem(icon: "arrow.triangle.2.circlepath", title: "Update Firmware", value: "2 Updates")
                            
                            SettingsItem(icon: "gear", title: "Device Settings", value: "")
                        }
                    }
                    
                    // Automation
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Automation")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            SettingsItem(icon: "wand.and.stars", title: "Scenes", value: "3 Scenes")
                            
                            SettingsItem(icon: "clock.fill", title: "Schedules", value: "5 Active")
                            
                            SettingsItem(icon: "slider.horizontal.3", title: "Rules & Triggers", value: "2 Rules")
                        }
                    }
                    
                    // Account & Privacy
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Account & Privacy")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            SettingsItem(icon: "person.fill", title: "Account Details", value: "")
                            
                            SettingsItem(icon: "lock.fill", title: "Privacy Settings", value: "")
                            
                            SettingsItem(icon: "hand.raised.fill", title: "Data Collection", value: "Limited")
                        }
                    }
                    
                    // Help & Support
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Help & Support")
                                .font(.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                            
                            SettingsItem(icon: "questionmark.circle.fill", title: "FAQ", value: "")
                            
                            SettingsItem(icon: "bubble.left.fill", title: "Contact Support", value: "")
                            
                            SettingsItem(icon: "info.circle.fill", title: "About", value: "v2.1.0")
                        }
                    }
                    
                    Button(action: {}) {
                        Text("Sign Out")
                            .font(.custom("Avenir-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.red.opacity(0.7))
                            .cornerRadius(15)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
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
}

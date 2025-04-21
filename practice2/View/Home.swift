// MARK: - Main Views
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedTab = 0
    @State private var showSettings = false
    @State private var showNotifications = false
    @State private var isShowingRoomDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.05, green: 0.05, blue: 0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top status bar
                    HStack {
                        Text("SmartHome")
                            .font(.custom("Avenir-Heavy", size: 28))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { showNotifications.toggle() }) {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.white)
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                                    .offset(x: 10, y: -10)
                            }
                        }
                        
                        Button(action: { showSettings.toggle() }) {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "gear")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    TabView(selection: $selectedTab) {
                        DashboardView(viewModel: viewModel)
                            .tag(0)
                        
                        RoomsView(viewModel: viewModel, isShowingRoomDetail: $isShowingRoomDetail)
                            .tag(1)
                        
                        DevicesView()
                            .tag(2)
                        
                        AutomationView()
                            .tag(3)
                        
                        EnergyView(viewModel: viewModel)
                            .tag(4)
                    }
                    
                    // Custom Tab Bar
                    CustomTabBar(selectedTab: $selectedTab)
                }
                
        
                
                // Conditionally show room detail as an overlay
                if isShowingRoomDetail, let selectedRoom = viewModel.selectedRoom {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isShowingRoomDetail = false
                        }
                    
                    RoomDetailView(viewModel: viewModel, room: selectedRoom, isShowingRoomDetail: $isShowingRoomDetail)
                        .transition(.move(edge: .bottom))
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) {
                SettingsView(viewModel: viewModel)
            }
            .sheet(isPresented: $showNotifications) {
                NotificationsView(activities: viewModel.recentActivities)
            }
        }
    }
}

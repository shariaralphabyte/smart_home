import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabButton(image: "house.fill", title: "Home", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            TabButton(image: "door.right.hand.open", title: "Rooms", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            TabButton(image: "desktopcomputer", title: "Devices", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            
            TabButton(image: "wand.and.stars", title: "Automation", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
            
            TabButton(image: "bolt.fill", title: "Energy", isSelected: selectedTab == 4) {
                selectedTab = 4
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.3))
                .ignoresSafeArea()
        )
    }
}


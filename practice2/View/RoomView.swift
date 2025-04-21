import SwiftUI

struct RoomsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isShowingRoomDetail: Bool
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.16),
                    Color(red: 0.12, green: 0.12, blue: 0.24)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Rooms")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
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
                    
                    // Grid of rooms
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ],
                        spacing: 20
                    ) {
                        ForEach(viewModel.rooms) { room in
                            RoomCardDetailed(room: room)
                                .frame(height: 220)
                                .onTapGesture {
                                    viewModel.selectedRoom = room
                                    withAnimation(.spring()) {
                                        isShowingRoomDetail = true
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

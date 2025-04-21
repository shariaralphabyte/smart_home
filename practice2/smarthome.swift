import SwiftUI
import Combine

                        struct LightControlView: View {
                            @ObservedObject var viewModel: HomeViewModel
                            let light: Light
                            let room: Room
                            @State private var isShowingColorPicker = false
                            
                            var body: some View {
                                HStack {
                                    Image(systemName: light.isOn ? "lightbulb.fill" : "lightbulb")
                                        .foregroundColor(light.isOn ? light.color : .gray)
                                        .font(.system(size: 24))
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading) {
                                        Text(light.name)
                                            .font(.custom("Avenir-Medium", size: 16))
                                            .foregroundColor(.white)
                                        
                                        if light.isOn {
                                            Text("Brightness: \(Int(light.brightness * 100))%")
                                                .font(.custom("Avenir", size: 12))
                                                .foregroundColor(.gray)
                                        } else {
                                            Text("Off")
                                                .font(.custom("Avenir", size: 12))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if light.isOn {
                                        Button(action: {
                                            isShowingColorPicker.toggle()
                                        }) {
                                            Circle()
                                                .fill(light.color)
                                                .frame(width: 30, height: 30)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: 2)
                                                )
                                        }
                                    }
                                    
                                    Toggle("", isOn: Binding(
                                        get: { light.isOn },
                                        set: { newValue in
                                            viewModel.toggleLight(light, in: room)
                                        }
                                    ))
                                    .labelsHidden()
                                }
                                .padding()
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(15)
                                .sheet(isPresented: $isShowingColorPicker) {
                                    ColorPickerView(color: Binding(
                                        get: { light.color },
                                        set: { newValue in
                                            viewModel.updateLightColor(light, in: room, color: newValue)
                                        }
                                    ))
                                    .presentationDetents([.medium])
                                }
                                
                                // Brightness slider only shown when light is on
                                if light.isOn {
                                    HStack {
                                        Image(systemName: "sun.min.fill")
                                            .foregroundColor(.gray)
                                        
                                        Slider(value: Binding(
                                            get: { light.brightness },
                                            set: { newValue in
                                                viewModel.updateLightBrightness(light, in: room, brightness: newValue)
                                            }
                                        ), in: 0...1)
                                        .accentColor(light.color)
                                        
                                        Image(systemName: "sun.max.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }
                            }
                        }

                        struct ColorPickerView: View {
                            @Binding var color: Color
                            @Environment(\.presentationMode) var presentationMode
                            
                            let colors: [Color] = [
                                .white,
                                .yellow,
                                .orange,
                                .red,
                                .pink,
                                .purple,
                                .blue,
                                .green,
                                Color(red: 0.2, green: 0.6, blue: 1.0), // Light blue
                                Color(red: 1.0, green: 0.9, blue: 0.7), // Warm white
                                Color(red: 0.5, green: 0.0, blue: 0.5), // Deep purple
                                Color(red: 0.0, green: 0.8, blue: 0.8)  // Teal
                            ]
                            
                            var body: some View {
                                VStack(spacing: 20) {
                                    Text("Select Color")
                                        .font(.custom("Avenir-Heavy", size: 22))
                                        .foregroundColor(.white)
                                    
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                                        ForEach(colors, id: \.self) { colorOption in
                                            Button(action: {
                                                color = colorOption
                                            }) {
                                                Circle()
                                                    .fill(colorOption)
                                                    .frame(width: 60, height: 60)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(color == colorOption ? Color.white : Color.clear, lineWidth: 3)
                                                    )
                                                    .shadow(color: colorOption.opacity(0.6), radius: 5)
                                            }
                                        }
                                    }
                                    .padding()
                                    
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Done")
                                            .font(.custom("Avenir-Medium", size: 16))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color.blue)
                                            .cornerRadius(15)
                                    }
                                }
                                .padding()
                                .background(Color(red: 0.08, green: 0.08, blue: 0.15))
                            }
                        }

                        


                       
                     

                                         

#Preview{
    HomeView()
}

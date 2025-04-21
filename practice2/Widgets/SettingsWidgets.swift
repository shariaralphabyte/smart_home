import SwiftUI

struct SettingsItem: View {
    var icon: String
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(.blue)
            }
            
            Text(title)
                .font(.custom("Avenir-Medium", size: 16))
                .foregroundColor(.white)
                .padding(.leading, 10)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.custom("Avenir", size: 14))
                    .foregroundColor(.gray)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }
}

struct SettingsItemToggle: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(.blue)
            }
            
            Text(title)
                .font(.custom("Avenir-Medium", size: 16))
                .foregroundColor(.white)
                .padding(.leading, 10)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }
}



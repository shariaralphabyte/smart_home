import SwiftUI
import Charts

// MARK: - Data Models
struct Cryptocurrency: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    let name: String
    let currentPrice: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    let marketCap: Double
    let volume24h: Double
    let sparkline: [Double]
    let iconName: String
}

struct PortfolioItem: Identifiable {
    let id = UUID()
    let cryptocurrency: Cryptocurrency
    let amount: Double
    let value: Double
}

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let source: String
    let timeAgo: String
    let imageName: String
}

// MARK: - Demo Data
extension Cryptocurrency {
    static let demoData: [Cryptocurrency] = [
        Cryptocurrency(
            symbol: "BTC",
            name: "Bitcoin",
            currentPrice: 62345.78,
            priceChange24h: 1245.32,
            priceChangePercentage24h: 2.04,
            marketCap: 1.2e12,
            volume24h: 28.5e9,
            sparkline: [61200, 61500, 61800, 61750, 61900, 62050, 62200, 62345],
            iconName: "bitcoin"
        ),
        Cryptocurrency(
            symbol: "ETH",
            name: "Ethereum",
            currentPrice: 3421.56,
            priceChange24h: -45.32,
            priceChangePercentage24h: -1.31,
            marketCap: 410.5e9,
            volume24h: 18.2e9,
            sparkline: [3460, 3450, 3440, 3435, 3430, 3425, 3420, 3421],
            iconName: "ethereum"
        ),
        Cryptocurrency(
            symbol: "SOL",
            name: "Solana",
            currentPrice: 145.23,
            priceChange24h: 8.76,
            priceChangePercentage24h: 6.42,
            marketCap: 62.3e9,
            volume24h: 3.5e9,
            sparkline: [136, 138, 140, 142, 143, 144, 144.5, 145.2],
            iconName: "solana"
        ),
        Cryptocurrency(
            symbol: "ADA",
            name: "Cardano",
            currentPrice: 0.45,
            priceChange24h: 0.02,
            priceChangePercentage24h: 4.65,
            marketCap: 15.8e9,
            volume24h: 0.8e9,
            sparkline: [0.43, 0.432, 0.435, 0.438, 0.442, 0.445, 0.448, 0.45],
            iconName: "cardano"
        ),
        Cryptocurrency(
            symbol: "DOT",
            name: "Polkadot",
            currentPrice: 6.78,
            priceChange24h: 0.32,
            priceChangePercentage24h: 4.95,
            marketCap: 7.5e9,
            volume24h: 0.5e9,
            sparkline: [6.45, 6.5, 6.55, 6.6, 6.65, 6.7, 6.75, 6.78],
            iconName: "polkadot"
        )
    ]
}

extension PortfolioItem {
    static let demoData: [PortfolioItem] = [
        PortfolioItem(
            cryptocurrency: Cryptocurrency.demoData[0],
            amount: 0.42,
            value: 0.42 * Cryptocurrency.demoData[0].currentPrice
        ),
        PortfolioItem(
            cryptocurrency: Cryptocurrency.demoData[1],
            amount: 3.5,
            value: 3.5 * Cryptocurrency.demoData[1].currentPrice
        ),
        PortfolioItem(
            cryptocurrency: Cryptocurrency.demoData[2],
            amount: 25,
            value: 25 * Cryptocurrency.demoData[2].currentPrice
        ),
        PortfolioItem(
            cryptocurrency: Cryptocurrency.demoData[3],
            amount: 1200,
            value: 1200 * Cryptocurrency.demoData[3].currentPrice
        )
    ]
}

extension NewsItem {
    static let demoData: [NewsItem] = [
        NewsItem(
            title: "Bitcoin ETF Approval Expected by End of Quarter",
            source: "CryptoNews",
            timeAgo: "2h ago",
            imageName: "bitcoinsign.circle.fill" // SF Symbol
        ),
        NewsItem(
            title: "Ethereum Layer 2 Solutions See Record Growth",
            source: "Blockchain Daily",
            timeAgo: "5h ago",
            imageName: "arrow.triangle.2.circlepath.circle.fill" // SF Symbol
        ),
        NewsItem(
            title: "Regulatory Framework for Stablecoins Proposed",
            source: "Finance Times",
            timeAgo: "1d ago",
            imageName: "doc.text.fill" // SF Symbol
        ),
        NewsItem(
            title: "Solana Network Outage Raises Concerns",
            source: "TechCrypto",
            timeAgo: "1d ago",
            imageName: "exclamationmark.triangle.fill" // SF Symbol
        )
    ]
}

// MARK: - Custom Views

// Futuristic gradient background
struct FuturisticBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.05, green: 0.05, blue: 0.15),
                Color(red: 0.1, green: 0.05, blue: 0.2),
                Color(red: 0.15, green: 0.05, blue: 0.25)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(
            AngularGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1),
                    Color.blue.opacity(0.1)
                ]),
                center: .center,
                angle: .degrees(45)
            )
            .blur(radius: 60)
        )
        .ignoresSafeArea()
    }
}

// Glassmorphism card
struct GlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.15),
                        Color.white.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .background(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                .cornerRadius(20)
                )
    }
}

// Animated price change indicator
struct PriceChangeIndicator: View {
    let value: Double
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: value >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                .font(.caption)
                .rotationEffect(value >= 0 ? .degrees(0) : .degrees(180))
            
            Text("\(abs(value), specifier: "%.2f")")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            
            Text("(\(percentage, specifier: "%.2f")%)")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .foregroundColor(value >= 0 ? Color.green : Color.red)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(value >= 0 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
        .cornerRadius(8)
    }
}

// Interactive sparkline chart
struct SparklineChart: View {
    let data: [Double]
    let color: Color
    
    // Precompute min and max values to avoid recalculating
    private var minValue: Double {
        (data.min() ?? 0) * 0.99
    }
    
    private var maxValue: Double {
        (data.max() ?? 0) * 1.01
    }
    
    var body: some View {
        Chart {
            // Extract line marks to a separate function
            lineMarks
            // Extract area marks to a separate function
            areaMarks
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: minValue...maxValue)
        .frame(height: 50)
    }
    
    // Separate computed property for line marks
    @ChartContentBuilder
    private var lineMarks: some ChartContent {
        ForEach(Array(data.enumerated()), id: \.offset) { index, value in
            LineMark(
                x: .value("Index", index),
                y: .value("Value", value)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(color)
        }
    }
    
    // Separate computed property for area marks
    @ChartContentBuilder
    private var areaMarks: some ChartContent {
        ForEach(Array(data.enumerated()), id: \.offset) { index, value in
            AreaMark(
                x: .value("Index", index),
                yStart: .value("Min", minValue),
                yEnd: .value("Value", value)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(areaGradient)
        }
    }
    
    // Separate computed property for gradient
    private var areaGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.3), color.opacity(0.05)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
// Crypto icon with gradient background
struct CryptoIcon: View {
    let iconName: String
    let size: CGFloat
    
    var body: some View {
        Image(iconName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .padding(size * 0.3)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// Segmented control with futuristic style
struct FuturisticSegmentedControl: View {
    @Binding var selectedIndex: Int
    let options: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<options.count, id: \.self) { index in
                Text(options[index])
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(selectedIndex == index ? .white : .white.opacity(0.6))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        selectedIndex == index ?
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.5),
                                Color.purple.opacity(0.5)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(12)
                        .padding(2)
                        : nil
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedIndex = index
                        }
                    }
            }
        }
        .padding(2)
        .background(
            Color.white.opacity(0.1)
                .cornerRadius(14)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Main Views

struct PortfolioSummaryView: View {
    let portfolioItems: [PortfolioItem]
    
    var totalValue: Double {
        portfolioItems.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Portfolio Value")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Text("$\(totalValue, specifier: "%.2f")")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            // Portfolio allocation chart
            Chart(portfolioItems) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: .ratio(0.6),
                    angularInset: 1
                )
                .foregroundStyle(by: .value("Crypto", item.cryptocurrency.symbol))
                .cornerRadius(4)
            }
            .frame(height: 150)
            .chartLegend(position: .bottom, alignment: .center, spacing: 16)
            .chartLegend(.visible)
            
            // Quick actions
            HStack(spacing: 16) {
                ActionButton(icon: "arrow.down", label: "Deposit", color: .blue)
                ActionButton(icon: "arrow.up", label: "Withdraw", color: .green)
                ActionButton(icon: "arrow.left.arrow.right", label: "Swap", color: .purple)
            }
        }
        .padding()
        .background(
            GlassCard {
                EmptyView()
            }
        )
    }
}

struct ActionButton: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.5),
                            color.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(color.opacity(0.5), lineWidth: 1)
                    )
                )
            
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

struct CryptocurrencyListView: View {
    let cryptocurrencies: [Cryptocurrency]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(cryptocurrencies) { crypto in
                CryptocurrencyRow(cryptocurrency: crypto)
            }
        }
    }
}

struct CryptocurrencyRow: View {
    let cryptocurrency: Cryptocurrency
    
    var body: some View {
        HStack(spacing: 12) {
            CryptoIcon(iconName: cryptocurrency.iconName, size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(cryptocurrency.symbol)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("$\(cryptocurrency.currentPrice, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text(cryptocurrency.name)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    PriceChangeIndicator(
                        value: cryptocurrency.priceChange24h,
                        percentage: cryptocurrency.priceChangePercentage24h
                    )
                }
            }
            
            SparklineChart(
                data: cryptocurrency.sparkline,
                color: cryptocurrency.priceChangePercentage24h >= 0 ? .green : .red
            )
            .frame(width: 80, height: 40)
        }
        .padding()
        .background(
            GlassCard {
                EmptyView()
            }
        )
    }
}

struct NewsListView: View {
    let newsItems: [NewsItem]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(newsItems) { item in
                NewsCard(newsItem: item)
            }
        }
    }
}

struct NewsCard: View {
    let newsItem: NewsItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(newsItem.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(newsItem.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack {
                    Text(newsItem.source)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundColor(.white.opacity(0.4))
                    
                    Text(newsItem.timeAgo)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            GlassCard {
                EmptyView()
            }
        )
    }
}

struct MarketOverviewView: View {
    let cryptocurrencies: [Cryptocurrency]
    
    var body: some View {
        VStack(spacing: 16) {
            // Market cap and volume
            HStack(spacing: 16) {
                MarketDataCard(
                    title: "Market Cap",
                    value: "$1.72T",
                    change: "+2.4%",
                    isPositive: true
                )
                
                MarketDataCard(
                    title: "24h Volume",
                    value: "$82.4B",
                    change: "+5.1%",
                    isPositive: true
                )
            }
            
            // Top movers
            VStack(alignment: .leading, spacing: 12) {
                Text("Top Movers (24h)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    TopMoverCard(
                        cryptocurrency: cryptocurrencies[2], // SOL
                        isGainer: true
                    )
                    
                    TopMoverCard(
                        cryptocurrency: cryptocurrencies[3], // ADA
                        isGainer: true
                    )
                    
                    TopMoverCard(
                        cryptocurrency: cryptocurrencies[4], // DOT
                        isGainer: true
                    )
                    
                    TopMoverCard(
                        cryptocurrency: cryptocurrencies[1], // ETH
                        isGainer: false
                    )
                }
            }
            .padding()
            .background(
                GlassCard {
                    EmptyView()
                }
            )
        }
    }
}

struct MarketDataCard: View {
    let title: String
    let value: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            HStack(spacing: 4) {
                Image(systemName: isPositive ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .font(.caption)
                
                Text(change)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isPositive ? Color.green : Color.red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            GlassCard {
                EmptyView()
            }
        )
    }
}

struct TopMoverCard: View {
    let cryptocurrency: Cryptocurrency
    let isGainer: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            CryptoIcon(iconName: cryptocurrency.iconName, size: 30)
            
            Text(cryptocurrency.symbol)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("\(cryptocurrency.priceChangePercentage24h, specifier: "%.1f")%")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(isGainer ? Color.green : Color.red)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isGainer ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .cornerRadius(8)
        }
        .frame(width: 80)
        .padding(.vertical, 12)
        .background(
            GlassCard {
                EmptyView()
            }
        )
    }
}

// MARK: - Main App View

struct CryptoDashboardView: View {
    @State private var selectedTabIndex = 0
    private let tabs = ["Portfolio", "Market", "News"]
    
    var body: some View {
        ZStack {
            FuturisticBackground()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome back,")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("Crypto Trader")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                // Segmented control
                FuturisticSegmentedControl(
                    selectedIndex: $selectedTabIndex,
                    options: tabs
                )
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Main content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        switch selectedTabIndex {
                        case 0: // Portfolio
                            PortfolioSummaryView(portfolioItems: PortfolioItem.demoData)
                                .padding(.horizontal)
                            
                            CryptocurrencyListView(cryptocurrencies: Cryptocurrency.demoData)
                                .padding(.horizontal)
                            
                        case 1: // Market
                            MarketOverviewView(cryptocurrencies: Cryptocurrency.demoData)
                                .padding(.horizontal)
                            
                            CryptocurrencyListView(cryptocurrencies: Cryptocurrency.demoData)
                                .padding(.horizontal)
                            
                        case 2: // News
                            NewsListView(newsItems: NewsItem.demoData)
                                .padding(.horizontal)
                            
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
            
            // Bottom tab bar
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.purple
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .clipShape(Circle())
                            )
                            .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .offset(y: -20)
                    
                    Spacer()
                }
                .frame(height: 80)
                .background(
                    GlassCard {
                        EmptyView()
                    }
                    .edgesIgnoringSafeArea(.bottom)
                )
            }
        }
    }
}



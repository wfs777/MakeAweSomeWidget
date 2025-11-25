// 1. Intent Definition
import AppIntents

// 2. Entry Model
import WidgetKit

// 4. Toggle Style
import SwiftUI


// 5. Widget View
import Combine


struct FlashToggleIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Toggle Flash State"

    func perform() async throws -> some IntentResult {
        let store = UserDefaults(suiteName: "group.com.yourapp")

        // 模拟网络请求
        try await Task.sleep(nanoseconds: 3_000_000_000) // 3秒

        return .result()
    }
}

struct FlashEntry: TimelineEntry {
    let date: Date
    let isFlashing: Bool
}

// 3. Timeline Provider
struct FlashProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> FlashEntry {
        FlashEntry(date: Date(), isFlashing: false)
    }

    func snapshot(for configuration: FlashToggleIntent, in context: Context) async -> FlashEntry {
        let isFlashing = UserDefaults(suiteName: "group.com.yourapp")?.bool(forKey: "isFlashing") ?? false
        return FlashEntry(date: Date(), isFlashing: isFlashing)
    }

    func timeline(for configuration: FlashToggleIntent, in context: Context) async -> Timeline<FlashEntry> {
        let isFlashing = UserDefaults(suiteName: "group.com.yourapp")?.bool(forKey: "isFlashing") ?? false
        let entry = FlashEntry(date: Date(), isFlashing: isFlashing)
        print("Timeline Get in")
        return Timeline(entries: [entry], policy: .never)
    }
}



struct FlashingToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "bolt.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
//                .foregroundColor(configuration.isOn ? .red : .gray)
//                .scaleEffect(configuration.isOn ? 1.2 : 1.0)
//                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true),value: configuration.isOn)
    }
}

struct FlashWidgetEntryView: View {
    var entry: FlashProvider.Entry

    var body: some View {
        VStack {
            Toggle(isOn: true, intent:FlashToggleIntent()){
            }.toggleStyle(FlashingToggleStyle())
        }
        .invalidatableContent()
        .frame(width: 100, height: 100)
        .padding()
        .containerBackground(.clear, for: .widget)
    }

}


struct FlashWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "FlashWidget",
                               intent: FlashToggleIntent.self,
                               provider: FlashProvider()) { entry in
            FlashWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Flashing Toggle")
        .description("A toggle that flashes while performing.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

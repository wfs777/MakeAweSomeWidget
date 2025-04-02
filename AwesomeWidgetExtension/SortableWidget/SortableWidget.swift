import WidgetKit
import SwiftUI

struct WidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), config: SortableWidgetConfigIntent())
    }
    
    func snapshot(for configuration: SortableWidgetConfigIntent, in context: Context) async -> WidgetEntry {
        WidgetEntry(date: Date(), config: configuration)
    }
    
    func timeline(for configuration: SortableWidgetConfigIntent, in context: Context) async -> Timeline<WidgetEntry> {
        let entry = WidgetEntry(date: Date(), config: configuration)
        let refreshDate = Calendar.current.date(byAdding: .minute, value: configuration.refreshInterval, to: Date())!
        return Timeline(entries: [entry], policy: .after(refreshDate))
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let config: SortableWidgetConfigIntent
}

struct WidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: WidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if entry.config.showTitle {
                Text("我的工具")
                    .font(.headline)
                    .foregroundColor(entry.config.background == .dark ? .white : .primary)
            }
            Spacer()
            HStack{
                ForEach(entry.config.items!.prefix(itemCountForFamily)) { item in
                    HStack(spacing: 10) {
                        if let icon = item.icon {
                            Image(systemName: icon)
                                .foregroundColor(.accentColor)
                        }
                        Text(item.title)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
           
        }
        .padding()
        .containerBackground(entry.config.background.color, for: .widget)
    }
    
    private var itemCountForFamily: Int {
        switch family {
        case .systemSmall: return 3
        case .systemMedium: return 6
        default: return 3
        }
    }
}


struct MultiConfigWidget: Widget {
    let kind: String = "MultiConfigWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SortableWidgetConfigIntent.self,
            provider: WidgetProvider()
        ) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("多功能组件")
        .description("支持多项配置和排序的小组件")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

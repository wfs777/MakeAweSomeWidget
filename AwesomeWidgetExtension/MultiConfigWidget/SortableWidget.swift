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
//        print(entry.config.carControls?.count)
//        print(entry.config.items?.count)
        print(entry.config.province?.name)
        print(entry.config.city?.name)
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
                HStack{
                    Text("小组件配置测试")
                        .font(.headline)
                        .foregroundColor(entry.config.background == .dark ? .white : .primary)
                    Text("\(entry.config.province?.name ?? "") - \(entry.config.city?.name ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            HStack{
                ForEach(entry.config.items!.prefix(itemCountForFamily)) { item in
                    HStack(spacing: 6) {
                        if let icon = item.icon {
                            Image(systemName: icon)
                                .foregroundColor(.accentColor)
                        }
                        Text(item.title)
                            .font(.system(size: 10))
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            Spacer()
            HStack {
                ForEach(entry.config.carControls ?? []) { carcontrol in
                    Text(carcontrol.displayString).font(.subheadline)
                        .foregroundColor(.secondary)
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

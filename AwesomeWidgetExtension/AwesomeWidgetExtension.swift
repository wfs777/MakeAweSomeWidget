//
//  AwesomeWidgetExtension.swift
//  AwesomeWidgetExtension
//
//  Created by zhuruiqi6 on 2025/4/2.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    private let sharedDefaults = UserDefaults(suiteName: "group.com.awesomeapp.shared")

    func placeholder(in context: Context) -> StatusEntry {
        StatusEntry(date: Date(), status: "⏳ 加载中...", lastUpdated: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> StatusEntry {
        let lastUpdated = Date()

        switch context.family {
        case .systemMedium:
            return StatusEntry(date: Date(), status: "✅ 正常运行", lastUpdated: lastUpdated, configuration: ConfigurationAppIntent())

        case .systemLarge:
            return StatusEntry(date: Date(), status: "✅ 正常运行\n⚠️ 轻微警告", lastUpdated: lastUpdated, configuration: ConfigurationAppIntent())

        default:
            return StatusEntry(date: Date(), status: "⏳ 加载中...", lastUpdated: lastUpdated, configuration: ConfigurationAppIntent())
        }
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<StatusEntry> {
//        let status = getStatusFromStorage()
        let (status, lastUpdated) = await fetchStatusAndUpdateStorage()
        var entries: [StatusEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let entry = StatusEntry(date: currentDate, status: status, lastUpdated: lastUpdated, configuration: configuration)
        entries.append(entry)
        let nextUpdate = Date().addingTimeInterval(60 * 1)
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
    func fetchStatusAndUpdateStorage() async -> (String, Date) {
        let status = await APIService.shared.fetchStatus()
        let lastUpdated = Date()
        sharedDefaults?.set(status, forKey: "widget_status")
        sharedDefaults?.set(lastUpdated.timeIntervalSince1970, forKey: "widget_lastUpdated")
        sharedDefaults?.synchronize()

        return (status, lastUpdated)
    }

    private func getStatusFromStorage() -> String {
        guard let savedStatus = sharedDefaults?.string(forKey: "widget_status") else {
            return "No data"
        }
        return savedStatus
    }
}

struct StatusEntry: TimelineEntry {
    let date: Date
    let status: String
    let lastUpdated: Date
    let configuration: ConfigurationAppIntent
}

struct AwesomeWidgetExtensionEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            mediumWidgetView().containerBackground(for: .widget) { // ✅ 解决背景问题
                Color(.systemBackground)
            }
        case .systemLarge:
            largeWidgetView().containerBackground(for: .widget) { // ✅ 解决背景问题
                Color(.systemBackground)
            }
        default:
            mediumWidgetView().containerBackground(for: .widget) { // ✅ 解决背景问题
                Color(.systemBackground)
            }
        }
    }

    /// **🔹 中尺寸 Widget**
    private func mediumWidgetView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("📊 状态")
                    .font(.headline)
                Text(entry.status)
                    .font(.title)
                    .bold()
            }
            Spacer()
            VStack {
                Text("🕒 \(formattedDate(entry.lastUpdated))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Button(intent: RefreshStatusIntent()) {
                    Text("🔄 刷新")
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
        }
        .padding()
    }

    /// **🔹 大尺寸 Widget**
    private func largeWidgetView() -> some View {
        VStack(spacing: 12) {
            Text("📊 状态")
                .font(.title2)
                .bold()
            Text(entry.status)
                .font(.title)
                .bold()

            Text("🕒 上次更新: \(formattedDate(entry.lastUpdated))")
                .font(.footnote)
                .foregroundColor(.gray)

            Button(intent: RefreshStatusIntent()) {
                Text("🔄 刷新")
                    .font(.body)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        
    }

    /// **格式化时间**
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}

struct AwesomeWidgetExtension: Widget {
    let kind: String = "AwesomeWidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            AwesomeWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("状态小组件")
        .description("显示任务状态，并支持手动刷新")
        .supportedFamilies(families)
    }

    var families: [WidgetFamily] {
        if #available(iOSApplicationExtension 17.0, watchOS 9.0, *) {
            return [.systemMedium, .systemLarge] // .accessoryCircular,.accessoryRectangular, .accessoryInline 锁屏小组件
        } else {
            return [.systemMedium]
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }

    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
}

// #Preview(as: .systemSmall) {
//    AwesomeWidgetExtension()
// } timeline: {
//    StatusEntry(date: .now, status: "test", configuration: .smiley)
//    StatusEntry(date: .now, status: "APB", configuration: .starEyes)
// }

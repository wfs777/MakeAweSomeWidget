//
//  BuildWidget.swift
//  MakeAwesomeWidget
//
//  Created by zhuruiqi6 on 2025/12/4.
//
import SwiftUI
import WidgetKit
import AppIntents

struct BuildEntry: TimelineEntry {
    let date: Date
    let deviceName: String
    let area: String
    let isOn: Bool
    let lastUpdated: Date
}

struct BuildIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "构建预览配置" }
}

struct BuildProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BuildEntry {
        BuildEntry(date: Date(), deviceName: "继电器", area: "Area 1", isOn: false, lastUpdated: Date())
    }

    func snapshot(for configuration: BuildIntent, in context: Context) async -> BuildEntry {
        BuildEntry(date: Date(), deviceName: "继电器", area: "Area 1", isOn: false, lastUpdated: Date())
    }

    func timeline(for configuration: BuildIntent, in context: Context) async -> Timeline<BuildEntry> {
        let now = Date()
        let entry = BuildEntry(date: now, deviceName: "继电器", area: "Area 1", isOn: false, lastUpdated: now)
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 15)))
    }
}

struct BuildWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: BuildProvider.Entry

    var body: some View {
        smallView
    }

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "cpu")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.purple)
                Spacer()
                ZStack {
                    Circle().fill(Color(.secondarySystemBackground))
                    Image(systemName: "power")
                        .foregroundColor(entry.isOn ? .green : .gray)
                }
                .frame(width: 40, height: 40)
            }
            Spacer()
            Text(entry.deviceName)
                .font(.headline)
                .foregroundColor(.primary)

            HStack(spacing: 4) {
                Text(entry.area)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(entry.isOn ? "开启" : "关闭")
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.1))
                    .clipShape(Capsule())
            }
            .font(.footnote)
            .foregroundColor(.secondary)


            HStack {
                Text("\(timeString(entry.lastUpdated))Updated")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 20)
                    
            }
        }
        .padding()
    }
    
    private var failView: some View {
        ZStack {
            Color.white
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                Text("操作失败")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
    }


    private func timeString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}

struct BuildWidget: Widget {
    let kind: String = "BuildWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: BuildIntent.self, provider: BuildProvider()) { entry in
            BuildWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("构建预览")
        .description("用于 SwiftUI 预览的卡片样式")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    BuildWidget()
} timeline: {
    BuildEntry(date: .now, deviceName: "继电器", area: "Area 1", isOn: false, lastUpdated: .now)
}

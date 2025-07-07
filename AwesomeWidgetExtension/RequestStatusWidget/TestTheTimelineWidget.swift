//
//  TestTheTimelineWidget.swift
//  AwesomeWidgetExtensionExtension
//
//  Created by zhuruiqi6 on 2025/4/14.
//

import WidgetKit
import SwiftUI
import AppIntents

// MARK: - 小组件数据源
struct TestTheTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> TestTheTimelineEntry {
        TestTheTimelineEntry(date: Date(), status: "加载中...")
    }

    func getSnapshot(in context: Context, completion: @escaping (TestTheTimelineEntry) -> ()) {
        let entry = TestTheTimelineEntry(date: Date(), status: WidgetState.shared.status)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TestTheTimelineEntry>) -> ()) {
        let now = Date()
        let calendar = Calendar.current
        
        // 精确对齐当前分钟（即秒数归零）
        let currentMinute = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now))!
        
        var entries: [TestTheTimelineEntry] = []
        
        // 生成60分钟的Entry
        for minuteOffset in 0..<60 {
            let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: currentMinute)!
            let entry = TestTheTimelineEntry(date: entryDate, status: WidgetState.shared.status)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - 小组件的Entry
struct TestTheTimelineEntry: TimelineEntry {
    let date: Date
    let status: String
}

// MARK: - 小组件视图
struct TestTheTimelineWidgetEntryView: View {
    var entry: TestTheTimelineProvider.Entry

    var body: some View {
        VStack(spacing: 12) {
            // 当前时间
            Text(entry.date, style: .time)
                .font(.largeTitle)
                .bold()

            // 当前状态
            Text(entry.status)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            // 触发请求按钮
            Button(intent: TriggerRequestIntent()) {
                Text("开始请求")
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

// MARK: - 小组件定义
struct TestTheTimelineWidget: Widget {
    let kind: String = "TestTheTimelineWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: TestTheTimelineProvider()) { entry in
            TestTheTimelineWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("请求状态小组件")
        .description("点击按钮发起请求并更新状态")
        .supportedFamilies([.systemMedium])
    }
}

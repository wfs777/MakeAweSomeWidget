//
//  ContentView.swift
//  MakeAwesomeWidget
//
//  Created by zhuruiqi6 on 2025/4/2.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    var body: some View {
        VStack {
            Text("当前状态: \(dataManager.status)")
                .font(.title)
                .padding()
            
            Button("获取新状态") {
                dataManager.fetchNewStatus()
            }
            .padding()
            
            Toggle("自动刷新", isOn: .constant(false)).padding()
                
            ProgressView("加载中...").progressViewStyle(CircularProgressViewStyle(tint: .blue)).padding()
            
        }
    }
}

#Preview {
    ContentView()
}

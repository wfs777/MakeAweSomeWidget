//
//  APIService.swift
//  MakeAwesomeWidget
//
//  Created by zhuruiqi6 on 2025/4/2.
//

import Foundation

struct APIService {
    static let shared = APIService()

    func fetchStatus() async -> String {
        // 模拟网络延迟 1.5 秒
        try? await Task.sleep(nanoseconds: 1500000000)

        // 返回一个假数据
        let fakeStatuses = ["⚡️ 进行中"]
        return fakeStatuses.randomElement()!
    }
}

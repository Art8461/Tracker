//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Artem Kuzmenko on 19.12.2025.
//

import Foundation
import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard
            let rawKey = Bundle.main.object(forInfoDictionaryKey: "AppMetricaAPIKey") as? String
        else {
            print("AnalyticsService: missing AppMetricaAPIKey")
            return
        }
        
        let apiKey = rawKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard
            apiKey.isEmpty == false,
            apiKey != "REPLACE_ME",
            apiKey != "YOUR_APP_METRICA_API_KEY",
            let configuration = AppMetricaConfiguration(apiKey: apiKey)
        else {
            print("AnalyticsService: missing AppMetricaAPIKey")
            return
        }
        
        AppMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

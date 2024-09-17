//
//  LanguageManager.swift
//  SafeApp
//
//  Created by Minh Tran Nguyen Anh on 17/9/24.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "vi"
    
    // Func to change the language inside app
    func setLanguage(_ language: String) {
        selectedLanguage = language
    }
}

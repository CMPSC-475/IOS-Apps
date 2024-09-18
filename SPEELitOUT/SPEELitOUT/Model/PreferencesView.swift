//
//  PreferencesView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/18/24.
//

import Foundation
import SwiftUI

struct PreferencesView: View {
    @Binding var preferences: Preferences

    var body: some View {
        Form {
            Section(header: Text("Difficulty Level")) {
                Picker("Letter Count", selection: $preferences.letterCount) {
                    ForEach(LetterCount.allCases) { count in
                        Text("\(count.rawValue)").tag(count)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Language")) {
                Picker("Language", selection: $preferences.language) {
                    ForEach(Language.allCases) { language in
                        Text(language.rawValue).tag(language)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

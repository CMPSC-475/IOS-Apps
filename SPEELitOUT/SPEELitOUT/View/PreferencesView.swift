//
//  PreferencesView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/18/24.
//

import Foundation
import SwiftUI

struct PreferencesView: View {
    @Binding var isPresented: Bool
    @Binding var preferences: Preferences
    var onPreferencesUpdated: (Preferences) -> Void

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            Image(systemName: "gearshape")
                .font(.title2)
                .foregroundColor(.white)
        }
        .sheet(isPresented: $isPresented) {
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
                
                Button("Done") {
                    isPresented = false  // Close the preferences view
                    onPreferencesUpdated(preferences) // Notify of the preference change
                }
            }
        }
    }
}



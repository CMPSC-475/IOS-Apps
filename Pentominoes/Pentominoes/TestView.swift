//
//  TestView.swift
//  Pentominoes
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/1/24.
//

import Foundation
import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            Button(action: {
                print("Button pressed")
            }) {
                Image("Board0")  // Make sure "Board0" exists in Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .border(Color.black, width: 1)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

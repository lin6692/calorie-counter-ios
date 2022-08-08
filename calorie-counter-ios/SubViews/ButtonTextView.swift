//
//  ButtonTextView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/7/22.
//

import SwiftUI

struct ButtonTextView: View {
    var label:String
    var body: some View {
            return Text(label)
            .frame(width: 120, height: 30)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .font(.system(size:15, weight:.bold))
            .cornerRadius(7)
        }
}

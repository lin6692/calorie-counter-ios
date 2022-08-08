//
//  PieChart.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/5/22.
//

import SwiftUI

struct PieChart: View {
  var data: [Double]
  @Binding var labels: [String]
  
  private let colors: [Color]
  private let borderColor: Color
  private let sliceOffset: Double = -.pi / 2
  
  
  init(data: [Double], labels: Binding<[String]>, colors: [Color], borderColor: Color) {
    self.data = data
    self._labels = labels
    self.colors = colors
    self.borderColor = borderColor
  }
  
  var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .center) {
        ForEach(0 ..< data.count) { index in
          PieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
            .fill(colors[index % colors.count])
          
          PieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
            .stroke(borderColor, lineWidth: 1)
          
          PieSliceText(
            title: "\(labels[index])",
            description: String(format: "%.2f%%", data[index]*100)
          )
          .offset(textOffset(for: index, in: geo.size))
          .zIndex(1)
        }
      }
    }
  }
  
  private func startAngle(for index: Int) -> Double {
    switch index {
      case 0:
        return sliceOffset
      default:
        let ratio: Double = data[..<index].reduce(0.0, +) / data.reduce(0.0, +)
        return sliceOffset + 2 * .pi * ratio
    }
  }
  
  private func endAngle(for index: Int) -> Double {
    switch index {
      case data.count - 1:
        return sliceOffset + 2 * .pi
      default:
        let ratio: Double = data[..<(index + 1)].reduce(0.0, +) / data.reduce(0.0, +)
        return sliceOffset + 2 * .pi * ratio
    }
  }
  
  private func textOffset(for index: Int, in size: CGSize) -> CGSize {
    let radius = min(size.width, size.height) / 3
    let dataRatio = (2 * data[..<index].reduce(0, +) + data[index]) / (2 * data.reduce(0, +))
    let angle = CGFloat(sliceOffset + 2 * .pi * dataRatio)
    return CGSize(width: radius * cos(angle), height: radius * sin(angle))
  }
}



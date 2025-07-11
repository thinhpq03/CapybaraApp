//
//  PieChartView.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 12/6/25.
//

import UIKit

class PieChartView: UIView {
    private var data: [(String, Int)]
    private var colors: [UIColor]
    init(frame: CGRect, data: [(String, Int)], colors: [UIColor]) {
        self.data = data
        self.colors = colors
        super.init(frame: frame)
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext(), data.count > 0 else { return }
        let total = data.reduce(0) { $0 + $1.1 }
        var startAngle: CGFloat = -.pi / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.45
        for (idx, item) in data.enumerated() {
            ctx.setFillColor(colors[idx % colors.count].cgColor)
            let angle = CGFloat(item.1) / CGFloat(total) * 2 * .pi
            ctx.move(to: center)
            ctx.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: startAngle + angle, clockwise: false)
            ctx.fillPath()
            startAngle += angle
        }
    }
}

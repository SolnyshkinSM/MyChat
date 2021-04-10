//
//  GraphicsImageRenderer.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import UIKit

// MARK: - GraphicsImageRenderer

class GraphicsImageRenderer {
    
    func drawSymbolsOnButton(button: UIButton, of text: String) {
        
        let renderer = UIGraphicsImageRenderer(size: button.bounds.size)
        let image = renderer.image { (context) in
            
            context.stroke(renderer.format.bounds)
            #colorLiteral(red: 0.8941176471, green: 0.9098039216, blue: 0.168627451, alpha: 1).setFill()
            context.fill(renderer.format.bounds)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let font = UIFont.systemFont(ofSize: button.bounds.height * 0.6)
            let offset = font.capHeight - font.ascender
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: offset,
                .kern: 0
            ]
            
            text.draw(with: renderer.format.bounds,
                                options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }
        
        button.setBackgroundImage(image, for: .normal)
    }
}

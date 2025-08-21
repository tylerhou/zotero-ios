//
//  PSPDFKItAnnotation+Extensions.swift
//  Zotero
//
//  Created by Michal Rentka on 06.03.2024.
//  Copyright © 2024 Corporation for Digital Scholarship. All rights reserved.
//

import Foundation

import PSPDFKit

extension PSPDFKit.Annotation.Variant {
    static let eraserStroke = PSPDFKit.Annotation.Variant("eraserStroke")
}

extension AnnotationTool {
    struct ToolAndVariant: Equatable {
        var tool: PSPDFKit.Annotation.Tool
        var variant: PSPDFKit.Annotation.Variant?
    }

    var toolAndVariant: ToolAndVariant {
        switch self {
        case .eraser:
            return ToolAndVariant(tool: .eraser, variant: nil)

        case .strokeEraser:
            return ToolAndVariant(tool: .eraser, variant: .eraserStroke)

        case .highlight:
            return ToolAndVariant(tool: .highlight, variant: nil)

        case .image:
            return ToolAndVariant(tool: .square, variant: nil)

        case .ink:
            return ToolAndVariant(tool: .ink, variant: nil)

        case .note:
            return ToolAndVariant(tool: .note, variant: nil)

        case .freeText:
            return ToolAndVariant(tool: .freeText, variant: nil)

        case .underline:
            return ToolAndVariant(tool: .underline, variant: nil)
        }
    }

    static func ofToolAndVariant(_ tav: ToolAndVariant) -> AnnotationTool? {
        let (tool, variant) = (tav.tool, tav.variant)
        return ofToolAndVariant(tool, variant)
    }

    static func ofToolAndVariant(_ tool: PSPDFKit.Annotation.Tool, _ variant: PSPDFKit.Annotation.Variant?) -> AnnotationTool? {
        switch (tool, variant) {
        case (.eraser, nil):
            return .eraser

        case (.eraser, .eraserStroke):
            return .strokeEraser

        case (.highlight, nil):
            return .highlight

        case (.ink, nil):
            return .ink

        case (.note, nil):
            return .note

        case (.freeText, nil):
            return .freeText

        case (.underline, nil):
            return .underline

        default:
            return nil
        }
    }
}

extension PSPDFKit.Annotation.Kind {
    var annotationType: AnnotationType? {
        switch self {
        case .note:
            return .note

        case .highlight:
            return .highlight

        case .square:
            return .image

        case .ink:
            return .ink

        case .underline:
            return .underline

        case .freeText:
            return .freeText

        default:
            return nil
        }
    }
}

extension AnnotationType {
    var kind: PSPDFKit.Annotation.Kind {
        switch self {
        case .note:
            return .note

        case .highlight:
            return .highlight

        case .image:
            return .square

        case .ink:
            return .ink

        case .underline:
            return .underline

        case .freeText:
            return .freeText
        }
    }
}

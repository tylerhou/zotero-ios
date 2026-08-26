//
//  PDFReaderAnnotationSettings.swift
//  Zotero
//
//  Created by Tyler Hou on 08.25.2026.
//  Copyright © 2026 Corporation for Digital Scholarship. All rights reserved.
//

import Foundation

import PSPDFKitUI

struct PDFReaderAnnotationSettings {
    var drawCreateMode: DrawCreateMode

    static var `default`: PDFReaderAnnotationSettings {
        return PDFReaderAnnotationSettings(drawCreateMode: .automatic)
    }
}

extension PDFReaderAnnotationSettings: Codable {
    enum Keys: String, CodingKey {
        case drawCreateMode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let drawCreateModeRaw = (try? container.decode(UInt.self, forKey: .drawCreateMode)) ?? DrawCreateMode.automatic.rawValue

        self.drawCreateMode = DrawCreateMode(rawValue: drawCreateModeRaw) ?? .automatic
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.drawCreateMode.rawValue, forKey: .drawCreateMode)
    }
}

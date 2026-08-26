//
//  AnnotationToolsSettingsState.swift
//  Zotero
//
//  Created by Michal Rentka on 12.12.2025.
//  Copyright © 2025 Corporation for Digital Scholarship. All rights reserved.
//

import UIKit

import PSPDFKitUI

struct AnnotationToolsSettingsState: ViewModelState {
    enum Section: Int {
        case pdf
        case htmlEpub
    }

    var pdfTools: [AnnotationToolButton]
    var htmlEpubTools: [AnnotationToolButton]
    var pdfDrawCreateMode: DrawCreateMode

    init(pdfAnnotationTools: [AnnotationToolButton], htmlEpubAnnotationTools: [AnnotationToolButton], pdfDrawCreateMode: DrawCreateMode) {
        pdfTools = pdfAnnotationTools
        htmlEpubTools = htmlEpubAnnotationTools
        self.pdfDrawCreateMode = pdfDrawCreateMode
    }

    mutating func cleanup() {
    }
}

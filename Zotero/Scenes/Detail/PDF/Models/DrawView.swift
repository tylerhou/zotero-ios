//
//  DrawView.swift
//  Zotero
//
//  Created by Tyler Hou on 08.25.2026.
//  Copyright © 2026 Corporation for Digital Scholarship. All rights reserved.
//

import PSPDFKit
import PSPDFKitUI

final class DrawView: PSPDFKitUI.DrawView {
    private var gestureTargetAdded = false
    private var activeRecorder: (any PSPDFKit.DetachedUndoRecorder)?

    private var erasedAnnotationIds: Set<ObjectIdentifier> = []
    // Stores all ink annotations on the page when the erase gesture begins.
    // We must re-read annotations because PSPDFKit does not repopulate
    // `self.annotations` when an erase is undone.
    private var actualAnnotations: [Annotation] = []

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil && !gestureTargetAdded {
            gestureTargetAdded = true
            drawGestureRecognizer.addTarget(self, action: #selector(drawingGestureChanged(_:)))
        }
    }

    @objc private func drawingGestureChanged(_ recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if annotationVariant == .eraserStroke, let pageView, let document = pageView.presentationContext?.document {
                erasedAnnotationIds = []
                actualAnnotations = document.annotationsForPage(at: pageView.pageIndex, type: .ink)
                activeRecorder = document.undoController.beginRecordingCommand(named: nil)
                // PSPDFKit sizes the erase overlay when an erase gesture begins only for the built-in eraser.
                // With a custom variant the radius stays at its default, so we size it ourselves.
                // NB: `circleShape` is private as of PSPDFKit 26.8.0.
                if responds(to: Selector(("circleShape"))) {
                    (value(forKey: "circleShape") as? EraseOverlay)?.circleRadius = lineWidth
                }
            }

        case .cancelled, .ended, .failed:
            activeRecorder?.commit()
            activeRecorder = nil
            actualAnnotations = []
            erasedAnnotationIds = []

        default:
            break
        }
    }

    override func erase(at locations: [NSValue]) {
        if annotationVariant != .eraserStroke {
            return super.erase(at: locations)
        }

        for loc in locations {
            let point = loc.drawingPointValue.location
            for annotation in actualAnnotations {
                let id = ObjectIdentifier(annotation)
                if !annotation.hitTest(point, minDiameter: self.lineWidth)
                    || erasedAnnotationIds.contains(id) { continue }
                erasedAnnotationIds.insert(id)
                activeRecorder?.record(removing: [annotation]) {
                    annotation.document?.remove(annotations: [annotation], options: nil)
                }
            }
        }
    }
}

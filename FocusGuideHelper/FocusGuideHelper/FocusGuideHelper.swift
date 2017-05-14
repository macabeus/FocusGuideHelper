//
//  FocusGuideHelper.swift
//  FocusGuideHelper
//
//  Created by Bruno Macabeus Aquino on 12/05/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

public enum Pos {
    case up
    case left
    case down
    case right
}

struct FocusGuideIdentified {
    let identifier: String?
    let focus: UIFocusGuide
}

struct FocusGuideConditional {
    let focusGuideIdentified: FocusGuideIdentified
    let condition: (UIFocusUpdateContext) -> (Bool)
}

public class FocusGuideHelper: NSObject {
    
    private var arrayFocus: [FocusGuideIdentified] = []
    private var arrayFocusAutoexclude: [FocusGuideConditional] = []
    private var arrayFocusActivedWhen: [FocusGuideConditional] = []
    
    private func createFocusGuide(from fromView: UIView, to toView: UIView, inPosition pos: Pos, identifier: String?) -> FocusGuideIdentified {
        
        // initialize focus guide
        let focusGuide = UIFocusGuide()
        fromView.addLayoutGuide(focusGuide)
        
        // set pos and size
        switch pos {
        case .up:
            focusGuide.widthAnchor.constraint(equalTo: fromView.widthAnchor).isActive = true
            focusGuide.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            focusGuide.bottomAnchor.constraint(equalTo: fromView.topAnchor, constant: -5).isActive = true
            
        case .down:
            focusGuide.widthAnchor.constraint(equalTo: fromView.widthAnchor).isActive = true
            focusGuide.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            focusGuide.topAnchor.constraint(equalTo: fromView.bottomAnchor, constant: 5).isActive = true
            
        case .left:
            focusGuide.widthAnchor.constraint(equalToConstant: 1).isActive = true
            focusGuide.heightAnchor.constraint(equalTo: fromView.heightAnchor).isActive = true
            
            focusGuide.trailingAnchor.constraint(equalTo: fromView.leadingAnchor, constant: -(focusGuide.layoutFrame.width * 2) - 1).isActive = true
            
        case .right:
            focusGuide.widthAnchor.constraint(equalToConstant: 1).isActive = true
            focusGuide.heightAnchor.constraint(equalTo: fromView.heightAnchor).isActive = true
            
            focusGuide.leadingAnchor.constraint(equalTo: fromView.trailingAnchor, constant: 2).isActive = true
        }
        
        // set constrains
        focusGuide.centerYAnchor.constraint(equalTo: fromView.centerYAnchor).isActive = true
        
        // set element target
        focusGuide.preferredFocusEnvironments = [toView]
        
        //
        return FocusGuideIdentified(identifier: identifier, focus: focusGuide)
    }
    
    public func addLinkByFocus(from fromView: UIView, to toView: UIView, inPosition pos: Pos, identifier: String? = nil) {
        
        if let identifier = identifier,
            let index = arrayFocus.index(where: { $0.identifier == identifier }) {
            
            arrayFocus[index].focus.isEnabled = false
            arrayFocus.remove(at: index)
        }
        
        let x = createFocusGuide(from: fromView, to: toView, inPosition: pos, identifier: identifier)
        arrayFocus.append(x)
    }
    
    public func addLinkByFocusTemporary(from view1: UIView, to view2: UIView, inPosition pos: Pos) {
        
        let newFocus = createFocusGuide(from: view1, to: view2, inPosition: pos, identifier: nil)
        
        let focused = UIScreen.main.focusedItem!
        let focusGuideTemp = FocusGuideConditional(
            focusGuideIdentified: newFocus,
            condition: { context in
                return context.previouslyFocusedItem?.isEqual(focused) == true
            }
        )
        
        arrayFocusAutoexclude.append(focusGuideTemp)
    }
    
    public func addLinkByFocus(from fromView: UIView, to toView: UIView, inPosition pos: Pos, identifier: String? = nil, autoexcludeWhen condition: @escaping (UIFocusUpdateContext) -> (Bool)) {
        
        if let identifier = identifier,
            let index = arrayFocusAutoexclude.index(where: { $0.focusGuideIdentified.identifier == identifier }) {
            
            arrayFocusAutoexclude[index].focusGuideIdentified.focus.isEnabled = false
            arrayFocusAutoexclude.remove(at: index)
        }
        
        let newFocus = createFocusGuide(from: fromView, to: toView, inPosition: pos, identifier: identifier)
        
        arrayFocusAutoexclude.append(
            FocusGuideConditional(focusGuideIdentified: newFocus, condition: condition)
        )
    }
    
    public func addLinkByFocus(from fromView: UIView, to toView: UIView, inPosition pos: Pos, identifier: String? = nil, activedWhen condition: @escaping (UIFocusUpdateContext) -> (Bool)) {

        if let identifier = identifier,
            let index = arrayFocusActivedWhen.index(where: { $0.focusGuideIdentified.identifier == identifier }) {
            
            arrayFocusActivedWhen[index].focusGuideIdentified.focus.isEnabled = false
            arrayFocusActivedWhen.remove(at: index)
        }
        
        let newFocus = createFocusGuide(from: fromView, to: toView, inPosition: pos, identifier: identifier)
        
        arrayFocusActivedWhen.append(
            FocusGuideConditional(focusGuideIdentified: newFocus, condition: condition)
        )
    }
    
    // update
    public func updateFocus(in context: UIFocusUpdateContext) {
        // update focus autoexclude
        var iteratorAutoexclude = arrayFocusAutoexclude.makeIterator()
        while let element = iteratorAutoexclude.next() {
            
            if element.condition(context) {
                element.focusGuideIdentified.focus.isEnabled = false
                
                //arrayFocus.remove(at: arrayFocus.index(where: { i in i.identifier == element.focusGuideIdentified.identifier })!)
                arrayFocusAutoexclude = arrayFocusAutoexclude.filter {
                    $0.focusGuideIdentified.focus != element.focusGuideIdentified.focus
                }
            }
            
        }
        
        // update disable/enable focus
        arrayFocusActivedWhen.forEach {
            $0.focusGuideIdentified.focus.isEnabled = $0.condition(context)
        }
    }
}

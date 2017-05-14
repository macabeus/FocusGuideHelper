//
//  ViewController.swift
//  Example
//
//  Created by Bruno Macabeus Aquino on 12/05/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import FocusGuideHelper

class ViewController: UIViewController {

    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button31: UIButton!
    @IBOutlet weak var button22: UIButton!
    @IBOutlet weak var button13: UIButton!
    @IBOutlet weak var button33: UIButton!
    let guideHelper = FocusGuideHelper()
    var previusRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guideHelper.addLinkByFocus(
            from: button11,
            to: button22,
            inPosition: .right
        )
        
        guideHelper.addLinkByFocus(
            from: button31,
            to: button22,
            inPosition: .right
        )
        
        guideHelper.addLinkByFocus(
            from: button22,
            to: button11,
            inPosition: .left,
            activedWhen: { _ in
                self.previusRow == 1
            }
        )
        
        guideHelper.addLinkByFocus(
            from: button22,
            to: button31,
            inPosition: .left,
            activedWhen: {  _ in
                self.previusRow == 3
            }
        )
        
        guideHelper.addLinkByFocus(
            from: button22,
            to: button13,
            inPosition: .right,
            activedWhen: { _ in
                self.previusRow == 1
            }
        )
        
        guideHelper.addLinkByFocus(
            from: button22,
            to: button33,
            inPosition: .right,
            activedWhen: { _ in
                self.previusRow == 3
            }
        )

        guideHelper.addLinkByFocus(
            from: button33,
            to: button22,
            inPosition: .left
        )
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.previouslyFocusedView == button11 || context.previouslyFocusedView == button13 {
            previusRow = 1
        } else if context.previouslyFocusedView == button22 {
            previusRow = 2
        } else {
            previusRow = 3
        }
        
        guideHelper.updateFocus(in: context)
    }
}

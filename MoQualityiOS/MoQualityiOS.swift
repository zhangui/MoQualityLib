//
//  MoQualityiOS.swift
//  MoQualityiOS
//
//  Created by Yang Zhang on 2/19/19.
//  Copyright © 2019 Yang Zhang. All rights reserved.
//
import UIKit


public protocol SwizzlingInjection: class {
    static func inject()
}

public class SwizzlingHelper {

    private static let doOnce: Any? = {
        UIViewController.inject()
        UITextField.inject()
        UIAlertAction.inject()
        UIApplication.inject()
        UIPressesEvent.inject()

        return nil
    }()

    static func enableInjection() {
        _ = SwizzlingHelper.doOnce
    }
}

public class MoQualityiOS: UIWindow {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //        if !isUserInteractionEnabled || isHidden || alpha <= 0.01 {
        //            return nil
        //        }

        /*if self.point(inside: point, with: event) {
         for subviewWithOffset in subviews.enumerated().reversed() {
         let subview = subviewWithOffset.element
         let convertedPoint = subview.convert(point, from: self)
         let hitTestView = subview.hitTest(convertedPoint, with: event)
         if hitTestView != nil {
         //                    hitTestView.
         return hitTestView
         }
         }
         return self
         }
         return nil*/

        //print("CGPoint: " + String(point.x.description) + ", " + String(point.y.description))
        let view = super.hitTest(point, with: event)
        /*var view = originalView
         //        var scrollView = view
         while (view?.isKind(of: UIScrollView.self) ?? false == false && view?.superview != nil) {
         if view?.superview != nil {
         view = view?.superview
         }
         }

         if view?.isKind(of: UIScrollView.self) ?? false {
         if let scrollView = view as? UIScrollView {
         print(scrollView.contentOffset)
         //                scrollView.
         }
         } else if let view = view, view.superview?.isKind(of: UIScrollView.self) ?? false {
         if let scrollView = view.superview as? UIScrollView {
         print(scrollView.contentOffset)
         }
         }*/
        if view?.isKind(of: UIStepper.self) ?? false {
            if let stepper = view as? UIStepper {
                print(stepper.value)
            }
        }
        /*if let touches = event?.allTouches {
         //print(view?.touchesEnded(touches, with: event));
         print(view?.touchesBegan(touches, with: event));
         }*/
        //print(view?.frame ?? "")
        // 2
        //let delimiter = ":"
        if let gestureRecognizers = view?.gestureRecognizers {
            for gesture in gestureRecognizers {
                if gesture.isKind(of: UISwipeGestureRecognizer.self), let view = view?.superview {
                    //handleSwipeGesture(gesture: gesture as! UISwipeGestureRecognizer, view: view)
                }
            }
        }
        //var token = newstr.components(separatedBy: delimiter)
        //print(token[0])
        //        print(newstr)
        return view
    }

    private func handleSwipeGesture(gesture: UISwipeGestureRecognizer, view: UIView) {
        //print(view.frame)
        var locationOfBeganTap: CGPoint = CGPoint(x: 0, y: 0)

        var locationOfEndTap: CGPoint = CGPoint(x: 0, y: 0)

        //        gesture.lo
        if gesture.state == UIGestureRecognizer.State.began {
            //            gesture.delaysTouchesBegan
            locationOfBeganTap = gesture.location(in: gesture.view)

        } else if gesture.state == UIGestureRecognizer.State.ended {

            locationOfEndTap = gesture.location(in: gesture.view)

        }

        print("\(locationOfBeganTap), \(locationOfEndTap)")
    }

    override public func sendEvent(_ event: UIEvent) {
        //        print(event.timestamp)
        super.sendEvent(event)
        if let touches = event.allTouches {
            for touch in touches {
                //                print(touch.timestamp)
                //                print(touch.location(in: touch.view))
            }
        }
    }
}


extension UIApplication {

    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        SwizzlingHelper.enableInjection()
        return super.next
    }

}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }

    var scrollView: UIView? {
        //guard !isFirstResponder else { return self }

        for subview in subviews {
            if subview.isKind(of: UIScrollView.self) {
                return subview
            }
        }

        return nil
    }
}

extension UIViewController: SwizzlingInjection {

    //    open override class func initialize() {
    //        // make sure this isn't a subclass
    //        guard self === UIViewController.self else { return }
    //        swizzling(self)
    //    }

    public static func inject() {
        // make sure this isn't a subclass
        guard self === UIViewController.self else { return }
        swizzlingUIViewController(self)
    }

    // MARK: - Method Swizzling

    @objc func swizzledViewWillAppear(animated: Bool) {
        self.swizzledViewWillAppear(animated: animated)

        let viewControllerName = NSStringFromClass(type(of: self))
        print("viewWillAppear: \(viewControllerName)")
    }

    @objc func swizzledbecomeFirstResponder() -> Bool {
        return true
    }

    @objc var swizzledCanBecomeFirstResponder: Bool {
        return true
    }

    @objc open var swizzledKeyCommands: [UIKeyCommand]? {
        //        print("Hello")

        //print(swizzledKeyCommands?.count)
        //let command = [ UIKeyCommand(input: "\r", modifierFlags: [], action: #selector(enterPressed)) ]
        //        self.
        //        self.addKeyCommand(UIKeyCommand(input: "q", modifierFlags: [], action: #selector(enterPressed)))
        let firstResponder = self.view.window?.firstResponder
        if firstResponder?.isKind(of: UITextField.self) ?? false {
            if let textField = firstResponder as? UITextField {
                print(textField.text)
            }
        } else if firstResponder?.isKind(of: UITextView.self) ?? false {
            if let textField = firstResponder as? UITextView {
                print(textField.text)
            }
        }
        return swizzledKeyCommands
        /*get {

         print("Some interceding code for the swizzled accessor: \(swizzledKeyCommands?.count)") // false warning
         return self.swizzledKeyCommands // not recursive, false warning
         }*/
    }

    /*func findViewThatIsFirstResponder() -> UIView? {
     if isFirstResponder {
     return self.view
     }

     for subView: UIView? in self.view.subviews {
     if subView?.isFirstResponder ?? false {
     print("FSADFSAF")
     //            let firstResponder: UIView? = subView?.firstre
     //            if firstResponder != nil {
     //                return firstResponder
     //            }
     }
     }

     return nil
     }*/


    @objc func enterPressed() {
        print("Enter pressed")
    }

    func textFieldDidChange(_ textField:UITextField) {
        print(textField.text)
    }
}

public let swizzlingUIViewController: (UIViewController.Type) -> () = { viewController in

    //    let firstResponderOriginalSelector = #selector(getter: viewController.canBecomeFirstResponder)
    //    let firstResponderSwizzledSelector = #selector(getter: viewController.swizzledCanBecomeFirstResponder)

    //    let firstResponderOriginalSelector = #selector(viewController.becomeFirstResponder)
    //    let firstResponderSwizzledSelector = #selector(viewController.swizzledbecomeFirstResponder)

    //    let firstResponderOriginalMethod = class_getInstanceMethod(viewController, firstResponderOriginalSelector)
    //    let firstResponderSwizzledMethod = class_getInstanceMethod(viewController, firstResponderSwizzledSelector)
    //
    //    if let firstResponderOriginalMethod = firstResponderOriginalMethod, let firstResponderSwizzledMethod = firstResponderSwizzledMethod {
    //        method_exchangeImplementations(firstResponderOriginalMethod, firstResponderSwizzledMethod)
    //    }

    let keyCommandOriginalSelector = #selector(getter: viewController.keyCommands)
    let keyCommandSwizzledSelector = #selector(getter: viewController.swizzledKeyCommands)

    let keyCommandOriginalMethod = class_getInstanceMethod(viewController, keyCommandOriginalSelector)
    let keyCommandSwizzledMethod = class_getInstanceMethod(viewController, keyCommandSwizzledSelector)

    if let keyCommandOriginalMethod = keyCommandOriginalMethod, let keyCommandSwizzledMethod = keyCommandSwizzledMethod {
        method_exchangeImplementations(keyCommandOriginalMethod, keyCommandSwizzledMethod)
    }

    let originalSelector = #selector(viewController.viewWillAppear(_:))
    let swizzledSelector = #selector(viewController.swizzledViewWillAppear(animated:))

    let originalMethod = class_getInstanceMethod(viewController, originalSelector)
    let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

}


/*extension UIResponder {
 public static func injectResponder() {
 // make sure this isn't a subclass
 guard self === UIResponder.self else { return }
 //        swizzlingResponder(self)
 }

 @objc func swizzledTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 self.swizzledTouchesBegan(touches, with: event)
 for touch in touches {
 print(touch.timestamp)
 print(touch.location(in: touch.view))
 }
 //        self.
 //        let viewControllerName = NSStringFromClass(type(of: self))
 //        print("viewWillAppear: \(viewControllerName)")
 }
 }

 public let swizzlingResponder: (UIResponder.Type) -> () = { uiResponder in

 //    let keyCommandOriginalSelector = #selector(getter: viewController.keyCommands)
 //    let keyCommandSwizzledSelector = #selector(getter: viewController.swizzledKeyCommands)
 //
 //    let keyCommandOriginalMethod = class_getInstanceMethod(viewController, keyCommandOriginalSelector)
 //    let keyCommandSwizzledMethod = class_getInstanceMethod(viewController, keyCommandSwizzledSelector)
 //
 //    if let keyCommandOriginalMethod = keyCommandOriginalMethod, let keyCommandSwizzledMethod = keyCommandSwizzledMethod {
 //        method_exchangeImplementations(keyCommandOriginalMethod, keyCommandSwizzledMethod)
 //    }

 let originalSelector = #selector(uiResponder.touchesBegan(_:with:))
 let swizzledSelector = #selector(uiResponder.swizzledTouchesBegan(_:with:))

 let originalMethod = class_getInstanceMethod(uiResponder, originalSelector)
 let swizzledMethod = class_getInstanceMethod(uiResponder, swizzledSelector)

 if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
 method_exchangeImplementations(originalMethod, swizzledMethod)
 }

 }*/



extension UIAlertAction {
    public static func inject() {
        // make sure this isn't a subclass
        guard self == UIAlertAction.self else { return }
        swizzlingUIAlertAction(self)
    }

    /*@objc var swizzledAction: Selector? {
     get {
     print("UIBarButtonItem: \(self) was pressed")
     return self.swizzledAction
     }
     }

     //typealias UIAlertAction = ()  -> Void

     @objc func swizzledInit(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
     print("Wow")
     swizzledInit(title: title, style: style, handler: handler)
     //print()
     }

     func swizzledHandler(originalHandler: (UIAlertAction) -> Void) {
     print("Wow")
     originalHandler(self)
     }*/

    @objc var swizzledIsEnabled: Bool {
        get {
            print("\(self) was enabled")
            return self.swizzledIsEnabled
        }
    }
}

private let swizzlingUIAlertAction: (UIAlertAction.Type) -> () = { alertAction in

    let originalSelector = #selector(getter: alertAction.isEnabled)
    let swizzledSelector = #selector(getter: alertAction.swizzledIsEnabled)

    let originalMethod = class_getInstanceMethod(alertAction, originalSelector)
    let swizzledMethod = class_getInstanceMethod(alertAction, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

}

extension UIApplication {
    public static func inject() {
        // make sure this isn't a subclass
        guard self == UIApplication.self else { return }
        swizzlingUIApplication(self)
    }

    @objc func swizzledSendAction(_ action: Selector, to target: Any?, from sender: Any?, for event: UIEvent?) -> Bool {
        print("Action: \(action)")
        print("Target: \(target ?? "")")
        print("Sender: \(sender ?? "")")
        print("Event: \(String(describing: event))")
        return swizzledSendAction(action, to: target, from: sender, for: event)
    }
}

private let swizzlingUIApplication: (UIApplication.Type) -> () = { application in

    let originalSelector = #selector(application.sendAction(_:to:from:for:))
    let swizzledSelector = #selector(application.swizzledSendAction(_:to:from:for:))

    let originalMethod = class_getInstanceMethod(application, originalSelector)
    let swizzledMethod = class_getInstanceMethod(application, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

}

extension UITextField: SwizzlingInjection {
    public static func inject() {
        // make sure this isn't a subclass
        guard self == UITextField.self else { return }
        swizzlingTextField(self)
    }

    @objc var swizzledIsTrue: Bool {
        get {
            print("Why")
            return self.swizzledIsTrue
        }
    }

    @objc var swizzledText: String? {
        get {
            print("Some interceding code for the swizzled accessor: \(self.swizzledText ?? "fail")") // false warning
            return self.swizzledText // not recursive, false warning
        }
        set {
            //print("Some interceding code for the swizzled accessor: \(self.swizzledText ?? "fail")") // false warning
            //return self.swizzledText // not recursive, false warning
        }
    }

    @objc func lol(in: String) {
        print("Derp")
    }

}



public let swizzlingTextField: (UITextField.Type) -> () = { textField in

    //    let rangeStart = uiTextInput.position(from: uiTextInput.beginningOfDocument, offset: location)
    //    let rangeEnd = uiTextInput.position(from: rangeStart, offset: )
    //    let range = uiTextField.text(uiText)
    let originalSelector = #selector(getter: textField.text)
    let swizzledSelector = #selector(getter: textField.swizzledText)
    //    let swizzledSelector = #selector(uiTextField.lol(in:))
    let originalMethod = class_getInstanceMethod(textField, originalSelector)
    let swizzledMethod = class_getInstanceMethod(textField, swizzledSelector)
    //    let originalMethod = class_getInstanceMethod(uiTextField, Selector("text"))
    //    let swizzledMethod = class_getInstanceMethod(uiTextField, Selector("swizzledText"))

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

}

extension UIPressesEvent {
    public static func inject() {
        // make sure this isn't a subclass
        guard self == UIPressesEvent.self else { return }
        swizzlingUIPressesEvent(self)
    }

    @objc func swizzledPresses(for gesture: UIGestureRecognizer) -> Set<UIPress> {

        if gesture.isKind(of: UIPanGestureRecognizer.self) {
            if let sender = gesture as? UIPanGestureRecognizer {
                var startLocation = CGPoint()
                if (sender.state == UIGestureRecognizer.State.began) {
                    startLocation = sender.location(in: gesture.view)
                    print("Start: \(startLocation)")
                } else if (sender.state == UIGestureRecognizer.State.ended) {
                    let stopLocation = sender.location(in: gesture.view)
                    //                    let dx = stopLocation.x - startLocation.x;
                    //                    let dy = stopLocation.y - startLocation.y;
                    //                    let distance = sqrt(dx*dx + dy*dy );
                    //                    print("Start: \(startLocation)")
                    print("Stop: \(stopLocation)")
                    //print("Distance: \(distance)")
                    //NSLog("Distance: %f", distance);
                }
            }
        }

        if gesture.isKind(of: UISwipeGestureRecognizer.self) {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            }
        }

        return swizzledPresses(for: gesture)
    }
}

private let swizzlingUIPressesEvent: (UIPressesEvent.Type) -> () = { pressesEvent in

    let originalSelector = #selector(pressesEvent.presses(for:))
    let swizzledSelector = #selector(pressesEvent.swizzledPresses(for:))

    let originalMethod = class_getInstanceMethod(pressesEvent, originalSelector)
    let swizzledMethod = class_getInstanceMethod(pressesEvent, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

}

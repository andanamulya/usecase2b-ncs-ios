//
//  CounterView.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

protocol CounterViewDelegate: BaseProtocol {
    func didQuantityUpdate(view:CounterView, action:CounterView.action, quantity:Int)
}
class CounterView: BaseView {
    enum action{
        case plus
        case minus
    }
    var counter:Int {
        set{
            self.numberTextLabel.text = "\(newValue)"
        }
        get{
            if let value:String = self.numberTextLabel.text{
                return Int(value) ?? 0
            }
            return 0
        }
    }
    var totalQuantity = 0;
    weak var delegate: CounterViewDelegate?
    @IBOutlet private weak var numberTextLabel: UILabel!
    @IBOutlet private weak var negativeButton: UIButton!
    @IBOutlet private weak var positiveButton: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func negativeButtonAction(_ sender: Any) {
        if self.counter > 0 {
            self.counter -= 1;
        }
        self.numberTextLabel.text = "\(self.counter)"
        if let delegate = self.delegate {
            delegate.didQuantityUpdate(view: self, action: .minus, quantity: self.counter)
        }
    }
    @IBAction func positiveButtonAction(_ sender: Any) {
        //if self.counter <= totalQuantity{
            self.counter += 1;
        //}
        self.numberTextLabel.text = "\(self.counter)"
        if let delegate = self.delegate {
            delegate.didQuantityUpdate(view: self, action: .plus, quantity: self.counter)
        }
    }
}

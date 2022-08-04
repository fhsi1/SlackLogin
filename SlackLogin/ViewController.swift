//
//  ViewController.swift
//  SlackLogin
//
//  Created by Yujean Cho on 2022/08/04.
//

import UIKit

class ViewController: UIViewController {
    
    // character set
    let charSet: CharacterSet = {
        var cs = CharacterSet.lowercaseLetters
        cs.insert(charactersIn: "0123456789")
        cs.insert(charactersIn: "-")
        // 허용되지 않은 문자로 구성된 characterSet 으로 구성
        // ( 더 빠르게 비교 가능 )
        return cs.inverted
    }()

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var placeholderLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITextFieldDelegate {
    // 소문자 숫자 하이픈만 허용하도록 제한
    // textfield 에 새로운 문자를 입력하거나 삭제할 때마다 호출된다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 입력모드에서만 실행
        if string.count > 0 {
            guard string.rangeOfCharacter(from: charSet) == nil else {
                return false // 허용된 문자만 입력가능
            }
        }
        
        return true
    }
}

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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // Notification token 저장 속성
    var tokens = [NSObjectProtocol]()
    
    // 옵저버 제거
    // Scene 이 완전히 제거되는 시점에 옵저버를 함께 제거한다.
    deinit {
        tokens.forEach { NotificationCenter.default.removeObserver($0) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        urlField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // next 버튼 비활성화 : 초기 설정
        nextButton.isEnabled = false
        
        // 옵저버 등록
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            // keyboard 높이 값을 얻어 keyboard 높이만큼 여백 추가
            if let frameValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = frameValue.cgRectValue
                
                // bottom 여백 지정
                self?.bottomConstraint.constant = keyboardFrame.size.height
                
                // UIView Animation 적용, keyboard 가 표시되기 직전에 실행
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
                }) { finished in
                    // textFieldDidBeginEditing 에서 비활성화한 animation 활성화
                    UIView.setAnimationsEnabled(true)
                }
            }
        }
        tokens.append(token)
        
        // keyboard 가 사라지기 전에 전달된다.
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            
            self?.bottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        })
        tokens.append(token)
    }

}

extension ViewController: UITextFieldDelegate {
    // textField 에서 편집이 실행된 다음에 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // firstResponder 설정으로 인한 animation 비활성화
        UIView.setAnimationsEnabled(false)
    }
    
    // 소문자 숫자 하이픈만 허용하도록 제한
    // textfield 에 새로운 문자를 입력하거나 삭제할 때마다 호출된다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 입력모드에서만 실행
        if string.count > 0 {
            guard string.rangeOfCharacter(from: charSet) == nil else {
                return false // 허용된 문자만 입력가능
            }
        }
        
        // 입력이나 삭제가 반영된 최종 문자열이 구성된다.
        let finalText = NSMutableString(string: textField.text ?? "")
        finalText.replaceCharacters(in: range, with: string)
        
        // 입력된 텍스트 너비 구하기
        // 텍스트 너비는 폰트를 기준으로 계산한다.
        let font = textField.font ?? UIFont.systemFont(ofSize: 16)
        
        // 위의 폰트를 가지고 문자열 속성 dictionary 를 만든다.
        let dict = [NSAttributedString.Key.font: font]
        
        let width = finalText.size(withAttributes: dict).width
        
        // 계산된 너비로 왼쪽 여백 업데이트
        placeholderLeadingConstraint.constant = width
        
        // placeholder 에 표시되는 텍스트 업데이트
        // 입력된 문자열 길이에 따라서 달라진다.
        if finalText.length == 0 {
            placeholderLabel.text = "workspace-url.slack.com"
        } else {
            placeholderLabel.text = ".slack.com"
        }
        
        // finalText 의 길이에 따라 next 버튼 활성화
        nextButton.isEnabled = finalText.length > 0
        
        return true
    }
}

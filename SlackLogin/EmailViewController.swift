//
//  EmailViewController.swift
//  SlackLogin
//
//  Created by Yujean Cho on 2022/08/04.
//

import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    
    @IBAction func movePrevious(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.alpha = 0.0
        titleLabelBottomConstraint.constant = -20
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EmailViewController: UITextFieldDelegate {
    // 입력 상태에 따라서 placeholderLabel 업데이트
    // textField 에서 입력이 활성화되기 직전에 호출
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
        
        return true // 입력 허용
    }
    
    //
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 최종 text 구성
        let finalText = NSMutableString(string: textField.text ?? "")
        finalText.replaceCharacters(in: range, with: string)
        
        // 작성한 문자열의 길이여부에 따라 placeholder alpha 값 조정
        placeholderLabel.alpha = finalText.length > 0 ? 0.0 : 1.0
        
        // titleLabel 업데이트
        // 작성한 문자열의 길이여부에 따라 titleLabel 이 animation 과 함께 나타난다.
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.titleLabel.alpha = finalText.length > 0 ? 1.0 : 0.0
            self?.titleLabelBottomConstraint.constant = finalText.length > 0 ? 0 : -20
            self?.view.layoutIfNeeded()
        }
        
        return true
    }
}

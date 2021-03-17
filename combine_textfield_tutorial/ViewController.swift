//
//  ViewController.swift
//  combine_textfield_tutorial
//
//  Created by Seokhyun Kim on 2021-03-17.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var myBtn: UIButton!
    
    var viewModel : MyViewModel!
    
    private var mySubscriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyViewModel()
        //택스트필드에서 나가는 이벤트를 뷰모델의 프로퍼티가 구독
        passwordTextField.myTextPublisher
 //           .print()
            //메인 쓰레드에서 받는다.
            .receive(on: DispatchQueue.main)
            //구독
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &mySubscriptions)
        
        passwordConfirmTextField.myTextPublisher
 //           .print()
            //메인 쓰레드에서 받는다.
            .receive(on: RunLoop.main)
            //구독
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &mySubscriptions)
        
        //버튼이 뷰모델의 퍼블리셔를 구독
        viewModel.isMatchPasswordInput
            .print()
            .receive(on: RunLoop.main)
            //구독
            .assign(to: \.isValid, on: myBtn)
            .store(in: &mySubscriptions)
    }


}

extension UITextField {
    var myTextPublisher : AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            //UITextField 가져옴.
            .compactMap{ $0.object as? UITextField }
            //String `가져옴
            .map{ $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .yellow
        }
        set {
            backgroundColor = newValue ? .yellow : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: .normal)
        }
    }
}

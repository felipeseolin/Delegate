//
//  TaskFormViewController.swift
//  Delegate
//
//  Created by Felipe Seolin Bento on 09/10/21.
//

import UIKit
import SnapKit

class TaskFormViewController: UIViewController {
    // MARK: - Lazy views
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private lazy var formStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    
    private lazy var addTaskButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Adicionar"
        configuration.titleAlignment = .leading
        configuration.imagePadding = 10
        configuration.image = UIImage(systemName: "plus.circle.fill")
        
        var button = UIButton()
        button.configuration = configuration
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(self.addNewTask), for: .touchUpInside)
        
        return button
    }()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupViews()
    }
    // MARK: - View setups
    private func setupNavigationBar() {
        view.backgroundColor = .white
        self.title = "Responsabilidades"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Right bar button
        let nextNavBtn = UIBarButtonItem(title: "Próximo", style: .done, target: self, action: #selector(self.nextStep))
        navigationItem.rightBarButtonItem = nextNavBtn
    }
    
    private func setupViews() {
        self.setupScrollView()
        self.setupFormStackView()
        self.setupTaskButton()
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
    }
    
    private func setupFormStackView() {
        self.scrollView.addSubview(self.formStackView)
        
        self.formStackView.snp.makeConstraints { make -> Void in
            make.width.equalTo(scrollView).offset(-30)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.centerX.equalTo(scrollView)
        }
    }
    
    private func setupTaskButton() {
        self.view.addSubview(self.addTaskButton)
        
        self.addTaskButton.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalTo(self.view).offset(-12)
            make.leading.equalTo(self.view).offset(12)
        }
    }
    // MARK: - Actions
    @objc func addNewTask() {
        self.formStackView.addArrangedSubview(self.newTask())
    }
    
    @objc func removeTask(_ sender: Any) {
        guard let button = sender as? UIButton,
              let stack = button.superview
        else {
            return
        }
        
        stack.removeFromSuperview()
    }
    
    @objc func nextStep() {
        let totalParticipant = self.getTotalParticipants()
        let responsibilities = self.getResponsibilities()
        // Validate
        if !self.isFormValid(totalParticipant: totalParticipant, responsibilities: responsibilities) {
            self.present(AlertUtils.invalidFormAlert(), animated: true, completion: nil)
            return
        }
        // Send to next VC
        let participantFormVC = ParticipantFormViewController()
        participantFormVC.totalParticipants = totalParticipant
        participantFormVC.responsibilities = responsibilities
        
        navigationController?.pushViewController(participantFormVC, animated: true)
    }
    // MARK: - Behavior
    private func isFormValid(totalParticipant: Int, responsibilities: [Responsibility]) -> Bool {
        if totalParticipant == 0 ||
            responsibilities.isEmpty ||
            responsibilities.count < 2 ||
            responsibilities.map({ $0.amount }).reduce(0, +) != totalParticipant ||
            !(responsibilities.filter({ $0.name.isEmpty || $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }).isEmpty) ||
            !(responsibilities.filter({ $0.amount <= 0 }).isEmpty)
        {
            return false
        }
        
        return true
    }
    
    private func getTotalParticipants() -> Int {
        var total = 0
        let amountTextFields = self.getAmountTextFields()
        
        for amountTF in amountTextFields {
            guard let amountStr = amountTF.text,
                  let amount = Int(amountStr) else {
                      continue
                  }
            total += amount
        }
        
        return total
    }
    
    private func getResponsibilities() -> [Responsibility] {
        var responsibilities: [Responsibility] = []
        let responsibilitiesTextFields = self.getResponsibilityTextFields()
        let amountTextFields = self.getAmountTextFields()
        
        for (index, responsibilityTF) in responsibilitiesTextFields.enumerated() {
            guard let name = responsibilityTF.text,
                  let amountStr = amountTextFields[index].text,
                  let amount = Int(amountStr) else {
                      continue
                  }
            responsibilities.append(Responsibility(name: name, amount: amount))
        }
        
        return responsibilities
    }
    
    private func getAllTextFields() -> [UITextField] {
        var textFields: [UITextField] = []
        
        for taskStack in self.formStackView.subviews {
            for responsibilityStack in taskStack.subviews {
                for responsibilityView in responsibilityStack.subviews {
                    guard let tf = responsibilityView as? UITextField else {
                        continue
                    }
                    textFields.append(tf)
                }
            }
        }
        
        return textFields
    }
    
    private func getResponsibilityTextFields() -> [UITextField] {
        let textFields: [UITextField] = self.getAllTextFields()
        
        return textFields.filter { tf in
            tf.tag == ViewTag.responsibilityTextField.rawValue
        }
    }
    
    private func getAmountTextFields() -> [UITextField] {
        let textFields: [UITextField] = self.getAllTextFields()
        
        return textFields.filter { tf in
            tf.tag == ViewTag.amountTextField.rawValue
        }
    }
    // MARK: - Return view
    private func newTask() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            self.responsibilityStack(),
            self.responsibilityAmountStack(),
            self.responsibilityRemoveButton()
        ])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .bottom
        
        return stackView
    }
    
    private func responsibilityStack() -> UIStackView {
        let responsibilityLabel = UILabel()
        responsibilityLabel.text = "Responsabilidade"
        
        let responsibilityTF = UITextField()
        responsibilityTF.borderStyle = .roundedRect
        responsibilityTF.placeholder = "Ex.: Salgado"
        responsibilityTF.tag = ViewTag.responsibilityTextField.rawValue
        
        let stackView = UIStackView(arrangedSubviews: [responsibilityLabel, responsibilityTF])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }
    
    private func responsibilityAmountStack() -> UIStackView {
        let responsibilityAmountLabel = UILabel()
        responsibilityAmountLabel.text = "Qtd"
        
        let responsibilityAmountTF = UITextField()
        responsibilityAmountTF.borderStyle = .roundedRect
        responsibilityAmountTF.placeholder = "Ex.: 12"
        responsibilityAmountTF.keyboardType = .numberPad
        responsibilityAmountTF.tag = ViewTag.amountTextField.rawValue
        
        let stackView = UIStackView(arrangedSubviews: [responsibilityAmountLabel, responsibilityAmountTF])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        stackView.snp.makeConstraints { make -> Void in
            make.width.equalTo(75)
        }
        
        return stackView
    }
    
    private func responsibilityRemoveButton() -> UIButton {
        let size = 35
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.addTarget(self, action: #selector(self.removeTask), for: .touchUpInside)
        button.tintColor = .red
        
        button.snp.makeConstraints { make -> Void in
            make.height.equalTo(size)
            make.width.equalTo(size)
        }
        
        return button
    }
}

//
//  ParticipantsFormViewController.swift
//  Delegate
//
//  Created by Felipe Seolin Bento on 11/10/21.
//

import UIKit
import SnapKit

class ParticipantFormViewController: UIViewController {
    // MARK: - Arguments
    var totalParticipants: Int = 0
    var responsibilities: [Responsibility] = []
    // MARK: - Attributes
    private var participants: [String] = []
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
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupViews()
    }
    // MARK: - View setups
    private func setupNavigationBar() {
        view.backgroundColor = Asset.Colors.background.color
        self.title = "Participantes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Right bar button
        let nextNavBtn = UIBarButtonItem(title: "Dividir", style: .done, target: self, action: #selector(self.nextStep))
        navigationItem.rightBarButtonItem = nextNavBtn
    }
    
    private func setupViews() {
        self.setupScrollView()
        self.setupFormStackView()
        self.setupParticipants()
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
    
    private func setupParticipants() {
        for index in 1...self.totalParticipants {
            self.formStackView.addArrangedSubview(self.newParticipant(n: index))
        }
    }
    // MARK: - Actions
    @objc func nextStep() {
        let participants = self.getParticipants()
        // Validate
        if !self.isFormValid(participants: participants) {
            self.present(AlertUtils.invalidFormAlert(), animated: true, completion: nil)
            return
        }
        // Send to result
        let drawResultVC = DrawResultViewController()
        drawResultVC.participants = participants
        drawResultVC.responsibilities = responsibilities
        
        navigationController?.pushViewController(drawResultVC, animated: true)
    }
    // MARK: - Behavior
    private func isFormValid(participants: [String]) -> Bool {
        if participants.isEmpty ||
            participants.count < 2 ||
            !(participants.filter({ $0.isEmpty || $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty})).isEmpty {
            return false
        }
        
        return true
    }
    
    private func getParticipantsTF() -> [UITextField] {
        var textFields: [UITextField] = []
        
        for participantStackView in self.formStackView.subviews {
            for participantView in participantStackView.subviews {
                guard let tf = participantView as? UITextField else {
                    continue
                }
                textFields.append(tf)
            }
        }
        
        return textFields
    }
    
    private func getParticipants() -> [String] {
        var participants: [String] = []
        let textFields: [UITextField] = self.getParticipantsTF()
        
        for textField in textFields {
            guard let participant = textField.text else {
                continue
            }
            
            participants.append(participant)
        }
        
        return participants
    }
    // MARK: - Return view
    private func newParticipant(n: Int) -> UIStackView {
        let participantLabel = UILabel()
        participantLabel.text = "Participante \(n)"
        participantLabel.textColor = Asset.Colors.text.color
        
        let participantTF = UITextField()
        participantTF.borderStyle = .roundedRect
        participantTF.placeholder = "Ex.: Felipe"
        participantTF.backgroundColor = Asset.Colors.background.color
        participantTF.tintColor = Asset.Colors.text.color
        participantTF.textColor = Asset.Colors.text.color
        participantTF.delegate = self
        
        let stackView = UIStackView(arrangedSubviews: [participantLabel, participantTF])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }
}

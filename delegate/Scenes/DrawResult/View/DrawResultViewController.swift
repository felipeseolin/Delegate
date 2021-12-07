//
//  DrawResultViewController.swift
//  Delegate
//
//  Created by Felipe Seolin Bento on 11/10/21.
//

import UIKit
import SnapKit

class DrawResultViewController: UIViewController {
    // MARK: - Arguments
    var participants: [String] = []
    var responsibilities: [Responsibility] = []
    // MARK: - Lazy views
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private lazy var resultStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    
    private lazy var newDelegateBtn: UIButton = {
        var btn = UIButton()
        btn.setTitle("Nova delegação", for: .normal)
        
        return btn
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
        self.title = "Resultado"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Right bar button
        let nextNavBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.exportResult))
        navigationItem.rightBarButtonItem = nextNavBtn
    }
    
    private func setupViews() {
        self.setupScrollView()
        self.setupResultStackView()
        self.setupResultView()
        self.setupNewDelegateBtn()
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
    
    private func setupResultStackView() {
        self.scrollView.addSubview(self.resultStackView)
        
        self.resultStackView.snp.makeConstraints { make -> Void in
            make.width.equalTo(scrollView).offset(-30)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.centerX.equalTo(scrollView)
        }
    }
    
    private func setupResultView() {
        var lastIndex = 0
        participants.shuffle()
        
        for responsibility in self.responsibilities {
            self.resultStackView.addArrangedSubview(self.responsibilityLabel(responsibility: responsibility))
            for _ in 1...responsibility.amount {
                self.resultStackView.addArrangedSubview(self.participantLabel(participant: participants[lastIndex]))
                lastIndex += 1
            }
            self.resultStackView.addArrangedSubview(UILabel())
        }
    }
    
    private func setupNewDelegateBtn() {
        self.resultStackView.addSubview(newDelegateBtn)
    }
    // MARK: - Actions
    @objc func exportResult() {
        var lastIndex = 0
        var result = ""
        for responsibility in self.responsibilities {
            result += "\(responsibility.name) | \(responsibility.amount) pessoas:\n"
            for _ in 1...responsibility.amount {
                result += "  - \(participants[lastIndex])\n"
                lastIndex += 1
            }
            result += "\n"
        }
        
        let ac = UIActivityViewController(activityItems: [result], applicationActivities: nil)
        present(ac, animated: true)
    }
    // MARK: - Behavior
    // MARK: - Return view
    private func responsibilityLabel(responsibility: Responsibility) -> UILabel {
        let responsibilityLabel = UILabel()
        responsibilityLabel.text = "\(responsibility.name) - \(responsibility.amount) pessoas"
        responsibilityLabel.font = .preferredFont(forTextStyle: .title3)
        
        return responsibilityLabel
    }
    
    private func participantLabel(participant: String) -> UILabel {
        let participantLabel = UILabel()
        participantLabel.text = "- \(participant)"
        
        return participantLabel
    }
}

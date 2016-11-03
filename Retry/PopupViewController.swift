//
//  PopupViewController.swift
//  Retry
//
//  Created by Hung Dinh Van on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import PureLayout

// MARK: this is a sample retry popup view controller, you can customize your pop up here.

class PopupViewController: UIViewController {
    deinit {
        print("PopupViewController")
    }
    init(autoRetry: Bool) {
        self.autoRetry = autoRetry
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        view.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(wrapperView)
        wrapperView.addSubview(stackView)
        stackView.addArrangedSubview(messageLabel)
        
        if autoRetry {
            stackView.addArrangedSubview(countingLabel)
            rx_countDown.map { second -> String in
                if second == 0 { return " " }
                let format = second > 1 ?
                    NSLocalizedString("Try again in %d seconds...", comment: "") :
                    NSLocalizedString("Try again in %d second...", comment: "")
                return String(format: format, second)
            }.bindTo(countingLabel.rx.text).addDisposableTo(disposeBag)
        }
        
        stackView.addArrangedSubview(retryButton)
        stackView.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.autoCreateAndInstallConstraints {
            wrapperView.autoSetDimensions(to: CGSize(width: 300, height: 220))
            wrapperView.autoCenterInSuperview()
            stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
            
            retryButton.autoPinEdge(toSuperviewEdge: .leading)
            retryButton.autoPinEdge(toSuperviewEdge: .trailing)
            retryButton.autoSetDimension(.height, toSize: 44)
            cancelButton.autoSetDimension(.height, toSize: 44)
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var wrapperView: UIView =  {
        let wrapperView = UIView()
        wrapperView.layer.cornerRadius = 5
        wrapperView.backgroundColor = UIColor(red: 65 / 255, green: 181 / 255, blue: 196 / 255, alpha: 1)
        return wrapperView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.text = NSLocalizedString("Something seems to be wrong.", comment: "")
        return label
    }()
    
    private lazy var countingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = NSLocalizedString("Try again in 3 seconds...", comment: "")
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 22
        button.setTitle(NSLocalizedString("Try again now", comment: ""), for: .normal)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Dismiss", comment: ""), for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        return button
    }()
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: public properties
    
    let autoRetry: Bool
    
    lazy var rx_countDown: Observable<Int> = {
        let numberOfSeconds = 3
        return Observable<Int>.interval(1, scheduler: MainScheduler.instance).take(numberOfSeconds + 1).map { numberOfSeconds - $0 }
    }()
    
    var rx_retry: ControlEvent<Void> {
        return retryButton.rx.tap
    }
    
    var rx_cancel: ControlEvent<Void> {
        return cancelButton.rx.tap
    }
}

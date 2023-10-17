//
//  QuizViewController.swift
//  ARTX-PoliceScience
//
//  Created by 신상용 on 10/4/23.
//

import UIKit

class QuizViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    let partNumber: Int
    let partTitle: String
    let nextQuiz: Notification.Name = Notification.Name("nextQuiz")
    let indexPath: IndexPath
    
    private var currentQuizNumber: Int = 0
    
    private let titleView = QuizTitleView()
    private let progressbarView = QuizProgressView()
    private let quizView = QuizView()
    private let oxbuttonView = OXbuttonView()
    private let viewmodel: QuizViewModel

    init(partNumber: Int, partTitle: String, chapter: Chapter, currentQuizNumber: Int, indexPath: IndexPath) {
        self.partNumber = partNumber
        self.partTitle = partTitle
        self.viewmodel = QuizViewModel(chapter: chapter)
        self.currentQuizNumber = currentQuizNumber
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGray5
        navigationController?.configureNavigationBar(withTitle: "0\(partNumber+1) \(partTitle)")
        navigationController?.addBackButton(target: self, action: #selector(backButtonTapped))
        
        oxbuttonView.correctButton.addTarget(self, action: #selector(correctButtonTapped), for: .touchUpInside)
        oxbuttonView.wrongButton.addTarget(self, action: #selector(wrongButtonTapped), for: .touchUpInside)

        update()
        layout()
 
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextQuiz(_:)), name: nextQuiz, object: nil)
    }
    
    private func layout() {
        
        view.addSubview(titleView.chapterStackView)
        view.addSubview(progressbarView.progressView)
        view.addSubview(progressbarView.progressNumberLabel)
        view.addSubview(progressbarView.imageView)
        view.addSubview(quizView.quizBackgroundView)
        view.addSubview(quizView.quizTitlBackgroundView)
        view.addSubview(quizView.quizNumberLabel)
        view.addSubview(quizView.bookMarkButton)
        view.addSubview(quizView.quizLabel)
        view.addSubview(oxbuttonView.buttonStackView)
        
        titleView.chapterStackView.addArrangedSubview(titleView.chapterNumberLabel)
        titleView.chapterStackView.addArrangedSubview(titleView.chapterTitleLabel)
        

        oxbuttonView.buttonStackView.addArrangedSubview(oxbuttonView.correctButton)
        oxbuttonView.buttonStackView.addArrangedSubview(oxbuttonView.wrongButton)
        
        
        NSLayoutConstraint.activate([
            titleView.chapterStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleView.chapterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            
            progressbarView.progressView.topAnchor.constraint(equalTo: titleView.chapterStackView.bottomAnchor, constant: 24),
            progressbarView.progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            progressbarView.progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -104),
            
            progressbarView.progressNumberLabel.centerYAnchor.constraint(equalTo: progressbarView.progressView.centerYAnchor),
            progressbarView.progressNumberLabel.leadingAnchor.constraint(equalTo: progressbarView.progressView.trailingAnchor, constant: 10),
            progressbarView.progressNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            
            progressbarView.imageView.centerYAnchor.constraint(equalTo: progressbarView.progressView.centerYAnchor),
            progressbarView.imageView.leadingAnchor.constraint(equalTo: progressbarView.progressNumberLabel.trailingAnchor, constant: 10),
            progressbarView.imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            quizView.quizBackgroundView.topAnchor.constraint(equalTo: progressbarView.progressView.bottomAnchor, constant: 16),
            quizView.quizBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quizView.quizBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            quizView.quizBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -206),
            
            quizView.quizTitlBackgroundView.topAnchor.constraint(equalTo: quizView.quizBackgroundView.topAnchor, constant: 26),
            quizView.quizTitlBackgroundView.leadingAnchor.constraint(equalTo: quizView.quizBackgroundView.leadingAnchor, constant: 26),
            quizView.quizTitlBackgroundView.trailingAnchor.constraint(equalTo: quizView.quizBackgroundView.trailingAnchor, constant: -26),
            quizView.quizTitlBackgroundView.heightAnchor.constraint(equalToConstant: 40),
            
            quizView.quizNumberLabel.topAnchor.constraint(equalTo: quizView.quizTitlBackgroundView.topAnchor, constant: 9),
            quizView.quizNumberLabel.bottomAnchor.constraint(equalTo: quizView.quizTitlBackgroundView.bottomAnchor, constant: -9),
            quizView.quizNumberLabel.leadingAnchor.constraint(equalTo: quizView.quizTitlBackgroundView.leadingAnchor, constant: 10),
            quizView.quizNumberLabel.trailingAnchor.constraint(equalTo: quizView.quizTitlBackgroundView.trailingAnchor, constant: -247),
            
            
            quizView.bookMarkButton.centerYAnchor.constraint(equalTo: quizView.quizNumberLabel.centerYAnchor),
            quizView.bookMarkButton.leadingAnchor.constraint(equalTo: quizView.quizNumberLabel.trailingAnchor, constant: 217.5),
            quizView.bookMarkButton.trailingAnchor.constraint(equalTo: quizView.quizTitlBackgroundView.trailingAnchor, constant: -10.5),
            
            quizView.quizLabel.leadingAnchor.constraint(equalTo: quizView.quizTitlBackgroundView.leadingAnchor, constant: 8),
            quizView.quizLabel.trailingAnchor.constraint(equalTo: quizView.quizTitlBackgroundView.trailingAnchor, constant: -8),
            quizView.quizLabel.topAnchor.constraint(equalTo: quizView.quizTitlBackgroundView.bottomAnchor, constant: 16),
            quizView.quizLabel.bottomAnchor.constraint(equalTo: quizView.quizBackgroundView.bottomAnchor, constant: -26),
            
            
            oxbuttonView.buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            oxbuttonView.buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            oxbuttonView.buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -21),
            oxbuttonView.buttonStackView.topAnchor.constraint(equalTo: quizView.quizBackgroundView.bottomAnchor, constant: 55),
            
        ])
    }
    
    private func update() {
        print("여기는\(currentQuizNumber)")
        let totalQuestions = globalQuestion.quiz[partNumber].chapters[viewmodel.chapterNumber(to: currentQuizNumber)-1].questions.count
        let progressFraction = Float(currentQuizNumber+1) / Float(totalQuestions)
        var progressbar = progressFraction
        UIView.animate(withDuration: 1) {
            let updatedProgressFraction = Float(self.currentQuizNumber) / Float(totalQuestions)
            self.progressbarView.progressView.setProgress(updatedProgressFraction, animated: true)
        }
        titleView.chapterNumberLabel.text = "CHAPTER 0" + String( viewmodel.chapterNumber(to: self.currentQuizNumber))
        titleView.chapterTitleLabel.text = viewmodel.chapterTitle(to: self.currentQuizNumber)
        quizView.quizNumberLabel.text = ("Quiz \(self.currentQuizNumber+1)")
        quizView.quizLabel.text = viewmodel.question(to: self.currentQuizNumber)
    }
    
    private func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension QuizViewController {
    @objc func backButtonTapped() {
        let text = QuizBackAlertText.self
        
        let alert = UIAlertController(title: text.title, message: text.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: text.cancelButton, style: .cancel))
        alert.addAction(UIAlertAction(title: text.button, style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = true
            NotificationCenter.default.post(name: Notification.Name("changeQuizToHomeview"), object: nil)
        })
        
        alert.show()
    }
    
    @objc func wrongButtonTapped() {
        let quizModal = QuizModalViewController(question: globalQuestion.quiz[indexPath.section].chapters[indexPath.row].questions[currentQuizNumber], selectedAnswer: false)
        NotificationCenter.default.post(name: Notification.Name("changeViewCorrect"), object: nil)
        quizModal.modalPresentationStyle = .pageSheet
        quizModal.transitioningDelegate = self
        
        if let sheet = quizModal.sheetPresentationController {
            let height = view.frame.height
            let multiplier = 0.42
            if #available(iOS 16.0, *) {
                let fraction = UISheetPresentationController.Detent.custom { context in
                    height * multiplier
                }
                sheet.detents = [fraction]
            } else {
                sheet.detents = [.medium()]
            }
           
            sheet.delegate = self
            sheet.prefersGrabberVisible = true
        }
        quizModal.sheetPresentationController?.prefersGrabberVisible = false
        quizModal.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = true
        present(quizModal, animated: true, completion: nil)
//        self.currentQuizNumber += 1
    }
    
    @objc func correctButtonTapped() {
        let quizModal = QuizModalViewController(question: globalQuestion.quiz[indexPath.section].chapters[indexPath.row].questions[currentQuizNumber], selectedAnswer: true)
        NotificationCenter.default.post(name: Notification.Name("changeViewCorrect"), object: nil)
        quizModal.transitioningDelegate = self
        quizModal.modalPresentationStyle = .pageSheet
        
        if let sheet = quizModal.sheetPresentationController {
            let height = view.frame.height
            let multiplier = 0.42
            if #available(iOS 16.0, *) {
                let fraction = UISheetPresentationController.Detent.custom { context in
                    height * multiplier }
                sheet.detents = [fraction]
            } else {
                sheet.detents = [.medium()]
            }
            
            sheet.delegate = self
            sheet.prefersGrabberVisible = true
        }
        quizModal.sheetPresentationController?.prefersGrabberVisible = false
        quizModal.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = true
        present(quizModal, animated: true, completion: nil)
//        self.currentQuizNumber += 1
    }
    
    @objc func nextQuestionButtonTapped() {
        print("클릭")
        self.dismiss(animated: true) { [weak self] in
            NotificationCenter.default.post(name: self!.nextQuiz, object: nil, userInfo: nil)
        }
    }
    
    @objc func nextQuiz(_ noti: Notification) {
        let totalQuestions = globalQuestion.quiz[partNumber].chapters[viewmodel.chapterNumber(to: currentQuizNumber)-1].questions.count
        if currentQuizNumber + 1 == totalQuestions {
            navigationController?.pushViewController(HomeViewController(), animated: true)
        } else {
            currentQuizNumber += 1
            update()
            showToast(message: "토스트 실험")
            var solving = PartChapter.partIntToString(partIndex: self.partNumber, chapterIndex: self.viewmodel.chapterNumber(to: self.currentQuizNumber)-1)
            UserDefaults.standard.set(self.currentQuizNumber, forKey: solving)
        }
    }
}

extension QuizViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

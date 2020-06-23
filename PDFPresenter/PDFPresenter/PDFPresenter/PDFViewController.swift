//
//  PDFViewController.swift
//  PDFPresenter
//
//  Created by Sam Ding on tableview
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit
import PDFKit

public struct pdfItem {
    var pdfURL: String
    var title: String
    
    init(title: String? = nil, pdfURL: String? = nil){
        self.title = title ?? ""
        self.pdfURL = pdfURL ?? ""
    }
}

public class PDFViewController: UIViewController, PDFViewDelegate {
    
    private var pageLbl = UILabel()
    var pdfView = PDFView()
    var document = PDFDocument()
    private var outline: PDFOutline?
    
    private var finishLoading = false  // Return true if the pdf document is loaded
    var pdf = pdfItem()
    
    var ai : UIActivityIndicatorView!{
        didSet{
            view.addSubview(ai)
            view.bringSubviewToFront(ai)
            
            ai.style = .medium
            ai.startAnimating()
            ai.center = self.view.center
            ai.color = .lightGray
            
            ai.translatesAutoresizingMaskIntoConstraints = false
                       NSLayoutConstraint.activate([
                           ai.topAnchor.constraint(equalTo: self.view.topAnchor),
                           ai.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                           ai.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                           ai.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                       ])
        }
    }
    private var outlineBtn = UIBarButtonItem()
    private var shareBtn = UIBarButtonItem()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.load()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver (self, selector: #selector(showCurrentPageIndex), name: Notification.Name.PDFViewPageChanged, object: nil)
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    public override func viewDidDisappear (_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.PDFViewPageChanged, object: nil)
        super.viewDidDisappear(animated)
    }
    
    
    private func setupView(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.backgroundColor = .white
        self.view.addSubview(pdfView)
        ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 102, width: view.frame.width, height: view.frame.height - 10))

        // Fit content in PDFView.
        pdfView.autoScales = true
        
        // Set share button and outline
        shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareTapped))
        shareBtn.tintColor = .lightGray
        shareBtn.isEnabled = false
        outlineBtn = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(outlineBtnTapped))
        outlineBtn.tintColor = .lightGray
        outlineBtn.isEnabled = false
        navigationItem.rightBarButtonItems = [shareBtn, outlineBtn]
        
        // Page number label setup
        pageLbl = UILabel(frame: CGRect(x: 30, y: 130, width: 80, height: 30))
       // pageLbl.font = UIFont(name: "Montserrat-Regular", size: 14)!
        pageLbl.clipsToBounds = true
        pageLbl.textAlignment = .center
        pageLbl.text = ""
        pageLbl.textColor = .white
        pageLbl.backgroundColor = .lightGray
        pageLbl.layer.cornerRadius = 10
        pageLbl.alpha = 0.0
        view.addSubview(pageLbl)
        view.bringSubviewToFront(pageLbl)


    }
    
    // Load pdf file from url
    private func load(){
        
         guard let url = URL(string: pdf.pdfURL) else {return}
        document = PDFDocument(url: url)!
        
        // Finish Loading
        DispatchQueue.main.async {
            self.pdfView.document = self.document
            self.outline = self.document.outlineRoot
            self.ai.stopAnimating()
            self.shareBtn.tintColor = .black
            self.shareBtn.isEnabled = true
            self.outlineBtn.tintColor = .black
            self.outlineBtn.isEnabled = true
            self.finishLoading = true
            self.pageLbl.alpha = 0.8
            self.showCurrentPageIndex()
            
        }
    }
    
    @objc private func outlineBtnTapped(){
        guard let outline = self.outline else {
            print("PDF has no outline")
            return
        }
        
        let outlineViewController = PDFOutlineTableViewController(outline: outline, delegate: self)
        outlineViewController.preferredContentSize = CGSize(width: 300, height: 400)
        outlineViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        // Specify the anchor point for the popover.
        outlineViewController.popoverPresentationController?.barButtonItem = outlineBtn
        self.present(outlineViewController, animated: true, completion: nil)
    }
    
    @objc private func shareTapped(){
        guard let data = document.dataRepresentation() else { return }
        
        let activityController = UIActivityViewController(activityItems: [data, pdf.title], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    @objc private func showCurrentPageIndex(){
        if finishLoading {
            pageLbl.text = "\(String(describing: pdfView.currentPage!.pageRef!.pageNumber)) of \(String(describing: document.documentRef!.numberOfPages))"
        }
    }
    
    
}

extension PDFViewController: OutlineDelegate {
    func goTo(page: PDFPage) {
        pdfView.go(to: page)
    }
}



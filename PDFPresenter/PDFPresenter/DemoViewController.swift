//
//  ViewController.swift
//  PDFPresenter
//
//  Created by Sam Ding on 6/22/20.
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func viewOnlinePdf(_ sender: Any) {
        let vc =  PDFViewController(pdf: pdfItem(title: "Demo", pdfURL: "https://www.apple.com/education/docs/everyone-can-code-curriculum-guide.pdf"))
        self.navigationController?.pushViewController(vc, animated: true)
    }

    

}


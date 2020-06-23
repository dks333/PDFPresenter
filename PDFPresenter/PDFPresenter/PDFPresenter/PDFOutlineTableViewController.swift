//
//  PDFOutlineViewController.swift
//  PDFPresenter
//
//  Created by Sam Ding on tableview
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit
import PDFKit

protocol OutlineDelegate: class {
    func goTo(page: PDFPage)
}

public class PDFOutlineTableViewController: UITableViewController {

    let outline: PDFOutline
    weak var delegate: OutlineDelegate?
    
    init(outline: PDFOutline, delegate: OutlineDelegate?) {
        self.outline = outline
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outline.numberOfChildren
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        if let label = cell.textLabel, let title = outline.child(at: indexPath.row)?.label {
            label.text = String(title)
        }
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let page = outline.child(at: indexPath.row)?.destination?.page {
            delegate?.goTo(page: page)
            self.dismiss(animated: true, completion: nil)
        }
    }


}

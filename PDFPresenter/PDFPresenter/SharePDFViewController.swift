//
//  SharePDFViewController.swift
//  PDFPresenter
//
//  Created by Sam Ding on 3/20/20.
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit

struct TestUser {
    var id : Int
    var name : String
    var numberOfMutualFriends : Int
    var isSelected : Bool
    
}


// MARK: Modify this view controller
class SharePDFViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var selectedContactCollectionView: UICollectionView!
    
    private var testUsers : [TestUser] = []
    private var selectedUsers : [TestUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        for i in 0...4{testUsers.append(TestUser(id: i+1, name: "S61C", numberOfMutualFriends: 5, isSelected: false))}
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeFromParent()
        super.viewDidDisappear(animated)
    }
    
    private func setupView(){
        // Clear separators of empty rows
        tableview.tableFooterView = UIView()
        tableview.delegate = self
        tableview.dataSource = self
        
        selectedContactCollectionView.delegate = self
        selectedContactCollectionView.dataSource = self
    }
    
    @IBAction func dismissWindow(_ sender: Any) {
        let vc = parent as! FAAMaterialDetailViewController
        vc.handleDismiss()
    }
    
    @IBAction func removeFromShareList(_ button: UIButton) {
        // Check
        let indexPath = selectedContactCollectionView.indexPathForView(view: button)
        testUsers[selectedUsers[indexPath!.row].id - 1].isSelected = false
        selectedUsers.remove(at: indexPath!.row)
        selectedContactCollectionView.reloadData()
        tableview.reloadData()
    }
    
}

/// Share Contact Table View
extension SharePDFViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharePDFCell", for: indexPath) as! ShareTableViewCell
        let user = testUsers[indexPath.row]
        cell.checkMark.image = user.isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName:"circle")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !testUsers.isEmpty {
            testUsers[indexPath.row].isSelected = !testUsers[indexPath.row].isSelected
            if testUsers[indexPath.row].isSelected {
                selectedUsers.append(testUsers[indexPath.row])
            } else {
                selectedUsers.removeAll(where: {indexPath.row == $0.id - 1})
            }
            tableView.reloadData()
            selectedContactCollectionView.reloadData()
        }
    }
    
    
    
}


class SelectedPersonCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var profileImg: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func removeFromShareList(_ sender: Any) {
    }
    
}

/// Selected Contact Collection View
extension SharePDFViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedPersonCell", for: indexPath) as! SelectedPersonCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: collectionView.frame.height)
    }
    
    
}

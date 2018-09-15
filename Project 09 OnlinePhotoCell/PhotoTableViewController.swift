//
//  PhotoTableViewController.swift
//  Project 09 OnlinePhotoCell
//
//  Created by Chris on 12/9/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit

class PhotoTableViewController: UITableViewController {
    
    private let plistURL = "https://raw.githubusercontent.com/cyeung11/Days-of-Swift-Project-09-OnlinePhotoCell/master/Project%2009%20OnlinePhotoCell/ClassicPhotosDictionary.plist"
    
    private var titles = [String]()
    private var photoSource = [String: UIImage]()
    private var dataSource = [String: String](){
        didSet{
            titles = Array(dataSource.keys)
            for (title, _) in photoSource{
                if !dataSource.keys.contains(title){
                    photoSource.removeValue(forKey: title)
                }
            }
            for (title, _) in dataSource{
                if !photoSource.keys.contains(title){
                    photoSource[title] = #imageLiteral(resourceName: "placeholder")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        //get plist from url
        if let url = URL(string: plistURL){
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let session = URLSession(configuration: .default).dataTask(with: url) { [weak self] (data, response, error) in
                
                if error != nil || data == nil {
                    let alert = UIAlertController(title: "Loading Error", message: "Fail to load data from the Internet", preferredStyle: .alert)
                    self?.show(alert, sender: nil)
                }
                if let dictionary = try? PropertyListSerialization.propertyList(from: data!, options: PropertyListSerialization.ReadOptions(rawValue: 0), format: nil) as? [String: String],
                    let dictionary1 = dictionary{
                    self?.dataSource = dictionary1
                    DispatchQueue.main.async { [weak self] in
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self?.tableView.reloadData()
                    }
                }
            }
            session.resume()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PhotoOperationQuene.quene.cancelAllOperations()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        PhotoOperationQuene.quene.isSuspended = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        PhotoOperationQuene.quene.isSuspended = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let cellTitle = titles[indexPath.row]
        
        cell.textLabel?.text = cellTitle
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.image = photoSource[cellTitle]
        
        if cell.imageView?.image == nil || cell.imageView?.image == #imageLiteral(resourceName: "placeholder"){
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            cell.accessoryView = indicator
            indicator.startAnimating()
            let operation = PhotoOperation(withImagePath: dataSource[cellTitle]!,
                                           forIndexPath: indexPath) { [weak self] (image) in
                                            self?.photoSource[cellTitle] = image != nil ? image! : #imageLiteral(resourceName: "error")
                                            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            PhotoOperationQuene.quene.addOperation(operation)
        } else {
            cell.accessoryView = nil
        }
        return cell
    }
    
    
    
}

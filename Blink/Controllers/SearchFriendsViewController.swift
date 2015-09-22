//
//  SearchFriendsViewController.swift
//  Blink
//
//  Created by Remi Robert on 22/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("cancel button")
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
    }
}

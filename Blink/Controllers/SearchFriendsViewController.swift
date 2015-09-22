//
//  SearchFriendsViewController.swift
//  Blink
//
//  Created by Remi Robert on 22/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class SearchFriendsViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var resultSearch = Array<PFObject>()
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("cancel button")
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count < 2 {
            return
        }
        
        let searchSignal = Friend.searchFriends(searchText)
        
        searchSignal.subscribeNext({ (next: AnyObject!) -> Void in
            self.resultSearch.removeAll()
            if let users = next as? [PFObject] {
                print(users)
                self.resultSearch = users
                self.tableView.reloadData()
            }
            
            }, error: { (error: NSError!) -> Void in
                
            }) { () -> Void in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "SearchUserTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
    }
}

extension SearchFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultSearch.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as! SearchUserTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.initCellForUser(resultSearch[indexPath.row])
        return cell
    }
}

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
    var currentFriends = Array<PFObject>()
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
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
        
        Friend.friends().subscribeNext({ (next: AnyObject!) -> Void in
            
            if let friendsList = next as? [PFObject] {
                self.currentFriends = friendsList
                self.tableView.dataSource = self
            }
            
            }, error: { (error: NSError!) -> Void in
                
            }) { () -> Void in
                self.tableView.reloadData()
        }
        
        searchBar.delegate = self
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
        
        let isFriend = Friend.isFriend(resultSearch[indexPath.row], friends: currentFriends)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.initCellForUser(resultSearch[indexPath.row], isFriend: isFriend)
        return cell
    }
}

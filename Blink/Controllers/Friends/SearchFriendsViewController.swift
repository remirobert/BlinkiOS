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

class SearchFriendsViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var resultSearch = Array<PFObject>()
    var currentFriends = Array<PFObject>()
    
    func searchFriend(searchString: String) {
        let searchSignal = Friend.searchFriends(searchString)
        searchSignal.subscribeNext({ (next: AnyObject!) -> Void in
            self.resultSearch.removeAll()
            if let users = next as? [PFObject] {
                self.resultSearch = users
                self.tableView.reloadData()
            }
            
            }, error: { (error: NSError!) -> Void in
                
            }) { () -> Void in
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCurrentFriends()
        searchBar.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "SearchUserTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
    }
}

//MARK:
//MARK: UISearchBar dataSource
extension SearchFriendsViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let searchString = searchBar.text {
            searchFriend(searchString)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count < 2 {
            return
        }
        searchFriend(searchText)
    }
}

//MARK:
//MARK: UITableView dataSource
extension SearchFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultSearch.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as! SearchUserTableViewCell
        
        cell.actionSwitchBlock = {(state: Bool) -> Void in
            if state {
                self.addFriend(self.resultSearch[indexPath.row])
            }
            else {
                self.removeFriend(self.resultSearch[indexPath.row])
            }
        }
        
        let isFriend = Friend.isFriend(resultSearch[indexPath.row], friends: currentFriends)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.initCellForUser(resultSearch[indexPath.row], isFriend: isFriend)
        return cell
    }
}

//MARK:
//MARK: Friends management
extension SearchFriendsViewController {
    
    func loadCurrentFriends() {
        Friend.friends(.NetworkOnly).subscribeNext({ (next: AnyObject!) -> Void in
            
            self.currentFriends.removeAll()
            if let friendsList = next as? [PFObject] {
                self.currentFriends = friendsList
                print("current friends : \(self.currentFriends)")
            }
            self.tableView.reloadData()
            
            }, error: { (error: NSError!) -> Void in
                
            }) { () -> Void in
        }
    }
    
    func addFriend(friend: PFObject) {
        Friend.addFriend(friend).subscribeNext({ (next: AnyObject!) -> Void in
            }, error: { (error: NSError!) -> Void in
                print("error add friend : \(error)")
            }) { () -> Void in
                self.loadCurrentFriends()
        }
    }
    
    func removeFriend(friend: PFObject) {
        Friend.removeFriend(friend).subscribeNext({ (next: AnyObject!) -> Void in
            }, error: { (error: NSError!) -> Void in
                print("error remove friend : \(error)")
            }) {() -> Void in
                self.loadCurrentFriends()
        }
    }
}

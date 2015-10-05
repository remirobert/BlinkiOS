//
//  SelectFriendsViewController.swift
//  Blink
//
//  Created by Remi Robert on 24/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class SelectFriendsViewController: UIViewController {

    @IBOutlet var tableViewFriend: UITableView!
    @IBOutlet var selectionLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var sendBlink: UIButton!
    @IBOutlet var switchPublicRoom: UISwitch!
    
    var friends = Array<PFObject>()
    var friendsSelected = Array<PFObject>()
    var placesCellData = ["Nearby (<25km)", "Far far away"]
    
    var blink: BlinkData!
    var imagePhoto: UIImage!
    var imageText: UIImage!
    
    @IBAction func dismissSelection(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateDisplaySelection() {
        if friendsSelected.count == 0 && switchPublicRoom.on == false {
            sendBlink.hidden = true
        }
        else {
            sendBlink.hidden = false
        }
    }
    
    func initTableView(tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "SelectTableViewCell", bundle: nil), forCellReuseIdentifier: "selectCell")
        tableView.allowsMultipleSelection = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView(tableViewFriend)
        updateDisplayLabelSelected()
        
        Friend.friends(PFCachePolicy.CacheThenNetwork).subscribeNext({ (next: AnyObject!) -> Void in
            
            if let friends = next as? [PFObject] {
                self.friends = friends
                self.tableViewFriend.reloadData()
            }
            }, error: { (error: NSError!) -> Void in
                print("error to get friends list : \(error)")
            }) { () -> Void in
        }
        
        sendBlink.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.createBlink()
        }
        
        switchPublicRoom.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.updateDisplayLabelSelected()
        }
    }
}

//MARK:
//MARK: UITableView dataSource
extension SelectFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return friends.count
        }
        return placesCellData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("selectCell") as! SelectTableViewCell
        
        let currentFriend = friends[indexPath.row]
        if let username = currentFriend["trueUsername"] as? String {
            cell.initCell(username)
        }
        
        if friendsSelected.contains(currentFriend) {
            cell.selectCell()
        }
        else {
            cell.deselectCell()
        }
        return cell
    }
}

//MARK:
//MARK: UITableView delegate
extension SelectFriendsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SelectTableViewCell
        cell.deselectCell()
        removeFriendSelected(friends[indexPath.row])
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SelectTableViewCell
        cell.selectCell()
        addFriendSelected(friends[indexPath.row])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
}

//MARK:
//MARK: friend selection management
extension SelectFriendsViewController {
    
    func updateDisplayLabelSelected() {
        updateDisplaySelection()
        self.selectionLabel.text = "\(friendsSelected.count) selected"
    }
    
    func removeFriendSelected(friend: PFObject) {
        for var index = 0; index < friendsSelected.count; index++ {
            if friendsSelected[index] == friend {
                friendsSelected.removeAtIndex(index)
                updateDisplayLabelSelected()
                return
            }
        }
    }
    
    func addFriendSelected(friend: PFObject) {
        self.friendsSelected.append(friend)
        updateDisplayLabelSelected()
    }
}

//MARK:
//MARK: Blink creation
extension SelectFriendsViewController {
    
    func createBlink() {
        Blink.createBlink(self.imagePhoto, textImage: self.imageText, blinkData: self.blink).subscribeNext({ (next: AnyObject!) -> Void in
            
            if let blink = next as? PFObject {
                self.friendsSelected.append(PFUser.currentUser()!)
                
                Room.createNewRoom(self.blink.message, blink: blink, participants: self.friendsSelected).subscribeNext({ (next: AnyObject!) -> Void in
                    
                    print("room created : \(next)")
                    
                    if let room = next as? PFObject {
                        
                        if self.switchPublicRoom.on {
                            Room.makeRoomPublic(room).subscribeNext({ (next: AnyObject!) -> Void in
                                
                                if let _  = next as? PFObject {
                                    print("creation public room success")
                                    return
                                }
                                else {
                                    print("error make public room")
                                }
                                
                                }, error: { (error: NSError!) -> Void in
                                    print("error make room public : \(error)")
                            })
                        }
                        else {
                            print("creation room success")
                            return
                        }
                    }
                    }, error: { (error: NSError!) -> Void in
                        print("error create room : \(error)")
                })
            }
            
            }, error: { (error: NSError!) -> Void in
                print("error create blink : \(error)")
        })
    }
}

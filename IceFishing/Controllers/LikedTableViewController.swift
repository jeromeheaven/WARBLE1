//
//  LikedTableViewController.swift
//  IceFishing
//
//  Created by Alexander Zielenski on 5/3/15.
//  Copyright (c) 2015 Alexander Zielenski. All rights reserved.
//

import UIKit

class LikedTableViewController: PlayerTableViewController, PostViewDelegate {
    let cellIdentifier = "FeedTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Liked"
		view.backgroundColor = UIColor.iceDarkGray
		extendedLayoutIncludesOpaqueBars = true
		definesPresentationContext = true
		tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: "FeedCell")
		
		addHamburgerMenu()

		// Fix color above search bar
		let topView = UIView(frame: view.frame)
		topView.frame.origin.y = -view.frame.size.height
		topView.backgroundColor = UIColor.iceDarkRed
		tableView.addSubview(topView)
		
		pinView.postView.type = .Liked
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        retrieveLikedSongs()
		
		notConnected()
    }
	
    // MARK: - Table View Methods
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedTableViewCell
		
		cell.postView.type = .Liked
		let posts = searchController.active ? filteredPosts : self.posts
		cell.postView.post = posts[indexPath.row]
		cell.postView.delegate = self
		cell.postView.post?.player.prepareToPlay()
		
		return cell
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath) as! FeedTableViewCell
		cell.postView.backgroundColor = UIColor.iceLightGray
		currentlyPlayingIndexPath = indexPath
	}
	
    func retrieveLikedSongs() {
        API.sharedAPI.fetchLikes(User.currentUser.id) {
            self.posts = $0.map { Post(song: $0, user: User.currentUser) }
            self.tableView.reloadData()
			
			if self.posts.count == 0 {
				self.tableView.backgroundView = UIView.viewForEmptyViewController(.Liked, size: self.view.bounds.size, isCurrentUser: true, userFirstName: "")
			} else {
				self.tableView.backgroundView = nil
			}
        }
    }

}
//
//  ProfileViewController.h
//  CandyFinder
//
//  Created by Devin Moss on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController {
    
}

@property (nonatomic, strong) IBOutlet UITableViewCell *nameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *pointsCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *nextLevelCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *clanMembersCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *editProfileCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *editSharingCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *rateCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *logoutCell;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;

- (IBAction)logout:(id)sender;
- (IBAction)rateCandyfinder:(id)sender;

@end

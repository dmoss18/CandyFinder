//
//  ProfileViewController.m
//  CandyFinder
//
//  Created by Devin Moss on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "Appirater.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

#define TOTAL_POINTS            @"Total Points"
#define CLAN_MEMBERS            @"Clan Members"
#define POINTS_TO_NEXT_LEVEL    @"Points to next level"
#define EDIT_PROFILE            @"Profile"
#define EDIT_SHARING            @"Sharing"

@synthesize nameCell, pointsCell, nextLevelCell, clanMembersCell, editProfileCell, editSharingCell, logoutCell, progressView, rateCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    /*AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    nameCell.textLabel.text = app.user.name;
    nameCell.imageView.image = app.user.pic;
    nameCell.detailTextLabel.text = @"Level 1: Candy Craver";*/
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 4;
            break;
        default:
            return 3;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(indexPath.section == 0) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(app.user) {
            nameCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", app.user.first_name, app.user.last_name];
            nameCell.imageView.image = app.user.pic;
            nameCell.detailTextLabel.text = @"Level 1: Candy Craver";
        } else {
            [self performSelector:@selector(reloadTableAttributes) withObject:nil afterDelay:2];
        }
        return nameCell;
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                //total points
                return pointsCell;
                break;
            case 1:
                //next level
                [progressView setProgress:0.8 animated:YES];
                return nextLevelCell;
                break;
            case 2:
                return clanMembersCell;
                break;
            default: 
                return pointsCell;
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                //edit profile
                return editProfileCell;
                break;
            case 1:
                //edit sharing settings
                return editSharingCell;
                break;
            case 2:
                //rate candyfinder
                return rateCell;
                break;
            case 3:
                //logout
                return logoutCell;
                break;
            default: 
                return logoutCell;
                break;
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if(indexPath.section == 0) {
        return;
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                //total points
                return;
                break;
            case 2:
                //next level
                return;
                break;
            case 3:
                //Go to list of friends in your gang
                return;
                break;
            default: 
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                //go to edit profile
                return;
                break;
            case 1:
                //go to sharing settings
                return;
                break;
            case 2:
                //Rate CandyFinder
                [self rateCandyfinder:rateCell];
                break;
            case 3:
                //logout
                [self logout:logoutCell];
                break;
            default:
                break;
        }
    }
}

- (void) reloadTableAttributes {
    //Check to see if the user object is populated
    //If it is, reload the table data
    //If not, check again in 2 seconds.
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(app.user) {
        [self.tableView reloadData];
    } else {
        [self performSelector:@selector(reloadTableAttributes) withObject:nil afterDelay:2];
    }
}

- (IBAction)rateCandyfinder:(id)sender {
    NSString *badge = [self.tabBarItem badgeValue];
    NSInteger badgeNumber = [badge integerValue];
    if((badgeNumber - 1) < 1) {
        //[self.tabBarItem setBadgeValue:@""];
        [self.tabBarItem setBadgeValue:nil];
    } else {
        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%i", badgeNumber - 1]];
    }
    
    [Appirater rateApp];
}



//======Logout==========
- (IBAction)logout:(id)sender {
    [logoutCell setSelected:NO];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.facebook logout];
}

@end

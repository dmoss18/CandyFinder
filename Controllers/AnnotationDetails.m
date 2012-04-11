//
//  AnnotationDetails.m
//  barcodeTest2
//
//  Created by Devin Moss on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnnotationDetails.h"
#import "Candy.h"
#import "Location.h"
#import "Classes/SBJson.h"
#import "globals.h"
#import "TagCandyViewController.h"
#import "FlurryAnalytics.h"
#import "LocationPoster.h"

@implementation AnnotationDetails

@synthesize locationCandies, location, location_name, location_id, responseData, addButtonTouched, isGoingBackToMap, indicator, updateCandy;
//@synthesize navController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:location_name];
    addButtonTouched = NO;
    isGoingBackToMap = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    /*if ([[NSFileManager defaultManager] fileExistsAtPath:path2]) {
        self.locationCandies = [[NSMutableArray alloc] initWithContentsOfFile:path2];
    }*/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.locationCandies = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isGoingBackToMap = YES;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = self.view.center;
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    //Using NSURL send the message
    responseData = [NSMutableData data];
    NSString *url = [NSString stringWithFormat:CANDIES_FROM_LOCATION, [NSString stringWithFormat:@"%i", location_id]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [FlurryAnalytics logPageView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(isGoingBackToMap && addButtonTouched) {
        //User went to tag controller, came back, and is going to map
        //Next time they touch the "Tag" tab, they won't expect to see this location
        //They expect to see a list of nearby locations
        //So we set currentLocation to nil
        //[LocationPoster sharedLocationPoster].currentLocation = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"DetailsToTagCandy"])
    {
        // Get reference to the destination view controller
        TagCandyViewController *vc = (TagCandyViewController *)[segue destinationViewController];
        vc.fromAnnotationDetails = YES;
        NSLog(@"%i", self.location_id);
        vc.location_id = [NSString stringWithFormat:@"%i", self.location_id];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return locationCandies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    Candy *candy = [locationCandies objectAtIndex:row];
    cell.textLabel.text = candy.title;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    //cell.detailTextLabel.text = candy.subtitle;
    UIImage *image = [UIImage imageNamed:@"milkyway.png"];
    cell.imageView.image = image;
    
    /*UILabel *lastSeen = [[UILabel alloc] initWithFrame:CGRectMake(198.0, 0.0, 72.0, 21.0)];
    lastSeen.text = @"Last seen:";
    lastSeen.font = [UIFont systemFontOfSize:15.0];
    lastSeen.textAlignment = UITextAlignmentLeft;
    lastSeen.textColor = [UIColor darkGrayColor];
    lastSeen.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:lastSeen];*/
    
    NSTimeInterval timeInterval = abs([candy.updated_at timeIntervalSinceNow]);
    NSString *timeAgo;
    double minutes = round(timeInterval / 60);
    if(minutes < 60) {
        timeAgo = [NSString stringWithFormat:@"Last seen: %.f minutes ago", round(minutes)];
    } else {
        double hours = round((timeInterval / 60) / 60);
        if(hours < 24){
            if(hours < 2) {
                timeAgo = [NSString stringWithFormat:@"Last seen: %.f hour ago", (hours)];
            } else {
                timeAgo = [NSString stringWithFormat:@"Last seen: %.f hours ago", (hours)];
            }
        } else {
            double days = round(hours / 24);
            if(days < 2) {
                timeAgo = [NSString stringWithFormat:@"Last seen: %.f day ago", (days)];
            }else if(days < 30) {
                timeAgo = [NSString stringWithFormat:@"Last seen: %.f days ago", (days)];
            } else if (days < 365) {
                double months = round(days / 30);
                if(months < 2) {
                    timeAgo = [NSString stringWithFormat:@"Last seen: %.f month ago", (months)];
                } else {
                    timeAgo = [NSString stringWithFormat:@"Last seen: %.f months ago", (months)];
                }
            } else {
                double years = round(days / 365);
                if(years < 2) {
                    timeAgo = [NSString stringWithFormat:@"Last seen: %.f year ago", (years)];
                } else {
                    timeAgo = [NSString stringWithFormat:@"Last seen: %.f years ago", (years)];
                }
            }
        }
    }
    
    cell.detailTextLabel.text = timeAgo;
    
    
    /*UILabel *dateSeen = [[UILabel alloc] initWithFrame:CGRectMake(198.0, 20.0, 100.0, 21.0)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    dateSeen.text = [formatter stringFromDate:candy.updated_at];
    //dateSeen.text = [NSDateFormatter localizedStringFromDate:candy.updated_at dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    NSLog(@"%@", dateSeen.text);
    dateSeen.font = [UIFont systemFontOfSize:15.0];
    dateSeen.textAlignment = UITextAlignmentLeft;
    dateSeen.textColor = [UIColor lightGrayColor];
    dateSeen.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:dateSeen];*/
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
    updateButton.frame = CGRectMake(278.0, 6.0, 37.0, 28.0);
    [updateButton setTitle:@"Update" forState:UIControlStateNormal];
    updateButton.titleLabel.font = [UIFont systemFontOfSize:9.0];
    updateButton.titleLabel.textColor = [UIColor darkGrayColor];
    //updateButton.tag = [candy.candy_id intValue];
    updateButton.tag = [indexPath row];
    
    [updateButton addTarget:self action:@selector(updateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setAccessoryView:updateButton];
    
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
}

#pragma mark JSON Request section
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
    //[responseData removeAllObjects];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//resultText.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [indicator stopAnimating];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
	NSDictionary *candyInfo = [responseString JSONValue];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in candyInfo){
        [tempArray addObject:[Candy candyFromDictionary:item]];
    }
    
    self.locationCandies = tempArray;
    [self.tableView reloadData];
}

#pragma mark - Helper Methods
- (IBAction)addButtonTapped:(id)sender {
    if(location) {
        [LocationPoster sharedLocationPoster].currentLocation = location;
    }
    addButtonTouched = YES;
    isGoingBackToMap = NO;
    [self.tabBarController setSelectedIndex:1];
}

- (void)backToMap {
    [LocationPoster sharedLocationPoster].currentLocation = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateButtonTapped:(id)sender {
    [self displayActionSheet:sender];
}

#pragma mark - Action Sheet
#pragma mark - Action Sheet
- (IBAction)displayActionSheet:(id)sender {
    Candy *candy = [locationCandies objectAtIndex:((UIButton *)sender).tag];
    self.updateCandy = candy;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Confirm that %@ still carries %@?", location.name, candy.title]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Yes", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            //PUT annotation here (update it)
            updateCandy.updated_at = [NSDate date];
            [[LocationPoster sharedLocationPoster] updateAnnotationLocation:location withCandy:updateCandy];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

@end

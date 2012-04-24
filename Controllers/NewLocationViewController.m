//
//  NewLocationViewController.m
//  CandyFinder
//
//  Created by Devin Moss on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewLocationViewController.h"
#import "MapViewController.h"
#import "Candy.h"
#import "Location.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "globals.h"
#import "Web.h"
#import "LocationPoster.h"

@implementation NewLocationViewController

@synthesize nameField, responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAddCandyController)];
        //self.navigationItem.backBarButtonItem = backButton;
        self.responseData = [[NSMutableData alloc] init];
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
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    responseData = [[NSMutableData alloc] init];
    
    //Send request to Google Places
    //Disable view and put spinning circle that says "Searching Locations database"
    //Once data is received, pop up the alert
    
    Location *tmpLoc = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation;
    UIAlertView *addressAlert = [[UIAlertView alloc] initWithTitle: @"Is this your address?" message: [NSString stringWithFormat:@"%@ %@, %@, %@", tmpLoc.address, tmpLoc.city, tmpLoc.state, tmpLoc.zip]
                                                       delegate: self 
                                              cancelButtonTitle: @"Yes" 
                                              otherButtonTitles: @"No", nil];
    [addressAlert dismissWithClickedButtonIndex:0 animated:YES];
    [addressAlert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)saveButtonTapped:(id)sender {
    //User enters location name
    //I'd like some way for the name to be auto-populated by looking at nearby locations
        //It could say "Maverik" or even "Are you at Maverik Gas Station?"
    //When the user clicks save, the nav controller pops to root (mapView), where the annotation is marked
    //Maybe a popup appears saying "This tag is close to 'Maverik.' Would you like to merge these?"
    
    NSString *locationName = nameField.text;
    
    if ([locationName length] != 0) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        Location *location = app.currentLocation; //CurrentLocation is set by MapViewController when user location is updated
        Candy *currentCandy = app.currentCandy;
        
        //Location *location = [[Location alloc] initWithLocation:currentLocation.coordinate];
        //location.lat = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
        //location.lon = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
        location.name = locationName;
        
        NSData *data = [[Web sharedWeb] getPostDataFromString:[NSString stringWithFormat:LOCATION_PARAMETERS, location.lat, location.lon, location.name, location.address, location.city, location.state, location.zip, app.authenticity_token]];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[Web sharedWeb] encodeStringForURL:CREATE_LOCATION]]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        //Pop up a spinning progress circle thing until the responsedata is received
    }else {
        //Display warning: "Name cannot be blank"
    }
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - JSON request section
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
    NSLog(@"got a response in LocationPoster");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"response string is %@", responseString);
    NSDictionary *loc = [responseString JSONValue];
    
    Location *location = [Location locationFromDictionary:loc];
    
    [LocationPoster sharedLocationPoster].currentLocation = location;
    
    MapViewController *tmp = (MapViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [tmp markLocation:location];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"]) {
        NSLog(@"User clicked yes");
    } else {
        NSLog(@"User clicked something other than yes");
        [self performSegueWithIdentifier:@"LocationToAddressEntry" sender:self];
    }
}


@end

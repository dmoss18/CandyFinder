//
//  AddressViewController.m
//  CandyFinder
//
//  Created by Devin Moss on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressViewController.h"
#import "AppDelegate.h"
#import "Location.h"

@implementation AddressViewController

@synthesize addressField, cityField, stateField, zipField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)];
    
    //[self.view addGestureRecognizer:tap];
    
    Location *currentLocation = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation;
    addressField.text = currentLocation.address;
    cityField.text = currentLocation.city;
    stateField.text = currentLocation.state;
    zipField.text = currentLocation.zip;
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

- (IBAction)dismissAddressViewController:(id)sender {
    Location *currentLocation = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation;
    currentLocation.address = addressField.text;
    currentLocation.city = cityField.text;
    currentLocation.state = stateField.text;
    currentLocation.zip = zipField.text;
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissKeyboards {
    if([addressField isFirstResponder]){
        [addressField resignFirstResponder];
    }
    if([cityField isFirstResponder]){
        [cityField resignFirstResponder];
    }
    if([stateField isFirstResponder]){
        [stateField resignFirstResponder];
    }
    if([zipField isFirstResponder]){
        [zipField resignFirstResponder];
    }
}

@end

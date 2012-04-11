//
//  NewCandyViewController.m
//  CandyFinder
//
//  Created by Devin Moss on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewCandyViewController.h"
#import "Classes/SBJson.h"
#import "AppDelegate.h"
#import "Web.h"
#import "FlurryAnalytics.h"

@implementation NewCandyViewController

@synthesize sku, title, subtitle, fromSegue, responseData, skuTextField, brandTextField, typeTextField, imageView;

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


 //Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fromSegue = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_AddBody_half.png"]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Top Bar Blank.png"] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    if(fromSegue){
        [self scanButtonTapped];
    }
    
    self.fromSegue = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [FlurryAnalytics logPageView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Scan delegate
- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    self.sku = [NSString stringWithFormat:@"%@", symbol.data];
    skuTextField.text = sku;
    
    imageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    //Using NSURL send the message
    responseData = [NSMutableData data];
    
    //So the url will be http://candyfinder.net/search/sku/123456789012
    NSString *url = [NSString stringWithFormat:SEARCH_SKU, symbol.data];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [picker dismissModalViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark JSON Request section
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//resultText.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    NSLog(@"There was an error");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    
	NSDictionary *candyInfo = [responseString JSONValue];
    
    if([candyInfo count] > 0){
        //If candy was found, populate fields
        skuTextField.text = (NSString *)[candyInfo objectForKey:@"sku"];
        brandTextField.text = (NSString *)[candyInfo objectForKey:@"title"];
        typeTextField.text = (NSString *)[candyInfo objectForKey:@"subtitle"];
    }else{
        //Candy not found
        //Prompt user to manually enter the remaining fields
    }
}

#pragma mark - Create New Candy
-(IBAction)saveButtonTapped:(id)sender{
    BOOL save = YES;
    
    if(sku) {
        NSString *type = typeTextField.text;
        NSString *brand = brandTextField.text;
        
        if(type && [type length] == 0) {
            save = NO;
            [typeTextField setBackgroundColor:BRIGHT_RED];
        }
        if(type && [brand length] == 0) {
            save = NO;
            [brandTextField setBackgroundColor:BRIGHT_RED];
        }
        if(save) {
            [self displayActionSheet:self];
        } else {
            //User hasn't entered enough info
        }
    } else {
        [skuTextField setBackgroundColor:BRIGHT_RED];
    }
}

#pragma mark - Action Sheet
- (IBAction)displayActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Add %@ %@ to our database?", brandTextField.text, typeTextField.text]
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
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            NSString *postString = [NSString stringWithFormat:CANDY_PARAMETERS, self.sku, brandTextField.text, typeTextField.text, app.authenticity_token];
            
            [[Web sharedWeb] sendPostToURL:CREATE_CANDY withBody:postString];
            
            NSString *candyName = [NSString stringWithFormat:@"%@ %@", brandTextField.text, typeTextField.text];
            [FlurryAnalytics logEvent:NEW_CANDY withParameters:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:candyName, self.sku, nil] forKeys:[NSArray arrayWithObjects:@"name", @"sku", nil]]];
            
            //pop to parent view controller
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

@end

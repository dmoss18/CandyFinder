//
//  ScanViewController.m
//  CandyFinder
//
//  Created by Devin Moss on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScanViewController.h"
#import "Classes/SBJson.h"
#import "Candy.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "globals.h"
#import "NewAnnotation.h"

@implementation ScanViewController

@synthesize resultImage, resultText, responseData;
@synthesize fromSegue, scannedCandy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Scanner", @"Scanner");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.fromSegue = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(fromSegue){
        [self scanButtonTapped];
    }
    
    self.fromSegue = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma Scanning code

- (IBAction) scanButtonTapped
{
    NSLog(@"TBD: scan barcode here...");
    
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    CGRect annotationFrame = NEW_ANNOTATION_FRAME;
    NewAnnotation *tempView = [[NewAnnotation alloc] initWithFrame:annotationFrame];
    reader.cameraOverlayView = tempView;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    //[reader release];
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
    resultText.text = symbol.data;
    NSLog(@"%@", symbol.data);
    //Chop off leading 0 (if it's 13 digits)
    
    //Using NSURL send the message
    responseData = [NSMutableData data];
    
    //So the url will be http://candyfinder.net/search/sku/123456789012
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:SEARCH_SKU, symbol.data]]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [picker dismissModalViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) searchButtonTapped:(id)sender {
    //Using NSURL send the message
    responseData = [NSMutableData data];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:SEARCH_SKU, @"040000001010"]]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSLog(@"%@", [request valueForHTTPHeaderField:@"Accept"]);
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) dealloc
{
    self.resultImage = nil;
    self.resultText = nil;
    //[super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return(YES);
}

#pragma mark JSON Request section
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	resultText.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//[connection release];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	//[responseData release];
    
	NSDictionary *candyInfo = [responseString JSONValue];
    
    NSMutableString *text = [NSMutableString stringWithString:@"SKU not found."];
    
    if([candyInfo count] > 0){
        self.scannedCandy = [Candy candyFromDictionary:candyInfo];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.currentCandy = scannedCandy;
        
        text = [NSMutableString stringWithString:@"Candy is named:\n"];
    
        //for (int i = 0; i < [candyInfo count]; i++)
        [text appendFormat:@"%@\n", scannedCandy.title];
        [text appendFormat:@"%@\n", scannedCandy.subtitle];
        [text appendFormat:@"SKU: %@\n", scannedCandy.sku];
        
        [self performSegueWithIdentifier:@"ScanToMapView" sender:self];
        
    }else{
        self.scannedCandy = nil;
        //enable add candy button?
    }
    
	resultText.text = [NSString stringWithFormat:@"%@", text];
} 

#pragma mark - Navigation
- (IBAction)backToMap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action Sheet
- (IBAction)displayActionSheet:(id)sender {
    UIActionSheet *pickerSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"View Map", @"Add New Candy", nil];
    
    [pickerSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [pickerSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"ScanToMapView" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"ScanToNewCandy" sender:self];
            break;
            
        default:
            break;
    }
}

@end

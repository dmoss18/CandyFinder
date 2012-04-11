//
//  ScanViewController.h
//  CandyFinder
//
//  Created by Devin Moss on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candy.h"

@interface ScanViewController : UIViewController
    // ADD: delegate protocol
    < ZBarReaderDelegate, UIActionSheetDelegate >
{
    UIImageView *resultImage;
    UITextView *resultText;
    NSMutableData *responseData;
    BOOL fromSegue;
    Candy *scannedCandy;
}

@property (nonatomic, strong) IBOutlet UIImageView *resultImage;
@property (nonatomic, strong) IBOutlet UITextView *resultText;
@property(nonatomic, strong) NSMutableData *responseData;
@property(nonatomic) BOOL fromSegue;
@property(nonatomic, strong) Candy *scannedCandy;

- (IBAction) scanButtonTapped;
- (IBAction) searchButtonTapped:(id)sender;
- (IBAction)backToMap:(id)sender;
- (IBAction)displayActionSheet:(id)sender;

@end

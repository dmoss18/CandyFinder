//
//  UserLoginViewController.h
//  CandyFinder
//
//  Created by Devin Moss on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLoginViewController : UIViewController {
    NSMutableData *responseData;
    
    //Indicator is displayed while authentication occurs
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;

@end

//
//  LoginViewController.h
//  CandyFinder
//
//  Created by Devin Moss on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface LoginViewController : UIViewController <FBRequestDelegate, FBDialogDelegate> {
    NSArray *permissions;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIImageView *profilePhotoImageView;
}

@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *profilePhotoImageView;

- (IBAction)login:(id)sender;
- (IBAction)continueWithoutLoggingIn:(id)sender;

@end

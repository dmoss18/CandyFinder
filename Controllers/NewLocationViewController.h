//
//  NewLocationViewController.h
//  CandyFinder
//
//  Created by Devin Moss on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLocationViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate > {
    IBOutlet UITextField *nameField;
    NSMutableData *responseData;
}

@property (nonatomic, strong)IBOutlet UITextField *nameField;
@property (nonatomic, strong)NSMutableData *responseData;

-(IBAction)saveButtonTapped:(id)sender;

@end

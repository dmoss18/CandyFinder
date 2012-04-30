//
//  SignUpViewController.h
//  CandyFinder
//
//  Created by Devin Moss on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    NSMutableData *responseData;
    
    //Indicator is displayed while user signs up
    UIActivityIndicatorView *indicator;
    
    UIToolbar *keyboardToolbar;
    
    BOOL keyboardVisible;
    
    CGPoint offset;
    
    UITextField *selectedTextField;
}

@property (nonatomic, strong) IBOutlet UITextField *firstNameField;
@property (nonatomic, strong) IBOutlet UITextField *lastNameField;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *phoneField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *confirmPasswordField;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (IBAction)signUp:(id)sender;
- (void)previousField:(id)sender;
- (void)nextField:(id)sender;
- (void)resignKeyboard:(id)sender;

@end

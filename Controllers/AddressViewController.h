//
//  AddressViewController.h
//  CandyFinder
//
//  Created by Devin Moss on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *cityField;
    IBOutlet UITextField *stateField;
    IBOutlet UITextField *zipField;
}

@property (nonatomic, strong)IBOutlet UITextField *addressField;
@property (nonatomic, strong)IBOutlet UITextField *cityField;
@property (nonatomic, strong)IBOutlet UITextField *stateField;
@property (nonatomic, strong)IBOutlet UITextField *zipField;

-(IBAction)dismissAddressViewController:(id)sender;

@end

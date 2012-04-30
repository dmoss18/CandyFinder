//
//  SignUpViewController.m
//  CandyFinder
//
//  Created by Devin Moss on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "globals.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

#define kTabBarHeight 44
#define kContentHeight 328
#define NOT_JSON_REQUEST 406
#define REGISTERED_AND_SIGNED_IN 200
#define REGISTERED_NOT_SIGNED_IN 201
#define ERROR_IN_REGISTRATION 404


@synthesize firstNameField, lastNameField, usernameField, phoneField, emailField, passwordField, confirmPasswordField, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(signUp:)];
    [self.navigationItem setRightBarButtonItem:submitButton];
    
    keyboardVisible = NO;
    
    CGSize scrollContentSize = CGSizeMake(self.view.bounds.size.width, 368);
    self.scrollView.contentSize = scrollContentSize;

    
    if(keyboardToolbar == nil) {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" 
                                                                           style:UIBarButtonItemStyleBordered 
                                                                          target:self 
                                                                          action:@selector(previousField:)];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" 
                                                                           style:UIBarButtonItemStyleBordered 
                                                                          target:self 
                                                                          action:@selector(nextField:)];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard:)];
        
        [keyboardToolbar setItems:[NSArray arrayWithObjects:previousButton, nextButton, extraSpace, doneButton, nil]];
    }
    
    firstNameField.inputAccessoryView = keyboardToolbar;
    lastNameField.inputAccessoryView = keyboardToolbar;
    usernameField.inputAccessoryView = keyboardToolbar;
    emailField.inputAccessoryView = keyboardToolbar;
    phoneField.inputAccessoryView = keyboardToolbar;
    passwordField.inputAccessoryView = keyboardToolbar;
    confirmPasswordField.inputAccessoryView = keyboardToolbar;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];  
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Sign up
- (IBAction)signUp:(id)sender {
    
    //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Using NSURL send the message
    responseData = [NSMutableData data];
    
    /*NSString *body = [NSString stringWithFormat:@"user[remember_me]=0&user[email]=%@&user[password]=%@&authenticity_token=%@", emailField.text, passwordField.text, app.authenticity_token];
     NSMutableData *postData = [NSMutableData data];
     body = [[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
     [postData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];*/
    
    NSString *url = [NSString stringWithFormat:@"http://www.candyfinder.net/mobile/sign_up?user[first_name]=%@&user[last_name]=%@&user[email]=%@&user[username]=%@&user[phone]=%@&user[password]=%@", 
                     firstNameField.text, lastNameField.text, emailField.text, usernameField.text, phoneField.text, passwordField.text];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:url]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@", [request HTTPMethod]);
    //[request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[request setHTTPBody:postData];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}




#pragma mark JSON Request section
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
    //[responseData removeAllObjects];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//resultText.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [indicator stopAnimating];
    
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
	NSDictionary *authResponse = [responseString JSONValue];
    
    NSLog(@"%@", [authResponse description]);
    
    if([authResponse objectForKey:@"status"]) {
        int statusCode = [[authResponse objectForKey:@"status"] intValue];
        switch (statusCode) {
            case REGISTERED_AND_SIGNED_IN:
                //Populate user object from dictionary
                NSLog(@"user registered and logged in");
                break;
            case REGISTERED_NOT_SIGNED_IN:
                //Populate user object
                //Sign user in (maybe this is what we want every time, just so we get an auth token
                NSLog(@"user registered not logged in");
                break;
            case NOT_JSON_REQUEST:
                //Return
                NSLog(@"not a json request");
                break;
            case ERROR_IN_REGISTRATION: {
                //Print errors to alertview
                NSLog(@"%@", [authResponse objectForKey:@"message"]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Sign Up" message:[authResponse objectForKey:@"message"] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [alert show];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - helper methods
- (void) resignKeyboard:(id)sender {
    if([firstNameField isFirstResponder]) {
        [firstNameField resignFirstResponder];
    }else if ([lastNameField isFirstResponder] ){
        [lastNameField resignFirstResponder];
    }else if ([usernameField isFirstResponder]) {
        [usernameField resignFirstResponder];
    }else if ([emailField isFirstResponder]) {
        [emailField resignFirstResponder];
    }else if ([phoneField isFirstResponder]) {
        [phoneField resignFirstResponder];
    }else if ([passwordField isFirstResponder]) {
        [passwordField resignFirstResponder];
    }else if ([confirmPasswordField isFirstResponder]) {
        [confirmPasswordField resignFirstResponder];
    }
}

- (void) nextField:(id)sender {
    if([firstNameField isFirstResponder]) {
        [lastNameField becomeFirstResponder];
        //[scrollView scrollRectToVisible:lastNameField.frame animated:YES];
    }else if ([lastNameField isFirstResponder] ){
        [usernameField becomeFirstResponder];
        //[scrollView scrollRectToVisible:usernameField.frame animated:YES];
    }else if ([usernameField isFirstResponder]) {
        [emailField becomeFirstResponder];
        //[scrollView scrollRectToVisible:emailField.frame animated:YES];
    }else if ([emailField isFirstResponder]) {
        [phoneField becomeFirstResponder];
        //[scrollView scrollRectToVisible:phoneField.frame animated:YES];
    }else if ([phoneField isFirstResponder]) {
        [passwordField becomeFirstResponder];
        //[scrollView scrollRectToVisible:passwordField.frame animated:YES];
    }else if ([passwordField isFirstResponder]) {
        [confirmPasswordField becomeFirstResponder];
        //[scrollView scrollRectToVisible:confirmPasswordField.frame animated:YES];
    }else if ([confirmPasswordField isFirstResponder]) {
        [firstNameField becomeFirstResponder];
        //[scrollView scrollRectToVisible:firstNameField.frame animated:YES];
    }
}

- (void)previousField:(id)sender {
    if([firstNameField isFirstResponder]) {
        [confirmPasswordField becomeFirstResponder];
    }else if ([lastNameField isFirstResponder] ){
        [firstNameField becomeFirstResponder];
    }else if ([usernameField isFirstResponder]) {
        [lastNameField becomeFirstResponder];
    }else if ([emailField isFirstResponder]) {
        [usernameField becomeFirstResponder];
    }else if ([phoneField isFirstResponder]) {
        [emailField becomeFirstResponder];
    }else if ([passwordField isFirstResponder]) {
        [phoneField becomeFirstResponder];
    }else if ([confirmPasswordField isFirstResponder]) {
        [passwordField becomeFirstResponder];
    }
}

#pragma mark - Keyboard code
- (void) keyboardDidShow:(NSNotification *)notif {
    if(keyboardVisible) {
        return;
    }
    
    // Get the size of the keyboard.
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Save the current location so we can restore
    // when keyboard is dismissed
    offset = scrollView.contentOffset;
    
    // Resize the scroll view to make room for the keyboard
    CGRect viewFrame = scrollView.frame;
    viewFrame.size.height -= (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [UIView setAnimationDuration:0.3];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    [scrollView scrollRectToVisible:selectedTextField.frame animated:YES];
    
    
    // Keyboard is now visible
    keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif 
{
    // Is the keyboard already shown
    if (!keyboardVisible) 
    {
        return;
    }
    
    NSDictionary* userInfo = [notif userInfo];
    
    // get the size of the keyboard
    NSValue* boundsValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [UIView setAnimationDuration:0.3];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardVisible = NO;
	
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    selectedTextField = textField;
    return YES;
}

@end

//
//  UserLoginViewController.m
//  CandyFinder
//
//  Created by Devin Moss on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserLoginViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "globals.h"
#import "User.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

#define NOT_JSON_REQUEST 406
#define SIGNED_IN 200
#define BLANK_EMAIL_OR_PASSWORD 400
#define INVALID_PASSWORD 401
#define USER_EMAIL_NOT_FOUND 402

@synthesize emailField, passwordField;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)login:(id)sender {
    NSString *emailText = emailField.text;
    NSString *passwordText = passwordField.text;
    
    
    if(!emailField.text || [emailField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your email address" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
        return;
    }
    
    if(!passwordField.text || [passwordField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your password" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
        return;
    }
    
    //Using NSURL send the message
    responseData = [NSMutableData data];
    
    NSString *url = [NSString stringWithFormat:LOGIN_PARAMETERS, emailField.text, passwordField.text];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:url]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:10];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (IBAction)logout:(id)sender {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Using NSURL send the message
    responseData = [NSMutableData data];
    
    NSString *url = [NSString stringWithFormat:LOGOUT_PARAMETERS, app.user.authentication_token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:url]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:10];
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
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
            case SIGNED_IN: {
                //Populate user object from dictionary
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                app.user = [User userFromDictionary:[authResponse objectForKey:@"user"]];
                app.user.authentication_token = [authResponse objectForKey:@"authentication_token"];
                [app userDidLogin];
                
                //Dismiss view and go to app
                [self.navigationController dismissModalViewControllerAnimated:YES];
                break;
            }
            case NOT_JSON_REQUEST:
                //Return
                NSLog(@"not a json request");
                break;
            default: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Login" message:[authResponse objectForKey:@"message"] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [alert show];
                break;
            }
        }
    }
}

@end

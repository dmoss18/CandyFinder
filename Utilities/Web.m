//
//  Web.m
//  barcodeTest2
//
//  Created by Devin Moss on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Web.h"
#import "SynthesizeSingleton.h"
#import "JSON.h"
#import "globals.h"
#import "UIDevice+IdentifierAddition.h"
#import "User.h"
#import "AppDelegate.h"

@implementation Web

#define USER_FOUND          200
#define INVALID_AUTH_TOKEN  404

@synthesize responseData;

SYNTHESIZE_SINGLETON_FOR_CLASS(Web);

- (id)init {
    self = [super init];
    
	if (self != nil) {
		responseData = [[NSMutableData alloc] init];
	}
    
	return self;
    
}

- (NSURLRequest *)searchSKURequest:(NSString *) sku {
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:SEARCH_SKU, sku]]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

- (NSURLRequest *)searchNameRequest:(NSString *) candyName {
    return NULL;
}

-(void)sendPostToURL:(NSString *)url withData:(NSData *)data {
    //[[Web sharedWeb] performSelectorInBackground:@selector(postDataInBackground:) withObject:[NSArray arrayWithObjects:url, data, nil]];    
}

-(void)sendPostToURL:(NSString *)url withBody:(NSString *)body{
    url = [NSString stringWithFormat:@"%@%@", url, body];
    url = [self encodeStringForURL:url];
    
    [[Web sharedWeb] performSelectorInBackground:@selector(postRequestInBackground:) withObject:url];
}

-(NSData *)getPostDataFromString:(NSString *)body {
    NSMutableData *postData = [NSMutableData data];
    body = [self encodeStringForURL:body];
    [postData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return postData;
}

-(NSString *)encodeStringForURL:(NSString *)url{
    return [[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}

-(void)recordAppHit {
    NSString *url = [NSString stringWithFormat:APP_HIT, [[UIDevice currentDevice] uniqueDeviceIdentifier]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[Web sharedWeb] performSelectorInBackground:@selector(postRequestInBackground:) withObject:url];
}


- (void) postRequestInBackground:(NSString *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest
                             requestWithURL:[NSURL URLWithString:url]
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response;
    
    NSError *error;
    
    
    //send it and forget it
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}


#pragma mark - User info
-(void)getUserInfo:(NSString *)authentication_token {
    //Using NSURL send the message
    NSMutableData *responseData = [NSMutableData data];
    NSString *url = [NSString stringWithFormat:GET_USER, authentication_token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
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
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
	NSDictionary *userInfo = [responseString JSONValue];
    
    if([userInfo objectForKey:@"status"]) {
        switch ([[userInfo objectForKey:@"status"] intValue]) {
            case USER_FOUND: {
                User *user = [User userFromDictionary:[userInfo objectForKey:@"user"]];
                user.authentication_token = [userInfo objectForKey:@"authentication_token"];
                ((AppDelegate *)[[UIApplication sharedApplication] delegate]).user = user;
                break;
            }
            case INVALID_AUTH_TOKEN:
                [((AppDelegate *)[[UIApplication sharedApplication] delegate]) userDidLogout];
                break;
            default:
                break;
        }
    }
}


@end

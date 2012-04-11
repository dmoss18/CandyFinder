//
//  Geocoder.m
//  CandyFinder
//
//  Created by Devin Moss on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Geocoder.h"
#import "SynthesizeSingleton.h"
#import "Classes/SBJson.h"
#import "globals.h"
#import "AppDelegate.h"

@implementation Geocoder

@synthesize responseData, currentLocation;

SYNTHESIZE_SINGLETON_FOR_CLASS(Geocoder);

- (id)init {
    self = [super init];
    
	if (self != nil) {
		responseData = [[NSMutableData alloc] init];
	}
    
	return self;
    
}

-(void)getAddress:(Location *)location {
    responseData = [NSMutableData data];
    self.currentLocation = location;
    NSString *url = [NSString stringWithFormat:FIND_ADDRESS, location.lat, location.lon];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - JSON request section
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"response string is %@", responseString);
    if([responseString length] > 0){
        NSDictionary *dictionary = [responseString JSONValue];
        if([[dictionary objectForKey:@"status"] isEqualToString:@"OK"]) {
            NSDictionary *results = [((NSArray *)[dictionary objectForKey:@"results"]) objectAtIndex:0];
            NSArray *addressComponents = [results objectForKey:@"address_components"];
            NSString *address1 = [((NSDictionary *)[addressComponents objectAtIndex:0]) objectForKey:@"long_name"];
            NSString *address2 = [((NSDictionary *)[addressComponents objectAtIndex:1]) objectForKey:@"long_name"];
            currentLocation.address = [NSString stringWithFormat:@"%@ %@", address1, address2];
            currentLocation.city = [((NSDictionary *)[addressComponents objectAtIndex:2]) objectForKey:@"long_name"];
            currentLocation.state = [((NSDictionary *)[addressComponents objectAtIndex:3]) objectForKey:@"long_name"];
            currentLocation.zip = [((NSDictionary *)[addressComponents objectAtIndex:([addressComponents count] - 1)]) objectForKey:@"long_name"];
        }
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        app.currentLocation = currentLocation;
    }
}

@end

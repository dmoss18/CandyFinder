//
//  User.m
//  CandyFinder
//
//  Created by Devin Moss on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"
#import "globals.h"

@implementation User

@synthesize first_name, last_name, username, phone, last_signed_in, authentication_token, fbid, pic, email, user_id, created_at;

- (id)init {
    self = [super init];
    
	if (self != nil) {
	}
    
	return self;
    
}

//=========== Class Methods =========================
//***************************************************

+(User *)userFromDictionary:(NSDictionary *)item {
    User *u = [[User alloc] init];
    u.user_id = [NSString stringWithFormat:@"%@", [item objectForKey:@"id"]];
    u.first_name = [item objectForKey:@"first_name"];
    u.last_name = [item objectForKey:@"last_name"];
    u.username = [item objectForKey:@"username"];
    u.phone = [item objectForKey:@"phone"];
    u.email = [item objectForKey:@"email"];
    u.fbid = [item objectForKey:@"facebook_id"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:SS'Z'"];
    u.last_signed_in = [dateFormat dateFromString:[item objectForKey:@"updated_at"]];
    u.created_at = [dateFormat dateFromString:[item objectForKey:@"created_at"]];
    
    NSString *pic_path = [item objectForKey:@"pic"];
    //begin background thread to start downloading picture
    
    return u;
}

@end

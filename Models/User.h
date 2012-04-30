//
//  User.h
//  CandyFinder
//
//  Created by Devin Moss on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSString *first_name;
    NSString *last_name;
    NSString *username;
    NSString *phone;
    NSString *fbid;
    UIImage *pic;
    NSDate *last_signed_in;
    NSString *authentication_token;
    NSString *email;
    NSString *user_id;
    NSDate *created_at;
}

@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *fbid;
@property (nonatomic, strong) UIImage *pic;
@property (nonatomic, strong) NSDate *last_signed_in;
@property (nonatomic, strong) NSString *authentication_token;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSDate *created_at;

+ (User *)userFromDictionary:(NSDictionary *)item;

@end

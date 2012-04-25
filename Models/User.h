//
//  User.h
//  CandyFinder
//
//  Created by Devin Moss on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSString *name;
    NSString *fbid;
    UIImage *pic;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fbid;
@property (nonatomic, strong) UIImage *pic;

@end

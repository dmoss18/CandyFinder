//
//  FBDataGetter.h
//  CandyFinder
//
//  Created by Devin Moss on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FBDataGetter : NSObject <FBRequestDelegate> {
    NSMutableArray *myData;
    NSString *myAction;
}

@property (nonatomic, retain) NSMutableArray *myData;
@property (nonatomic, retain) NSString *myAction;

- (void) getMeInfo;

+ (FBDataGetter *)sharedFBDataGetter;

@end

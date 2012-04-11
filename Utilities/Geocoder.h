//
//  Geocoder.h
//  CandyFinder
//
//  Created by Devin Moss on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 This class is deprecated and will be removed in the future if we see that we truly don't need it.
 It was being used to get an approximate address of the user's location.
 However, we are now using Google Places, which gives exact addresses of business locations.
 **/

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Geocoder : NSObject {
    Location *currentLocation;
    NSMutableData *responseData;
}

@property (nonatomic, strong) Location *currentLocation;
@property (nonatomic, strong) NSMutableData *responseData;

-(void)getAddress:(Location *)location;
-(void)getLatLon:(Location *)location;

+ (Geocoder *)sharedGeocoder;

@end

//
//  Candy.m
//  CandyFinder
//
//  Created by Devin Moss on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Candy.h"

@implementation Candy

@synthesize candy_id, title, subtitle, sku, created_at, updated_at;


//=========== Class Methods =========================
//***************************************************

+(Candy *)candyFromDictionary:(NSDictionary *)item {
    Candy *c = [[Candy alloc] init];
    c.candy_id = [NSString stringWithFormat:@"%@", [item objectForKey:@"id"]];
    c.sku = [item objectForKey:@"sku"];
    c.title = [item objectForKey:@"title"];
    c.subtitle = [item objectForKey:@"subtitle"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:SS'Z'"];
    c.created_at = [dateFormat dateFromString:[item objectForKey:@"created_at"]];
    c.updated_at = [dateFormat dateFromString:[item objectForKey:@"updated_at"]];
    return c;
}

+(NSMutableArray *)unserialize:(NSDictionary *)items {
    NSEnumerator *enumerator = [items objectEnumerator];
    id value;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    while (value = [enumerator nextObject]) {
        //should be a candy in dictionary form
        Candy *c = [[Candy alloc] init];
        c.title = [value objectForKey:@"title"];
        c.subtitle = [value objectForKey:@"subtitle"];
        c.sku = [value objectForKey:@"sku"];
        c.candy_id = [value objectForKey:@"candy_id"];
        c.created_at = [value objectForKey:@"created_at"];
        c.updated_at = [value objectForKey:@"updated_at"];
        
        [array addObject:c];
    }
    
    return array;
}

+(NSData *)serialize:(NSArray *)items {
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [items count]; i++) {
        Candy *c = (Candy *)[items objectAtIndex:i];
        [plistDict setObject:[self dictionaryFromCandy:c] forKey:[NSString stringWithFormat:@"Item %i", i]];
    }
    
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    
    if(plistData) {
        return plistData;
    }
    
    else {
        NSLog(@"%@", error);
    }
    
    return nil;
}

+(NSDictionary *)dictionaryFromCandy:(Candy *)candy {
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:candy.candy_id, candy.title, candy.subtitle, candy.sku, candy.created_at, candy.updated_at, nil]
                                       forKeys:[NSArray arrayWithObjects:@"candy_id", @"title", @"subtitle", @"sku", @"created_at", @"updated_at", nil]];
}

@end

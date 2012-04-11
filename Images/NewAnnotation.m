//
//  NewAnnotation.m
//  barcodeTest2
//
//  Created by Devin Moss on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewAnnotation.h"

@implementation NewAnnotation
//This should be changed to list the candies that are tagged at the current annotation
//Not to add a new annotation

@synthesize label;

- (void)baseInit {
    label = [[UILabel alloc] init];
    label.text = @"We can put stuff here";
    CGRect labelFrame = CGRectMake(15, 15, 60, 30);
    //label.frame = labelFrame;
    label.frame = self.frame;
    label.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:1.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    //self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = frame;
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];        
    }
    return self;
}

/*- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect labelFrame = CGRectMake(15, 15, 60, 30);
    label.frame = labelFrame;
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

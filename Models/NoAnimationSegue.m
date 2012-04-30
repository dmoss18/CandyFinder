//
//  NoAnimationSegue.m
//  CandyFinder
//
//  Created by Devin Moss on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoAnimationSegue.h"

@implementation NoAnimationSegue

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:0.0
             	                       options:UIViewAnimationTransitionNone
                                        animations:^{
                                            [src presentModalViewController:dst animated:NO];
                                        }
             	                    completion:NULL];
            
}

@end

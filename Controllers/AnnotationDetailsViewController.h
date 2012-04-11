//
//  AnnotationDetailsViewController.h
//  barcodeTest2
//
//  Created by Devin Moss on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationDetailsViewController : UIViewController {
    UILabel *label;
    NSString *labelText;
}

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) NSString *labelText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil labelText:(NSString *)lbltxt;

@end

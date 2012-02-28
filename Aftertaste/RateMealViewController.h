//
//  RateMealViewController.h
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/27/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Meal;
@class AppDelegate;

@interface RateMealViewController : UIViewController

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateButtons;

typedef void (^RatingHandler)(int);
@property (nonatomic, copy) RatingHandler handler;

- (IBAction)rate:(id)sender;

@end

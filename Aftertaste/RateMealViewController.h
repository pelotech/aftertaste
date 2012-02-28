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
@property (nonatomic, retain) Meal *model;

@end

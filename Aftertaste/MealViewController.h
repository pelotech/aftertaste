//
//  MealViewController.h
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Meal;
@class AppDelegate;

@interface MealViewController : UIViewController

@property (nonatomic, weak) UIImageView *background;

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) Meal *model;

@end

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

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenLabel;

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) Meal *model;

@end

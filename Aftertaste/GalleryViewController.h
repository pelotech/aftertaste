//
//  GalleryViewController.h
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;
@class MealViewController;
@class AppDelegate;

@interface GalleryViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, strong) CameraViewController *cameraViewController;
@property (nonatomic, strong) MealViewController *mealViewController1;
@property (nonatomic, strong) MealViewController *mealViewController2;
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, readonly) int total;

- (void)applicationDidBecomeActive;
- (void)flipToCamera;
- (void)flipToLastImage;

@end

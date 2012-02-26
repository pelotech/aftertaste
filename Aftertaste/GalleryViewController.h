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
@interface GalleryViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

//@property (strong, nonatomic) NSArray *pageViewControllers;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, strong) CameraViewController *cameraViewController;
@property (nonatomic, strong) MealViewController *mealViewController;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *mutableFetchResults;

//@property (nonatomic, assign) id<UIPageViewControllerDelegate> delegate;


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end

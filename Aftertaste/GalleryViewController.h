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
@class AVCamViewController;

@interface GalleryViewController : UIViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) AVCamViewController *cameraViewController;
@property (nonatomic, strong) NSMutableArray *mealViewControllers;
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) int currentIndex;

- (int)getTotalMeals;

- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;
- (void)flipToCamera:(BOOL)animated;
- (void)flipToLastImage:(BOOL)animated;

- (void)setupContentSizeAndCamera;
- (void)setUpForIndex:(int)index previousIndex:(int)previousIndex;
- (void)moveToIndex:(int)index animated:(BOOL)animated;

@end

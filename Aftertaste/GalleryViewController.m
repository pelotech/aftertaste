//
//  GalleryViewController.m
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import "GalleryViewController.h"
#import "MealViewController.h"
#import "CameraViewController.h"
#import "AppDelegate.h"
#import "RateMealViewController.h"
#import "Meal.h"

@implementation GalleryViewController

@synthesize pageViewController;
@synthesize cameraViewController;
@synthesize mealViewController1;
@synthesize mealViewController2;
@synthesize appDelegate;

@synthesize managedObjectContext;
@synthesize fetchedResultsController;

- (void)askForRatingIfNeeded
{
    NSDate *end = [AppDelegate offsetDate:[NSDate date] byHours:-2];
    NSDate *begin = [AppDelegate offsetDate:end byMinutes:-15];
    
    NSMutableArray *inWindow = [NSMutableArray array];
    
    for (int index = self.total - 1; index >= 0; index--) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        Meal *meal = [fetchedResultsController  objectAtIndexPath:path];
        
        if ([begin compare:meal.timeStamp] == NSOrderedDescending) break;
        
        if ([begin compare:meal.timeStamp] == NSOrderedAscending
            && [end compare:meal.timeStamp] == NSOrderedDescending
            && [meal.rating intValue] == 0) {
            [inWindow addObject:meal];
        }
    }
    
    if ([inWindow count] > 0) {
        RateMealViewController *rateMealViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"RateMealViewController"];
        rateMealViewController.handler = ^(int rating) {
            [inWindow enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Meal* meal = (Meal *)obj;
                meal.rating = [NSNumber numberWithInt:rating];
            }];
            [appDelegate saveContext];
        };
        
        [self presentModalViewController:rateMealViewController animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{    
    [self askForRatingIfNeeded];
}

- (int)total
{
    NSLog(@"GalleryViewController:getTotal");
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
}

- (void)initFetchedResultsController
{
    NSLog(@"GalleryViewController:initFetchedResultsController");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meal" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];   
    [fetchRequest setFetchBatchSize:10];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
     
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    fetchedResultsController.delegate = self;
    
	NSError *error = nil;
	if (![fetchedResultsController performFetch:&error])
    {
        [AppDelegate logError:error];
	}    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"GalleryViewController:controllerWillChangeContent");
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"GalleryViewController:didChangeSection - %d", type);
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"GalleryViewController:didChangeObject - %d", type);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"GalleryViewController:controllerDidChangeContent");
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"GalleryViewController:viewControllerBeforeViewController");
    
    MealViewController *result;
    int index;         
    
    if (viewController == cameraViewController) {
        result = mealViewController1;
        index = self.total - 1;
    }
    else {
        if (viewController == mealViewController1) {
            result = mealViewController2;
        }
        else {
            result = mealViewController1;
        }
        MealViewController *mvc = (MealViewController *)viewController;
        Meal *meal = mvc.model;
        index = [fetchedResultsController indexPathForObject:meal].row;
        index--;
    }
    
    if (index >= 0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        id model = [fetchedResultsController objectAtIndexPath:path];
        result.model = model;
    }
    else {
        result = nil;
    }
    
    return result;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"GalleryViewController:viewControllerAfterViewController");
    
    UIViewController *result;
    int index;
    
    if (viewController == cameraViewController) result = nil;
    else {
        if (viewController == mealViewController1) {
            result = mealViewController2;
        }
        else {
            result = mealViewController1;
        }
        MealViewController *mvc = (MealViewController *)viewController;
        Meal *meal = mvc.model;
        index = [fetchedResultsController indexPathForObject:meal].row;
        index++;
    
        if (index >= self.total) {
            result = cameraViewController;
        }
        else
        {
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            id model = [fetchedResultsController objectAtIndexPath:path];
            ((MealViewController *)result).model = model;
        }
    }
       
    return result;
}

- (void)flipToCamera
{
    NSLog(@"GalleryViewController:flipToCamera");    
    UIViewController *controller = [pageViewController.viewControllers objectAtIndex:0];

    if (controller != cameraViewController) {
        NSArray *viewControllers = [NSArray arrayWithObjects:cameraViewController, nil];
        [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    }
}

- (void)flipToLastImage
{
    NSLog(@"GalleryViewController:flipToLastImage");
    int index = self.total - 1;
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    Meal *meal = (Meal *)[fetchedResultsController objectAtIndexPath:path];
    mealViewController1.model = meal;
    
    NSArray *viewControllers = [NSArray arrayWithObjects:mealViewController1, nil];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
   
}

- (void)applicationDidBecomeActive
{
    NSLog(@"GalleryViewController:applicationDidBecomeActive");
    [self askForRatingIfNeeded];
}

- (void)applicationWillResignActive
{
    [self flipToCamera];
}

#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    NSLog(@"GalleryViewController:viewDidLoad");
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];  
    
    cameraViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"CameraViewController"];
    cameraViewController.managedObjectContext = self.managedObjectContext;
    cameraViewController.galleryViewController = self;
    
    mealViewController1 = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"MealViewController"];
    mealViewController2 = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"MealViewController"];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.bounds = self.view.bounds;
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    NSArray *pageViewControllers = [NSArray arrayWithObjects:cameraViewController, nil];
    [pageViewController setViewControllers:pageViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [self initFetchedResultsController];
}

- (void)viewDidUnload
{
    [self setPageViewController:nil];
    [self setCameraViewController:nil];
    [self setMealViewController1:nil];
    [self setMealViewController2:nil];
    [self setAppDelegate:nil];

    [self setManagedObjectContext:nil];
    [self setFetchedResultsController:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end

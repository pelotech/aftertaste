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

@implementation GalleryViewController

@synthesize pageViewController;
@synthesize cameraViewController;
@synthesize mealViewController1;
@synthesize mealViewController2;

@synthesize managedObjectContext;
@synthesize fetchedResultsController;

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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
    atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
    newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"GalleryViewController:didChangeObject - %d", type);
}
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"GalleryViewController:controllerDidChangeContent");
}
                                                       
- (void)viewDidLoad 
{
    NSLog(@"GalleryViewController:viewDidLoad");
    
    cameraViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"CameraViewController"];
    cameraViewController.managedObjectContext = self.managedObjectContext;

    mealViewController1 = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"MealViewController"];
    mealViewController2 = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"MealViewController"];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    NSArray *pageViewControllers = [NSArray arrayWithObjects: cameraViewController, nil];
    [pageViewController setViewControllers:pageViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [self initFetchedResultsController];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}


// GENERATED CODE
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // custom setup
//    }
//    return self;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}
//
//#pragma mark - View lifecycle
//
///*
//// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//}
//*/
//
///*
//// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}
//*/
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

@end

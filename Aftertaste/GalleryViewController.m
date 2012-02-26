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

@implementation GalleryViewController

//@synthesize pageViewControllers;
@synthesize pageViewController;
@synthesize cameraViewController;
@synthesize mealViewController;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize mutableFetchResults;
//@synthesize delegate;

- (void)fetchResults
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Meal"];
//    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext];
//    self performFetch
    NSError *error = nil;
    mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    NSLog(@"%@", mutableFetchResults);
}

- (void)viewDidLoad 
{
    cameraViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"CameraViewController"];
    cameraViewController.managedObjectContext = self.managedObjectContext;

    mealViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"MealViewController"];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    NSArray *pageViewControllers = [NSArray arrayWithObjects: cameraViewController, nil];
    [pageViewController setViewControllers:pageViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [self fetchResults];
    
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(mutableFetchResults.count == 0) return nil;
    if(viewController == cameraViewController){
        mealViewController.model = [mutableFetchResults lastObject];
    }
    else{
        NSUInteger index = [mutableFetchResults indexOfObject:mealViewController.model];
        if (index == 0) return nil;
        index--;
        mealViewController.model = [mutableFetchResults objectAtIndex:index]; 
    }
    
    return mealViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if(viewController == cameraViewController) return nil;
    else{
        NSUInteger index = [mutableFetchResults indexOfObject:mealViewController.model];
        index++;
        if (index >= mutableFetchResults.count) return cameraViewController;
        mealViewController.model = [mutableFetchResults objectAtIndex:index]; 
    }
    return mealViewController;
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

//
//  GalleryViewController.m
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import "GalleryViewController.h"
#import "MealViewController.h"
#import "AVCamViewController.h"
#import "AppDelegate.h"
#import "RateMealViewController.h"
#import "Meal.h"

int CACHED_MEAL_VIEW_CONTROLLERS = 3;

@implementation GalleryViewController

@synthesize scrollView;

@synthesize cameraViewController;
@synthesize mealViewControllers;
@synthesize appDelegate;

@synthesize managedObjectContext;
@synthesize fetchedResultsController;

@synthesize currentIndex;

- (void)scrollViewDidScroll:(UIScrollView *)providedScrollView
{    
    int index = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    if (index != currentIndex) {
        [self setUpForIndex:index previousIndex:currentIndex];
        currentIndex = index;
    }
}

- (void)moveViewToIndex:(int)index
{
#ifdef DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    Meal *meal = (Meal *)[fetchedResultsController objectAtIndexPath:path];
    MealViewController *mealViewController = [mealViewControllers objectAtIndex:index % 3];

    mealViewController.model = meal;
    
    CGRect rect = mealViewController.view.frame;
    rect.origin.y = 0;
    rect.origin.x = rect.size.width * index;
    mealViewController.view.frame = rect;
}

- (void)setUpForIndex:(int)index previousIndex:(int)previousIndex
{
#ifdef DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"index: %d", index);
#endif
    if (index < previousIndex && index - 1 >= 0) {
        [self moveViewToIndex:index - 1];
    }
    
    if (index > previousIndex && index + 1 < [self getTotalMeals]) {
        [self moveViewToIndex:index + 1];
    }
}


- (void)moveToIndex:(int)index animated:(BOOL)animated
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    if (index - 1 >= 0) {
        [self moveViewToIndex:index - 1];
    }
        
    if (index >= 0 && index < [self getTotalMeals]) {
        [self moveViewToIndex:index];
    }
    
    if (index + 1 < [self getTotalMeals]) {
        [self moveViewToIndex:index + 1];
    }
    
    currentIndex = index;
    int offset = index * self.scrollView.frame.size.width;
    CGRect target = CGRectMake(offset, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:target animated:animated];
}

- (void)askForRatingIfNeeded
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    NSDate *end = [AppDelegate offsetDate:[NSDate date] byHours:-2];
    NSDate *begin = [AppDelegate offsetDate:end byMinutes:-15];
    
    NSMutableArray *inWindow = [NSMutableArray array];
    
    for (int index = [self getTotalMeals] - 1; index >= 0; index--) {
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
                meal.lastUpdated = [NSDate date];
            }];
            [appDelegate saveContext];
        };
        
        [self presentModalViewController:rateMealViewController animated:YES];
    }
}

- (int)getTotalMeals
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
}

- (void)initFetchedResultsController
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
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
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    if (type == NSFetchedResultsChangeInsert) {
        [self setupContentSizeAndCamera];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
}

- (void)flipToCamera:(BOOL)animated
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    [self moveToIndex:[self getTotalMeals] animated:animated];
}

- (void)flipToLastImage:(BOOL)animated
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    int totalMeals = [self getTotalMeals];
    if (totalMeals > 0) {
        [self moveToIndex:totalMeals - 1 animated:animated];
    }
}

- (void)applicationDidBecomeActive
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    [self askForRatingIfNeeded];
}

- (void)applicationWillResignActive
{
    [self flipToCamera:NO];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    [super viewWillAppear:animated];
    
    [self flipToCamera:NO];
}

- (void)viewDidAppear:(BOOL)animated
{    
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    [super viewDidAppear:animated];
    
    [self askForRatingIfNeeded];
}

- (void)setupContentSizeAndCamera
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    int totalMeals = [self getTotalMeals];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (totalMeals + 1), self.scrollView.frame.size.height);

    CGRect rect;
    rect = cameraViewController.view.frame;
    rect.origin.y = 0;
    rect.origin.x = rect.size.width * totalMeals;
    cameraViewController.view.frame = rect;
    
    [self flipToCamera:NO];
}

- (void)viewDidLoad 
{
#ifdef DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];  
    
    [self initFetchedResultsController];

    cameraViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"CameraViewController"];
    cameraViewController.managedObjectContext = self.managedObjectContext;
    cameraViewController.galleryViewController = self;
    
    [self setupContentSizeAndCamera];
    [self.scrollView addSubview:cameraViewController.view];
    [self addChildViewController:cameraViewController];

    
    mealViewControllers = [NSMutableArray array];
    for (int index = 0; index < CACHED_MEAL_VIEW_CONTROLLERS; index++) {
        MealViewController *mealViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"MealViewController"];
        [mealViewControllers addObject:mealViewController];

        // initialing views offscreen first
        CGRect rect;
        rect = self.scrollView.frame;
        rect.origin.y = rect.size.height;
        mealViewController.view.frame = rect;
        
        [self.scrollView addSubview:mealViewController.view];
        [self addChildViewController:mealViewController];
    }
     
    self.currentIndex = 0;
   
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setCameraViewController:nil];
    [self setMealViewControllers:nil];
    [self setAppDelegate:nil];

    [self setManagedObjectContext:nil];
    [self setFetchedResultsController:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setScrollView:nil];
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

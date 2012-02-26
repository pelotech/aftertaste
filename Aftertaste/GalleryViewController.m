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

@synthesize pageViewControllers;

- (void)viewDidLoad 
{
    MealViewController *meal = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"MealViewController"];
    CameraViewController *camera = [[UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:NULL] instantiateViewControllerWithIdentifier:@"CameraViewController"];
    
    pageViewControllers = [NSArray arrayWithObjects: meal,camera, nil];
    [self setViewControllers:pageViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}


// GENERATED CODE
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
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

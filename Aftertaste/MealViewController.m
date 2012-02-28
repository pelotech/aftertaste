//
//  MealViewController.m
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import "MealViewController.h"
#import "Data Model/Meal.h"
#import "AppDelegate.h"

@implementation MealViewController

@synthesize model = _model;
@synthesize background = _background;
@synthesize appDelegate;

- (void)setModel:(Meal *)value
{
    NSString *path = [[[appDelegate applicationDocumentsDirectory] path] stringByAppendingPathComponent:value.photo];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    self.background.image = image;
    
    _model = value;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

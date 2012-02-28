//
//  RateMealViewController.m
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/27/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import "RateMealViewController.h"
#import "Meal.h"
#import "AppDelegate.h"

@implementation RateMealViewController

@synthesize model = _model;
@synthesize appDelegate;

- (void)setModel:(Meal *)value
{
    NSLog(@"MealViewController::setModel");
    
    _model = value;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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

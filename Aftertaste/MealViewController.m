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

- (void)loadImage:(NSString *)filename
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSString *path = [[[appDelegate applicationDocumentsDirectory] path] stringByAppendingPathComponent:filename];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    self.background.image = image;
}

- (void)setModel:(Meal *)value
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self loadImage:value.photo];
    
    _model = value;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self loadImage:self.model.photo];
    [super viewWillAppear:animated];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

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

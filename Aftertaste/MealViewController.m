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
@synthesize ratingLabel = _ratingLabel;
@synthesize appDelegate;

- (void)loadImage:(NSString *)filename
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    NSString *path = [[[appDelegate applicationDocumentsDirectory] path] stringByAppendingPathComponent:filename];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    self.background.image = image;
}

- (void)setModel:(Meal *)value
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    [self loadImage:value.photo];

    NSLog(@"rating: %@", value.rating);
    if ([value.rating intValue] > 0) {
        self.ratingLabel.hidden = NO;
        self.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@", value.rating];
    }
    else {
        self.ratingLabel.hidden = YES;
    }
    
    _model = value;
}

- (void)viewWillAppear:(BOOL)animated
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    [self loadImage:self.model.photo];
    [super viewWillAppear:animated];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidUnload
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    [self setRatingLabel:nil];
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

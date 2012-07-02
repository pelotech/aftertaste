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
#import "RateMealViewController.h"

@implementation RateMealViewController

@synthesize appDelegate;
@synthesize rateButtons;
@synthesize handler;

- (IBAction)rate:(id)sender
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    if (handler) {
        handler([rateButtons selectedSegmentIndex] + 1);
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [self setRateButtons:nil];
    
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
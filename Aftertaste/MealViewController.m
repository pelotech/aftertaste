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
@synthesize timeTakenLabel = _timeTakenLabel;
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

+ (void)setTextAndSizeLabel:(UILabel *)label forText:(NSString *)text
{
    CGFloat maxWidth = 220 - 20;
    CGFloat maxHeight = 480;
    CGSize maximumLabelSize = CGSizeMake(maxWidth, maxHeight);
    
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap]; 

    CGRect frame = label.frame;
    
    expectedLabelSize.width += 20;
    expectedLabelSize.height = frame.size.height;
    
    frame.size = expectedLabelSize;
    label.frame = frame;
    
    label.text = text;
}

+ (void)ensureViewHas10PixelGutters:(UIView *)view insideParent:(UIView *)parent
{
    CGRect frame = view.frame;
    CGRect parentFrame = parent.frame;
    
    if (frame.origin.x < 10) {
        frame.origin.x = 10;
    }
    if (frame.origin.y < 10) {
        frame.origin.y = 10;
    }
    if (frame.origin.x + frame.size.width > parentFrame.size.width - 10) {
        frame.size.width = parentFrame.size.width - 10 - frame.origin.x;
    }
    if (frame.origin.y + frame.size.height > parentFrame.size.height - 10) {
        frame.size.height = parentFrame.size.height - 10 - frame.origin.y;
    }
    
    view.frame = frame;
}

+ (void)moveViewToBottomRight:(UIView *)view insideParent:(UIView *)parent
{
    CGRect frame = view.frame;
    CGRect parentFrame = parent.frame;
    
    frame.size.width = parentFrame.size.width - 10 - frame.origin.x;
    frame.size.height = parentFrame.size.height - 10 - frame.origin.y;
    
    view.frame = frame;
}

- (void)setModel:(Meal *)value
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    [self loadImage:value.photo];

    if ([value.rating intValue] > 0) {
        self.ratingLabel.hidden = NO;
        NSString *text = [NSString stringWithFormat:@"Rating: %@", value.rating];
        [MealViewController setTextAndSizeLabel:self.ratingLabel forText:text];
        [MealViewController moveViewToBottomRight:self.ratingLabel insideParent:self.view];
    }
    else {
        self.ratingLabel.hidden = YES;
    }
   
#if DEBUG
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"d MMM, h:mma";
    NSString *text = [dateFormat stringFromDate:value.timeStamp];
    [MealViewController setTextAndSizeLabel:self.timeTakenLabel forText:text];
#else
    self.timeTakenLabel.hidden = YES;
#endif    
    
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
    [self setTimeTakenLabel:nil];
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

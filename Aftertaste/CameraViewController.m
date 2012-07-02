//
//  CameraViewController.m
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import "CameraViewController.h"
#import "Meal.h"
#import "AppDelegate.h"
#import "GalleryViewController.h"
#import "Constants.h"

@implementation CameraViewController

@synthesize managedObjectContext;
@synthesize appDelegate;
@synthesize galleryViewController;
@synthesize imagePicker;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size;
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (NSString *)getFilename:(NSDate *)timeStamp
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yMMMd-h.mm.s.'jpeg'";
    
    NSString *filename = [dateFormat stringFromDate:timeStamp];
    return filename;
}

- (void)saveMeal:(NSString *)filename
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    Meal *meal = (Meal *)[NSEntityDescription insertNewObjectForEntityForName:@"Meal" inManagedObjectContext:managedObjectContext];
    
    meal.timeStamp = [NSDate date]; 
    meal.photo = filename;  
    
    [appDelegate saveContext];
}

- (void)savePhoto:(UIImage *)image toFilename:(NSString *)filename
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    // saving the full Retina-resolution image
    screenSize.width *= 2;
    screenSize.height *= 2;
    
    UIImage *smallImage = [CameraViewController imageWithImage:image scaledToSize:screenSize];
    NSData *data = UIImageJPEGRepresentation(smallImage, .85);    
    NSString *path = [[[appDelegate applicationDocumentsDirectory] path] stringByAppendingPathComponent:filename];
    [data writeToFile:path atomically:YES];  
}           

- (void)scheduleNotification:(NSDate *)date
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (!notification)
    {
        NSLog(@"AppDelegate::scheduleReminders: Couldn't create a local notification");
        return;
    }
    
    notification.fireDate = [AppDelegate offsetDate:date byHours:2];
    notification.timeZone = [NSTimeZone localTimeZone];
    
    notification.alertBody = @"You ate two hours ago - rate how you feel now!";
    notification.alertAction = @"Rate!";
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];            
}
                  
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    NSString *filename = [self getFilename:[NSDate date]];
    
    [self savePhoto:[info valueForKey:UIImagePickerControllerOriginalImage] toFilename:filename];
    [self saveMeal:filename];
    [self scheduleNotification:[NSDate date]];
    
    [picker dismissModalViewControllerAnimated:YES];

    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NANOSECONDS_PER_SECOND);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [galleryViewController flipToLastImage:YES];
    });
}

- (IBAction)takePicture:(id)sender
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    #if TARGET_IPHONE_SIMULATOR
        dispatch_async( dispatch_get_main_queue(), ^{
            // can put some code here which will save a photo, replicating camera
        });
    #else
        [self presentModalViewController:imagePicker animated:YES];
    #endif
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
#ifdef TARGET_IPHONE_SIMULATOR
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
#endif
}

- (void)viewDidUnload
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif

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

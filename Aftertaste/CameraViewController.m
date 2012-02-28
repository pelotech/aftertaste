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

@implementation CameraViewController

@synthesize managedObjectContext;
@synthesize appDelegate;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size;
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (NSString *)getFilename:(NSDate *)timeStamp
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yMMMd-h.mm.s.'jpeg'";
    
    NSString *filename = [dateFormat stringFromDate:timeStamp];
    return filename;
}

- (void)saveMeal:(NSString *)filename
{
    Meal *meal = (Meal *)[NSEntityDescription insertNewObjectForEntityForName:@"Meal" inManagedObjectContext:managedObjectContext];
    
    meal.timeStamp = [NSDate date]; 
    meal.photo = filename;  
    
    [appDelegate saveContext];
}

- (void)savePhoto:(UIImage *)image toFilename:(NSString *)filename
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIImage *smallImage = [CameraViewController imageWithImage:image scaledToSize:screenSize];
    NSData *data = UIImageJPEGRepresentation(smallImage, .85);    
    NSString *path = [[[appDelegate applicationDocumentsDirectory] path] stringByAppendingPathComponent:filename];
    [data writeToFile:path atomically:YES];  
}                  
                  
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *filename = [self getFilename:[NSDate date]];
    
    [self savePhoto:[info valueForKey:UIImagePickerControllerOriginalImage] toFilename:filename];
    [self saveMeal:filename];
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    
    #if TARGET_IPHONE_SIMULATOR
        dispatch_async( dispatch_get_main_queue(), ^{
            // can put some code here which will save a photo, replicating camera
        });
    #else
        [self presentModalViewController:cameraUI animated:YES];
    #endif
}

#pragma mark - View lifecycle

- (void) viewDidLoad
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

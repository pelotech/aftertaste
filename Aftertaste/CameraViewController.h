//
//  CameraViewController.h
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class GalleryViewController;

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, weak) GalleryViewController *galleryViewController;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

- (IBAction)takePicture:(id)sender;

@end

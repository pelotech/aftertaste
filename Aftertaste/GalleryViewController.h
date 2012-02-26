//
//  GalleryViewController.h
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *pageViewControllers;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, assign) id<UIPageViewControllerDelegate> delegate;

@end

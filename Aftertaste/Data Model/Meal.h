//
//  Meal.h
//  Aftertaste
//
//  Created by Scott Nonnenberg on 2/25/12.
//  Copyright (c) 2012 Liffft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meal : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSData * location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * lastUpdated;

@end

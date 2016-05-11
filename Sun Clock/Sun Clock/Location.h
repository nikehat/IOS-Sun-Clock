//
//  Location.h
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/6/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <NSCoding>

@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSTimeZone *timeZone;
@property CLLocationCoordinate2D coord;

- (id) initWithCity: (NSString *) theCity andState: (NSString *) theState andTimeZone: (NSTimeZone *) theTimeZone andCoordinate: (CLLocationCoordinate2D) theCoordinate;

- (void)copyValues:(Location *) otherLocation;

- (NSString *) description;

@end

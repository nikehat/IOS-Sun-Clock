//
//  Location.h
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/6/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject

@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* accentCity;
@property (nonatomic, retain) NSString* region;
@property (nonatomic, retain) NSNumber* population;
@property (readonly) CLLocationCoordinate2D coord;

- (id) initWithCounty: (NSString*) theCountry andCity: (NSString*) theCity andAccentCity: (NSString*) theAccentCity andRegion: (NSString*) theRegion andPopulation: (int) thePopulation andCoordinate: (CLLocationCoordinate2D) theCoordinate;

- (NSString*) description;

@end

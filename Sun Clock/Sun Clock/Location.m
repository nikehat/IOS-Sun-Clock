//
//  Location.m
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/6/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize city;
@synthesize state;
@synthesize timeZone;
@synthesize coord;

- (id) initWithCity: (NSString *) theCity andState: (NSString *) theState andTimeZone: (NSTimeZone *) theTimeZone andCoordinate: (CLLocationCoordinate2D) theCoordinate;
{
    self = [super init];
    if( self ){
        city = theCity;
        state = theState;
        timeZone = theTimeZone;
        coord = CLLocationCoordinate2DMake(theCoordinate.latitude, theCoordinate.longitude);
    }
    return self;
}

- (void)copyValues:(Location *)otherLocation {
    city = [otherLocation city];
    state = [otherLocation state];
    timeZone = [otherLocation timeZone];
    coord = [otherLocation coord];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"City: %@; State: %@; Time Zone: %@; Latitude:  %g; Longitude: %g", city, state, timeZone, coord.latitude, coord.longitude];
}

/*- (CLLocationCoordinate2D*) coord
 {
 return &coord;
 }*/

@end

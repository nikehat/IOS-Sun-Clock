//
//  CitiesDatabase.m
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/6/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//


#import "CitiesDatabase.h"

@implementation CitiesDatabase

static CitiesDatabase* _databaseObj;

+ (CitiesDatabase*) database
{
    if (_databaseObj == nil) {
        _databaseObj = [[CitiesDatabase alloc] init];
    }
    return _databaseObj;
}

- (id) init{
    self = [super init];
    if (self) {
        NSString* dbpath = [[NSBundle mainBundle] pathForResource:@"us_cities_with_timezones" ofType:@"sl3"];
        if (sqlite3_open([dbpath UTF8String], &_databaseConnection) != SQLITE_OK) {
            NSLog(@"Failed to open database.");
        }
    }
    return self;
}

- (void) dealloc
{
    sqlite3_close(_databaseConnection);
}

- (NSArray *) citiesOfState:(NSString *)aState {
    NSString* query = [NSString stringWithFormat: @"SELECT * FROM cities where state='%@';", aState];
    return [self databaseFromQuery:query];
}

- (NSArray*) allLocations {
    NSString* query = @"SELECT * FROM cities;";
    return [self databaseFromQuery:query];
}

- (NSArray *)databaseFromQuery:(NSString *)query {
    NSMutableArray* rv = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    const unsigned char* text;
    NSString *city, *state, *timeZone;
    double longitude, latitude;
    if( sqlite3_prepare_v2(_databaseConnection, [query UTF8String], [query length], &stmt, nil) == SQLITE_OK){
        while( sqlite3_step(stmt) == SQLITE_ROW){
            text = sqlite3_column_text(stmt, 0);
            if( text )
                city = [NSString stringWithCString: (const char*)text encoding:NSUTF8StringEncoding];
            else
                city = nil;
            
            text = sqlite3_column_text(stmt, 1);
            if(text)
                state = [NSString stringWithCString: (const char*)text encoding:NSUTF8StringEncoding];
            else
                state = nil;
            
            latitude = sqlite3_column_double(stmt, 2);
            longitude = sqlite3_column_double(stmt, 3);
            
            text = sqlite3_column_text(stmt, 4);
            if(text)
                timeZone = [NSString stringWithCString: (const char*)text encoding:NSUTF8StringEncoding];
            else
                timeZone = nil;
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
            Location *thisLocation = [[Location alloc] initWithCity:city andState:state andTimeZone:[self timezoneFromString:timeZone] andCoordinate:coord];
            [rv addObject: thisLocation];
        }
        sqlite3_finalize(stmt);
    }
    return (NSArray *)rv;
}

- (NSTimeZone *)timezoneFromString:(NSString *)zoneString {
    NSTimeZone *tz;
    if ([zoneString isEqualToString:@"Mountain"])
        tz = [[NSTimeZone alloc] initWithName:@"America/Denver"];
    else if ([zoneString isEqualToString:@"Arizona"])
        tz = [[NSTimeZone alloc] initWithName:@"America/Phoenix"];
    else if ([zoneString isEqualToString:@"Eastern"])
        tz = [[NSTimeZone alloc] initWithName:@"America/New_York"];
    else if ([zoneString isEqualToString:@"Central"])
        tz = [[NSTimeZone alloc] initWithName:@"America/Chicago"];
    else if ([zoneString isEqualToString:@"Pacific"])
        tz = [[NSTimeZone alloc] initWithName:@"America/Los_Angeles"];
    else if ([zoneString isEqualToString:@"Alaska"])
        tz = [[NSTimeZone alloc] initWithName:@"America/Anchorage"];
    else if ([zoneString isEqualToString:@"Hawaii"])
        tz = [[NSTimeZone alloc] initWithName:@"Pacific/Honolulu"];
    else
        tz = [[NSTimeZone alloc] initWithName:zoneString];
    return tz;
}

@end

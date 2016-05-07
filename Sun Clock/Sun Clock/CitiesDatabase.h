//
//  CitiesDatabase.h
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/6/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Location.h"

@interface CitiesDatabase : NSObject
{
    sqlite3* _databaseConnection;
}

+ (CitiesDatabase*) database;
- (NSArray *) citiesOfState:(NSString *)state;
- (NSArray*) allLocations;

@end

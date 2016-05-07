//
//  StatesTableViewController.h
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/6/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "CitiesDatabase.h"

@interface StatesTableViewController : UITableViewController

@property (strong) NSArray *states;
@property (strong) NSArray *stateAbbreviations;
@property (strong) NSString *selectedState;

@end

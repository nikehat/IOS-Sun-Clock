//
//  CitiesTableViewController.h
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/6/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface CitiesTableViewController : UITableViewController

@property (strong) NSArray *cities;
@property (weak) Location *selectedLocation;

@end

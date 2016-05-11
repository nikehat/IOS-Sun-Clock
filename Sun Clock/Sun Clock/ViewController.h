//
//  ViewController.h
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 4/29/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EDSunriseSet.h"
#import "Location.h"
#import "StatesTableViewController.h"
#import "DrawSunClock.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (strong) Location *selectedLocation;
@property (strong) CLLocationManager *locationManager;
@property (strong) CLLocation *bestEffortAtLocation;
@property (strong) NSString *stateString;
@property (strong) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *updatingGPSIndicator;

@end


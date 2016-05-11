//
//  ViewController.m
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 4/29/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *astroTwilightStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *nauticalTwilightStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *civilTwilightStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *astroTwilightEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *nauticalTwilightEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *civilTwilightEndLabel;

@end

@implementation ViewController
// instance variables
@synthesize selectedLocation;
@synthesize locationManager;
@synthesize bestEffortAtLocation;
@synthesize stateString;
@synthesize geocoder;
@synthesize sunriseSet;
// storyboard objects
@synthesize updatingGPSIndicator;
@synthesize astroTwilightEndLabel;
@synthesize astroTwilightStartLabel;
@synthesize nauticalTwilightEndLabel;
@synthesize nauticalTwilightStartLabel;
@synthesize civilTwilightEndLabel;
@synthesize civilTwilightStartLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [updatingGPSIndicator setHidden:YES];
    if (selectedLocation == nil) {
        selectedLocation = [[Location alloc] init];
    }
    locationManager = [[CLLocationManager alloc] init];
}

// Update drawing
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"selectedLocation: %@", selectedLocation);
    
    sunriseSet = [[EDSunriseSet alloc] initWithTimezone:selectedLocation.timeZone latitude:selectedLocation.coord.latitude longitude:selectedLocation.coord.longitude];
    [sunriseSet calculate:[NSDate date]];
    DrawSunClock *drawBoard = (DrawSunClock *)self.view;
    if (selectedLocation.coord.latitude != 0 && selectedLocation.coord.longitude != 0) {
        drawBoard.civilTwilightStart = [sunriseSet localCivilTwilightStart];
        drawBoard.civilTwilightEnd = [sunriseSet localCivilTwilightEnd];
        drawBoard.nauticalTwilightStart = [sunriseSet localNauticalCivilTwilightStart];
        drawBoard.nauticalTwilightEnd = [sunriseSet localNauticalCivilTwilightEnd];
        drawBoard.astronomicalTwilightStart = [sunriseSet localAstronomicalTwilightStart];
        drawBoard.astronomicalTwilightEnd = [sunriseSet localAstronomicalTwilightEnd];
        drawBoard.sunrise = [sunriseSet localSunrise];
        drawBoard.sunset = [sunriseSet localSunset];
        [self updateLabels];
    }
    [self.view setNeedsDisplay];
}


#pragma mark Location Manager Interactions

// Update GPS location using a 25 second timeout
- (IBAction)gpsButtonPressed:(id)sender {
    [updatingGPSIndicator setHidden:NO];
    [updatingGPSIndicator startAnimating];
    // updatingGPSIndicator stops updating in [self stopUpdatingLocation] (poor implementation?)
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:25];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    self.bestEffortAtLocation = newLocation;
    if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
        [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        NSLog(@"LOCATION UPDATED:\nLocationManager.Location: %@", locationManager.location);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

// Handles updating selectedLocation, stops updating GPS location
- (void)stopUpdatingLocation:(NSString *)state {
    stateString = state;
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    
    [updatingGPSIndicator setHidden:YES];
    [updatingGPSIndicator stopAnimating];
    
    // update clock if GPS location acquired
    if ([stateString isEqualToString:NSLocalizedString(@"Acquired Location", @"Acquired Location")]) {
        // if IOS version >= 9.0, update timezone using geolocation; else set it to PST timezone
        if ([self iosVersionAtLeast:9.0]) {
            geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:bestEffortAtLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                for (CLPlacemark * p in placemarks) {
                    selectedLocation.city = [p locality];
                    selectedLocation.state = [p administrativeArea];
                    selectedLocation.timeZone = [p timeZone];
                }
            }];
        }
        else {
            selectedLocation.city = @"Unknown city";
            selectedLocation.state = @"Unkown state";
            selectedLocation.timeZone = [[NSTimeZone alloc] initWithName:@"America/Los_Angeles"];
        }
        selectedLocation.coord = bestEffortAtLocation.coordinate;
    }
    else {
        [self errorMessage:[NSString stringWithFormat:@"GPS failed to update: %@", stateString]];
    }
    [self viewDidAppear:NO];
}

// Return YES for device's IOS version number >= argument version value
- (BOOL)iosVersionAtLeast:(float)versionNumber {
    float deviceVersionNumber = [[[UIDevice currentDevice] systemVersion] floatValue];
    return deviceVersionNumber >= versionNumber;
}

// Popup error message
- (void)errorMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateLabels {
    astroTwilightStartLabel.text = [self hourAndMinutesStringFromDate:sunriseSet.astronomicalTwilightStart];
    astroTwilightEndLabel.text = [self hourAndMinutesStringFromDate:sunriseSet.astronomicalTwilightEnd];
    nauticalTwilightStartLabel.text = [self hourAndMinutesStringFromDate:sunriseSet.nauticalTwilightStart];
    nauticalTwilightEndLabel.text = [self hourAndMinutesStringFromDate:sunriseSet.nauticalTwilightEnd];
    civilTwilightStartLabel.text = [self hourAndMinutesStringFromDate:sunriseSet.civilTwilightStart];
    civilTwilightEndLabel.text = [self hourAndMinutesStringFromDate:sunriseSet.civilTwilightEnd];
}

- (NSString *)hourAndMinutesStringFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    return [NSString stringWithFormat:@"%ld:%.2ld", (long)[components hour], (long)[components minute]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    StatesTableViewController *destinationVC = (StatesTableViewController *)[segue destinationViewController];
    destinationVC.selectedLocation = self.selectedLocation;
}

@end

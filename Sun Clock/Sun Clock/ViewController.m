//
//  ViewController.m
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 4/29/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import "ViewController.h"
#import "EDSunriseSet.h"
#import "Location.h"
#import "StatesTableViewController.h"

@interface ViewController ()

@property (strong) Location *city;

@end

@implementation ViewController

@synthesize outputLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSTimeZone *pstTimeZone = [[NSTimeZone alloc] initWithName:@"America/Los_Angeles"];
    EDSunriseSet *sunriseSet = [[EDSunriseSet alloc] initWithTimezone:pstTimeZone latitude:33.8704 longitude:-117.9243];
    
    [sunriseSet calculateSunriseSunset:[NSDate date]];
    NSLog(@"%@\n\n", [sunriseSet localSunrise]);
    NSLog(@"%@", [sunriseSet localSunset]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    StatesTableViewController *destinationVC = (StatesTableViewController*)[segue destinationViewController];
//}

@end

//
//  AppDelegate.m
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 4/29/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Find the root ViewController object
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    ViewController *mainController = (ViewController *)[navController.viewControllers objectAtIndex:0];
    
    // Create directory if it already doesn't exist
    [self createDir];
    
    // If files exist, load them into the root ViewController
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *projectDir = [self getDirectoryPath];
    NSString *locationDir = [projectDir stringByAppendingString:@"/selectedLocation.plist"];
    if ([fm fileExistsAtPath:locationDir]) {
        mainController.selectedLocation = [NSKeyedUnarchiver unarchiveObjectWithFile:locationDir];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// Encode selectedLocation
- (void)applicationDidEnterBackground:(UIApplication *)application {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    ViewController *mainController = (ViewController *)[navController.viewControllers objectAtIndex:0];
    NSString *archivePath = [self getDirectoryPath];

    NSString *locationPath = [archivePath stringByAppendingString:@"/selectedLocation.plist"];
    if ([NSKeyedArchiver archiveRootObject:[mainController selectedLocation] toFile:locationPath]) {
        NSLog(@"Archived selectedLocation");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// Create directory if it already doesn't exist
- (void)createDir {
    NSString *projectDir = [self getDirectoryPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *theError = nil;
    if (![fm fileExistsAtPath:projectDir]) {
        [fm createDirectoryAtPath:projectDir withIntermediateDirectories:YES attributes:nil error:&theError];
        NSLog(@"created private docs dir");
    }
}

- (NSString *)getDirectoryPath {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = ([libraryDir count] > 0) ? [libraryDir objectAtIndex:0] : nil;
    NSString *privateDocsDir = [libraryPath stringByAppendingString:@"/Private Documents/"];
    NSString *projectDir = [privateDocsDir stringByAppendingString:bundleID];
    //NSLog(@"%@", projectDir);
    return projectDir;
}

@end

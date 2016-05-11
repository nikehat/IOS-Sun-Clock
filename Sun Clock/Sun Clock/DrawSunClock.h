//
//  DrawSunClock.h
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/7/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawSunClock : UIView

@property (strong) NSDateComponents *sunset;
@property (strong) NSDateComponents *sunrise;
@property (strong) NSDateComponents *civilTwilightStart;
@property (strong) NSDateComponents *civilTwilightEnd;
@property (strong) NSDateComponents *nauticalTwilightStart;
@property (strong) NSDateComponents *nauticalTwilightEnd;
@property (strong) NSDateComponents *astronomicalTwilightStart;
@property (strong) NSDateComponents *astronomicalTwilightEnd;

@end

//
//  DrawSunClock.m
//  Sun Clock
//
//  Created by Misha Ovchinnikov on 5/7/16.
//  Copyright © 2016 Misha Ovchinnikov. All rights reserved.
//

#import "DrawSunClock.h"

const CGFloat MINUTES_IN_DAY = 1440;

@implementation DrawSunClock

@synthesize sunset;
@synthesize sunrise;
@synthesize civilTwilightStart;
@synthesize civilTwilightEnd;
@synthesize nauticalTwilightStart;
@synthesize nauticalTwilightEnd;
@synthesize astronomicalTwilightStart;
@synthesize astronomicalTwilightEnd;

- (void)drawRect:(CGRect)rect {
    // Draw circle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGRect rectangle = CGRectMake(10, (rect.size.height / 4), rect.size.width - 20, rect.size.width - 20);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextDrawPath(context, kCGPathFillStroke);
    if (sunrise == nil) return;
    
    // Draw line pointing to current time
    CGFloat alpha = ([self getMinutesSinceMidnight] / MINUTES_IN_DAY) * 360;
    [self drawLineAtAngle:alpha withColor:[UIColor greenColor] inRect:rect];
    
    // Draw civil, nautical, and astronomical lines
    NSLog(@"Astro. Twilight start: %@", astronomicalTwilightStart);
    [self drawLineAtAngle:[self getAngleFor:civilTwilightStart] withColor:[UIColor yellowColor] inRect:rect];
    [self drawLineAtAngle:[self getAngleFor:civilTwilightEnd] withColor:[UIColor yellowColor] inRect:rect];
    [self drawLineAtAngle:[self getAngleFor:nauticalTwilightStart] withColor:[UIColor yellowColor] inRect:rect];
    [self drawLineAtAngle:[self getAngleFor:nauticalTwilightEnd] withColor:[UIColor yellowColor] inRect:rect];
    [self drawLineAtAngle:[self getAngleFor:astronomicalTwilightStart] withColor:[UIColor yellowColor] inRect:rect];
    [self drawLineAtAngle:[self getAngleFor:astronomicalTwilightEnd] withColor:[UIColor yellowColor] inRect:rect];
    [self drawLineAtAngle:[self getAngleFor:sunrise] withColor:[UIColor yellowColor] inRect:rect];
    [self drawLineAtAngle:[self getAngleFor:sunset] withColor:[UIColor yellowColor] inRect:rect];
}

- (CGFloat)getMinutesSinceMidnight {
    NSDateComponents *components = [[NSCalendar currentCalendar] components: (NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    NSUInteger minsFromMidnight = [components hour] * 60 + [components minute];
    
    return (CGFloat)minsFromMidnight;
}

- (void)drawLineAtAngle:(CGFloat)angle withColor:(UIColor *)color inRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat radius = (rect.size.width - 20) / 2;
    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = (rect.size.height / 2) + 13;  // should be (+ 10), but (+ 13) is more accurate for some reason
    
    CGFloat destinationX = centerX + (radius * sin(angle * M_PI / 180));    // (angle * pi / 180) to convert radians to degrees
    CGFloat destinationY = centerY - (radius * cos(angle * M_PI / 180));
    
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextMoveToPoint(context, centerX, centerY);
    CGContextAddLineToPoint(context, destinationX, destinationY);
    CGContextStrokePath(context);
}

- (CGFloat)getAngleFor:(NSDateComponents *)component {
    CGFloat minutes = (CGFloat)(component.hour * 60 + component.minute);
    return (minutes / MINUTES_IN_DAY) * 360;
}

@end

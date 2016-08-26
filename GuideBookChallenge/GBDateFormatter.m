//
//  GBDateFormatter.m
//  GuideBookChallenge
//
//  Created by Ethan Schatzline on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import "GBDateFormatter.h"

@implementation GBDateFormatter


+ (id)sharedInstance {
    static GBDateFormatter *sharedFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFormatter = [[self alloc] init];
        sharedFormatter.dateFormatter = [[NSDateFormatter alloc] init];
        [sharedFormatter.dateFormatter setDateFormat:@"MMM d, y"];
        sharedFormatter.timeFormatter = [[NSDateFormatter alloc] init];
        [sharedFormatter.timeFormatter setDateFormat:@"h:mm a"];
    });
    return sharedFormatter;
}

@end

//
//  GBDateFormatter.h
//  GuideBookChallenge
//
//  Created by Ethan Schatzline on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBDateFormatter : NSObject

@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) NSDateFormatter *timeFormatter;

+ (id)sharedInstance;

@end

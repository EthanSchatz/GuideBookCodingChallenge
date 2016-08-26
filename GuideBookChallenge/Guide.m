//
//  Guide.m
//  GuideBookChallenge
//
//  Created by everis on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import "Guide.h"

@interface Guide()

@property (nonatomic, readwrite) NSString *name;

@property (nonatomic, readwrite) NSString *city;

@property (nonatomic, readwrite) NSString *state;

@property (nonatomic, readwrite) NSDate *startDate;

@property (nonatomic, readwrite) NSDate *endDate;

@end

@implementation Guide

- (Guide *) initWithName:(NSString *) name
                    city:(NSString *) city
                   state:(NSString *) state
               startDate:(NSDate *) startDate
                 endDate:(NSDate *) endDate {
    Guide *result = [[Guide alloc] init];
    result.name = name;
    result.city = city;
    result.state = state;
    result.startDate = startDate;
    result.endDate = endDate;
    
    return result;
}

@end

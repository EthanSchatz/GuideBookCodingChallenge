//
//  Guide.m
//  GuideBookChallenge
//
//  Created by everis on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import "Guide.h"
#import "GBDateFormatter.h"

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

- (NSString *)name {
    NSString *result = @"";
    if (_name) {
        result = [result stringByAppendingString:_name];
    }
    return result;
}

- (NSString *)city {
    NSString *result = @"";
    if (_city) {
        result = [result stringByAppendingString:_city];
    }
    return result;
}

- (NSString *)state {
    NSString *result = @"";
    if (_state) {
        result = [result stringByAppendingString:_state];
    }
    return result;
}

- (NSString *)cityState {
    NSString *result = @"";
    NSString *city = [self city];
    NSString *state = [self state];
    if (city.length > 0) {
        if (state.length > 0) {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%@, %@",city,state]];
        } else {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%@",city]];
        }
    } else if (state.length > 0) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%@",state]];
    } else {
        result = @"Location Unknown";
    }
    return result;
}

- (NSString *)startDateString {
    NSString *result = @"";
    if (_startDate) {
        result = [result stringByAppendingString:[self stringFromDate:_startDate]];
    }
    return result;
}

- (NSString *)endDateString {
    NSString *result = @"";
    if (_endDate) {
        result = [result stringByAppendingString:[self stringFromDate:_endDate]];
    }
    return result;
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[GBDateFormatter sharedInstance] dateFormatter];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

@end

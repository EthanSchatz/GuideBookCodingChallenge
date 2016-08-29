//
//  Guide.h
//  GuideBookChallenge
//
//  Created by everis on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Guide : NSObject

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSString *city;

@property (nonatomic, readonly) NSString *state;

@property (nonatomic, readonly) NSDate *startDate;

@property (nonatomic, readonly) NSDate *endDate;

@property (nonatomic, readonly) NSString *iconURLString;

@property (nonatomic, readonly) NSString *urlString;

@property (nonatomic, readonly) BOOL isPublic;

- (NSString *)name;

- (NSString *)city;

- (NSString *)state;

- (NSString *)cityState;

- (NSString *)startDateString;

- (NSString *)endDateString;

- (Guide *) initWithName:(NSString *) name
                    city:(NSString *) city
                   state:(NSString *) state
               startDate:(NSDate *) startDate
                 endDate:(NSDate *) endDate
                 iconURLString:(NSString *)iconURLString
               urlString:(NSString *)urlString
                isPublic:(BOOL)isPublic;

@end

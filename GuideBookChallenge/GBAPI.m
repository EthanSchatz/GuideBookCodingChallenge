//
//  GBAPI.m
//  GuideBookChallenge
//
//  Created by Ethan Schatzline on 9/1/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import "GBAPI.h"
#import "AFNetworking.h"
#import "GBDateFormatter.h"
#import "Guide.h"

@implementation GBAPI

#pragma mark - Networking

- (void) getGuides {
    
    // GET the Guides list
    NSString *urlString = @"https://www.guidebook.com/service/v2/upcomingGuides/";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = responseObject;
            NSArray *dataArray = [responseDict objectForKey:@"data"];
            NSMutableArray *guides = [NSMutableArray array];
            
            for (NSDictionary *dataDict in dataArray) {
                
                NSString *objType = [dataDict objectForKey:@"objType"];
                if ([objType isEqualToString:@"guide"]) {
                    NSDate *startDate = [self dateFromString:[dataDict objectForKey:@"startDate"]];
                    NSDate *endDate = [self dateFromString:[dataDict objectForKey:@"endDate"]];
                    NSString *name = [dataDict objectForKey:@"name"];
                    NSString *iconURLString = [dataDict objectForKey:@"icon"];
                    NSString *urlString = [dataDict objectForKey:@"url"];
                    BOOL isPublic = [[dataDict objectForKey:@"login_required"] boolValue];
                    
                    NSDictionary *venueDict = [dataDict objectForKey:@"venue"];
                    NSString *city = [venueDict objectForKey:@"city"];
                    NSString *state = [venueDict objectForKey:@"state"];
                    Guide *guide = [[Guide alloc] initWithName:name
                                                          city:city
                                                         state:state
                                                     startDate:startDate
                                                       endDate:endDate
                                                 iconURLString:iconURLString
                                                     urlString:urlString
                                                      isPublic:isPublic];
                    [guides addObject:guide];
                }
            }
            NSMutableArray *guidesResult = [self separatedGuidesFrom:[guides copy]];
            [_delegate listUpdatedSuccessfully:guidesResult];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [_delegate listFailedToUpdate:self];
    }];
    
}

- (NSMutableArray *)separatedGuidesFrom:(NSArray *)array {
    NSMutableDictionary *sections = [NSMutableDictionary dictionary];
    
    for (Guide *guide in array) {
        NSString *dateString = [guide startDateString];
        NSMutableArray *sectionArray = sections[dateString];
        if (!sectionArray) {
            sectionArray = [NSMutableArray array];
            sections[dateString] = sectionArray;
        }
        
        [sectionArray addObject:guide];
    }
    
    NSMutableArray *guides = [NSMutableArray array];
    for (id key in sections) {
        NSMutableArray *section = sections[key];
        NSArray *sortedSection = [section sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Guide *)a endDate];
            NSDate *second = [(Guide *)b endDate];
            return [first compare:second];
        }];
        [guides addObject:[sortedSection mutableCopy]];
    }
    
    NSArray *sortedGuides;
    sortedGuides = [guides sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Guide *)a[0] startDate];
        NSDate *second = [(Guide *)b[0] startDate];
        return [first compare:second];
    }];
    
    
    return [sortedGuides mutableCopy];
}

- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[GBDateFormatter sharedInstance] dateFormatter];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

@end

//
//  GBAPI.h
//  GuideBookChallenge
//
//  Created by Ethan Schatzline on 9/1/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBAPI.h"
@protocol GBAPIDelegate;

@interface GBAPI : NSObject

@property (nonatomic, weak) id<GBAPIDelegate> delegate;

- (void) getGuides;

@end

@protocol GBAPIDelegate

- (void)listUpdatedSuccessfully:(NSMutableArray *)list;

- (void)listFailedToUpdate:(GBAPI *)api;

@end
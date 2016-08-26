//
//  GuideTableViewCell.h
//  GuideBookChallenge
//
//  Created by Ethan Schatzline on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Guide;

@interface GuideTableViewCell : UITableViewCell

- (void)configureCellWithGuide:(Guide *)guide;

+ (NSString *)reuseIdentifier;

@end

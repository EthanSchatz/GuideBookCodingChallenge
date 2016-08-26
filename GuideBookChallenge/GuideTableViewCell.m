//
//  GuideTableViewCell.m
//  GuideBookChallenge
//
//  Created by Ethan Schatzline on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import "GuideTableViewCell.h"
#import "Guide.h"

@interface GuideTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation GuideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configureCellWithGuide:(Guide *)guide {
    _titleLabel.text = [guide name];
    _detailLabel.text = [NSString stringWithFormat:@"Ends - %@ : %@",[guide endDateString], [guide cityState]];
    [self loadImageWithURLString:guide.iconURLString];
}

- (void)loadImageWithURLString:(NSString *)urlString {
    if (urlString.length > 0) {
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"Error loading icon with url: %@", urlString);
                return;
            }
            
            UIImage *icon = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.iconImageView.image = icon;
            });
            
        }] resume];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"GuideTableViewCell";
}

@end

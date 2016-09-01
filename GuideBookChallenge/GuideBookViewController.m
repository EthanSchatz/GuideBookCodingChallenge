//
//  GuideBookViewController.m
//  GuideBookChallenge
//
//  Created by everis on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import "GuideBookViewController.h"
#import "AFNetworking.h"
#import "Guide.h"
#import "GBDateFormatter.h"
#import "GuideTableViewCell.h"

@interface GuideBookViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *guides;

@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation GuideBookViewController

+ (GuideBookViewController *) GuideBookViewController {
    GuideBookViewController *result = [[GuideBookViewController alloc] initWithNibName:@"GuideBookViewController"
                                                                                          bundle:nil];
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Guides"];
    [self getGuides];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UINib *nib = [UINib nibWithNibName:@"GuideTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:[GuideTableViewCell reuseIdentifier]];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor colorWithRed:0.0 green:0.3 blue:0.6 alpha:1.0];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self action:@selector(getGuides) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayWebViewControllerWithGuide:(Guide *)guide {
    NSString *urlString = [guide urlString];
    NSURL *url = [NSURL URLWithString:urlString];
    UIViewController *webViewController = [[UIViewController alloc] init];
    webViewController.title = [guide name];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webViewController.view.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webViewController.view addSubview:webView];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - Table view data source

- (void) updateGUIWithProcessInfo {
    
    [UIView animateWithDuration:0.2 animations:^{
        _refreshControl.backgroundColor = [UIColor colorWithRed:0.0 green:0.3 blue:0.6 alpha:1.0];
    }];
    [_tableView reloadData];
    
    if (_refreshControl) {
        NSDateFormatter *df = [[GBDateFormatter sharedInstance] timeFormatter];
        NSString *title = [NSString stringWithFormat:@"Last Update: %@", [df stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

- (void)animateRefreshControl {
    [UIView animateWithDuration:0.2 animations:^{
        _refreshControl.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:1.0];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _guides.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *guides = _guides[section];
    return guides.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GuideTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[GuideTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GuideBookCell"];
    }
    Guide *guide = _guides[indexPath.section][indexPath.row];
    [cell configureCellWithGuide:guide];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [view setBackgroundColor:[UIColor redColor]];
    cell.editingAccessoryView = view;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableview canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return true;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = [indexPath row];
        NSInteger section = [indexPath section];
        if (section < _guides.count) {
            NSMutableArray *sectionArray = [_guides objectAtIndex:section];
            if (row < sectionArray.count) {
                [sectionArray removeObjectAtIndex:row];
                if (sectionArray.count == 0) {
                    [_guides removeObjectAtIndex:section];
                }
                [_tableView reloadData];
            }
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Guide *guide = _guides[indexPath.section][indexPath.row];
    NSLog(@"%@ selected", [guide name]);
    // Push detail view controller with guide
    [self displayWebViewControllerWithGuide:guide];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    header.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:1.0];
    UILabel *title = [[UILabel alloc] initWithFrame:header.bounds];
    [title setTextColor:[UIColor blackColor]];
    [title setTextAlignment:NSTextAlignmentCenter];
    Guide *guide = _guides[section][0];
    title.text = [guide startDateString];
    [header addSubview:title];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark - Networking

- (void) getGuides {
    
    // Animate Refresh Control
    [self animateRefreshControl];
    
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
            _guides = [self separatedGuidesFrom:[guides copy]];
            [self updateGUIWithProcessInfo];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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

//
//  GuideBookViewController.m
//  GuideBookChallenge
//
//  Created by everis on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import "GuideBookViewController.h"
#import "Guide.h"
#import "GuideTableViewCell.h"
#import "GBDateFormatter.h"
#import "GBAPI.h"

@interface GuideBookViewController () <UITableViewDelegate, UITableViewDataSource, GBAPIDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *guides;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, readonly) GBAPI *GBapi;

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
    
    _GBapi = [[GBAPI alloc] init];
    [_GBapi setDelegate:self];
    [self startGuideProcess];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UINib *nib = [UINib nibWithNibName:@"GuideTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:[GuideTableViewCell reuseIdentifier]];
    [_tableView setEstimatedRowHeight:70.0];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor colorWithRed:0.0 green:0.3 blue:0.6 alpha:1.0];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self action:@selector(startGuideProcess) forControlEvents:UIControlEventValueChanged];
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
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)startGuideProcess {
    
    // Animate Refresh Control
    [self animateRefreshControl];
    
    [_GBapi getGuides];
    
}

#pragma mark - GBAPI Delegate Methods

- (void)listUpdatedSuccessfully:(NSMutableArray *)list {
    // Handle Success
    _guides = list;
    [self updateGUIWithProcessInfo];
}

- (void)listFailedToUpdate:(GBAPI *)api {
    // Handle Failure
}

@end

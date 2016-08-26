//
//  GuideBookViewController.m
//  GuideBookChallenge
//
//  Created by everis on 8/25/16.
//  Copyright © 2016 Ethan. All rights reserved.
//

#import "GuideBookViewController.h"

@interface GuideBookViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GuideBookViewController

+ (GuideBookViewController *) GuideBookViewController {
    GuideBookViewController *result = [[GuideBookViewController alloc] initWithNibName:@"GuideBookViewController"
                                                                                          bundle:nil];
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuideBookCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GuideBookCell"];
    }
    cell.textLabel.text = @"Alpha Xi Delta National Convention 2015";
    cell.detailTextLabel.text = @"Ends - Jul 4, 2015 : Boston, MA";
    cell.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:115.0/255.0 blue:130.0/255.0 alpha:1.0];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    header.backgroundColor = [UIColor lightGrayColor];
    UILabel *title = [[UILabel alloc] initWithFrame:header.bounds];
    title.text = @"July 01, 2015";
    [header addSubview:title];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


@end

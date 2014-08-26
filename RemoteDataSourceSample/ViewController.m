//
//  ViewController.m
//  RemoteDataSourceSample
//
//  Created by Fábio Bernardo on 26/08/14.
//  Copyright (c) 2014 fbernardo. All rights reserved.
//

#import "ViewController.h"
#import "RemoteDataSource.h"
#import "GistsParser.h"
#import "UIDataSource.h"
#import "Gist.h"

static NSString *const CellIdentifier = @"CellIdentifier";

@interface ViewController () <UITableViewDelegate>
@property(nonatomic, strong) UIDataSource *dataSource;
@property(nonatomic, readonly) RemoteDataSource *remoteDataSource;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController
@dynamic remoteDataSource;

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (RemoteDataSource *)remoteDataSource {
    return (RemoteDataSource *) self.dataSource.dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"https://api.github.com/gists"];

    RemoteDataSource *remoteDataSource = [[RemoteDataSource alloc] initWithServiceURL:url pageParameterName:nil parser:[GistsParser new]];

    UIDataSource *uiDataSource = [UIDataSource UIDataSourceWithDataSource:remoteDataSource
                                                           cellIdentifier:CellIdentifier configureCellBlock:^(id cell, id object, NSIndexPath *indexPath) {
                UITableViewCell *aCell = cell;
                aCell.textLabel.text = ((Gist *)object).description;
            }];
    
    
    self.dataSource = uiDataSource;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = uiDataSource;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __weak typeof(self) weakSelf = self;
    [self.remoteDataSource fetchWithCompletionBlock:^(NSError *error) {
        [weakSelf.tableView reloadData];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Gist *gist = self.dataSource[indexPath];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gist.urlString]];
}


@end

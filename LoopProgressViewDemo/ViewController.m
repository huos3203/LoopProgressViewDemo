//
//  ViewController.m
//  LoopProgressViewDemo
//
//  Created by CUG on 16/9/13.
//  Copyright © 2016年 CUG. All rights reserved.
//

#import "ViewController.h"
#import "ProjectCtlTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCtlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectCtlTableViewCell"];
//    if (!cell) {
//        cell = [[NSBundle mainBundle]loadNibNamed:@"ProjectCtlTableViewCell" owner:self options:nil].lastObject;
//    }
    [cell refreshProjectUI:indexPath.row+50];
    return cell;
}

@end

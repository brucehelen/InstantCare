//
//  KMIndexMenuView.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMIndexMenuView.h"

@interface KMIndexMenuView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataString;

@end

@implementation KMIndexMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self configView];
    }
    
    return self;
}

- (void)initData
{
    self.dataString = @[NSLocalizedStringFromTable(@"MAIN_VC_menu_accout", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"MAIN_VC_menu_device", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"MAIN_VC_menu_logout", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"MAIN_VC_menu_language", APP_LAN_TABLE, nil)];
}

- (void)configView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataString.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"menu-button"];
    cell.textLabel.text = self.dataString[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.delegate respondsToSelector:@selector(KMIndexMenuViewDidClicked:)]) {
        [self.delegate KMIndexMenuViewDidClicked:indexPath.row];
    }
}

@end

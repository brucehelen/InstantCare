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
@property (nonatomic, strong) UITableView *tableView;

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
    self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    // 添加单击事件
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, SCREEN_HEIGHT - 64)];
    [self addSubview:view];

    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                        action:@selector(handleTapGesture:)];
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [view addGestureRecognizer:sigleTapRecognizer];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH/2.0, SCREEN_HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.tableView];
}

- (void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer
{
    [self hide];
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

- (void)show
{
    self.hidden = NO;

    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.tableView.frame;
        frame.origin.x = 0;
        self.tableView.frame = frame;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect frame = self.tableView.frame;
                         frame.origin.x = -SCREEN_WIDTH;
                         self.tableView.frame = frame;
                     } completion:^(BOOL finished) {
                         self.hidden = YES;
                     }];
}

- (BOOL)hiddenStatus
{
    return self.hidden;
}

@end

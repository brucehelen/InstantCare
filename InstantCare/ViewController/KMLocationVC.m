//
//  KMLocationVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMLocationVC.h"
#import <MapKit/MapKit.h>

#define kButtonHeight       40
#define kTableViewHeight    120

@interface KMLocationVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *cardBtn;
@property (nonatomic, strong) UIButton *historyBtn;
@property (nonatomic, strong) UIButton *sosBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation KMLocationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self configNavBar];
    [self configView];
}

- (void)configNavBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-button"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBarButtonDidClicked:)];
    self.navigationItem.title = NSLocalizedStringFromTable(@"MAIN_VC_location_btn", APP_LAN_TABLE, nil);
}

- (void)configView
{
    // 地图
    self.mapView = [[MKMapView alloc] init];
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64 + 3*kButtonHeight);
        make.left.right.bottom.equalTo(self.view);
    }];

    // 3个按钮
    // 1. 打卡
    self.cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cardBtn setTitle:NSLocalizedStringFromTable(@"Location_VC_card_btn", APP_LAN_TABLE, nil)
                  forState:UIControlStateNormal];
    [self.cardBtn setBackgroundImage:[UIImage imageNamed:@"omg_location_check"]
                            forState:UIControlStateNormal];
    self.cardBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cardBtn addTarget:self
                     action:@selector(btnDidClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    self.cardBtn.tag = 100;
    [self.view addSubview:self.cardBtn];
    [self.cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@kButtonHeight);
    }];

    // 2. 历史
    self.historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.historyBtn setTitle:NSLocalizedStringFromTable(@"Location_VC_history_btn", APP_LAN_TABLE, nil)
                forState:UIControlStateNormal];
    [self.historyBtn setBackgroundImage:[UIImage imageNamed:@"omg_location_history"]
                       forState:UIControlStateNormal];
    [self.historyBtn addTarget:self
                        action:@selector(btnDidClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    self.historyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.historyBtn.tag = 101;
    [self.view addSubview:self.historyBtn];
    [self.historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardBtn.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@kButtonHeight);
    }];

    // 3. 救援
    self.sosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sosBtn setTitle:NSLocalizedStringFromTable(@"Location_VC_SOS_btn", APP_LAN_TABLE, nil)
            forState:UIControlStateNormal];
    [self.sosBtn setBackgroundImage:[UIImage imageNamed:@"omg_location_rescue"]
                          forState:UIControlStateNormal];
    [self.sosBtn addTarget:self
                    action:@selector(btnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    self.sosBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.sosBtn.tag = 102;
    [self.view addSubview:self.sosBtn];
    [self.sosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.historyBtn.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@kButtonHeight);
    }];

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@kTableViewHeight);
        make.left.right.equalTo(self.view);
        make.top.equalTo(@0);
    }];
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)btnDidClicked:(UIButton *)sender
{
    static int current_location = 0;
    switch (sender.tag) {
        case 100:       // 打卡
        {
            if (self.tableView.hidden == YES) {
                self.tableView.hidden = NO;
                current_location = 64 + kButtonHeight;
                [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@(current_location));
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kTableViewHeight);
                }];
                [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tableView.mas_bottom);
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kButtonHeight);
                }];
                
                [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.historyBtn.mas_bottom);
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kButtonHeight);
                }];
            } else {
                if (current_location == (64 + kButtonHeight)) {             // tableView显示在打卡下面
                    // 这里隐藏即可
                    self.tableView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@0);
                    }];
                } else if (current_location == (64 + 2*kButtonHeight)) {    // tableView显示在历史下面
                    // 需要更新tableView和救援的位置
                    current_location = 64 + kButtonHeight;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kTableViewHeight);
                    }];
                    [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.tableView.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                    [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.historyBtn.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                } else if (current_location == (64 + 3*kButtonHeight)) {    // tableView现在在救援下面
                    // 更新tableView的位置
                    current_location = 64 + kButtonHeight;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kTableViewHeight);
                    }];
                    [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.tableView.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                    [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.historyBtn.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                }
            }
        } break;
        case 101:       // 历史
        {
            if (self.tableView.hidden == YES) {
                self.tableView.hidden = NO;
                current_location = 64 + 2*kButtonHeight;
                [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@(current_location));
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kTableViewHeight);
                }];
                [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.cardBtn.mas_bottom);
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kButtonHeight);
                }];
                [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tableView.mas_bottom);
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kButtonHeight);
                }];

            } else {
                if (current_location == (64 + kButtonHeight)) {             // tableView显示在打卡下面
                    current_location = 64 + 2*kButtonHeight;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kTableViewHeight);
                    }];
                    [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.cardBtn.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                    [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.tableView.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                } else if (current_location == (64 + 2*kButtonHeight)) {    // tableView显示在历史下面
                    // 这里隐藏即可
                    self.tableView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@0);
                    }];
                } else if (current_location == (64 + 3*kButtonHeight)) {    // tableView现在在救援下面
                    // 更新tableView的位置
                    current_location = 64 + 2*kButtonHeight;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kTableViewHeight);
                    }];
                    [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.cardBtn.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                    [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.tableView.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                }
            }
        } break;
        case 102:       // 救援
        {
            if (self.tableView.hidden == YES) {
                self.tableView.hidden = NO;
                current_location = 64 + 3*kButtonHeight;
                [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@(current_location));
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kTableViewHeight);
                }];
                [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.cardBtn.mas_bottom);
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kButtonHeight);
                }];
                [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.historyBtn.mas_bottom);
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@kButtonHeight);
                }];
            } else {
                if (current_location == (64 + kButtonHeight)) {             // tableView显示在打卡下面
                    current_location = 64 + 3*kButtonHeight;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kTableViewHeight);
                    }];
                    [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.cardBtn.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                    [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.historyBtn.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                } else if (current_location == (64 + 2*kButtonHeight)) {    // tableView显示在历史下面
                    current_location = 64 + 3*kButtonHeight;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kTableViewHeight);
                    }];
                    [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.cardBtn.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                    [self.sosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.historyBtn.mas_bottom);
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@kButtonHeight);
                    }];
                } else if (current_location == (64 + 3*kButtonHeight)) {    // tableView现在在救援下面
                    // 这里隐藏即可
                    self.tableView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(current_location));
                        make.left.right.equalTo(self.view);
                        make.height.equalTo(@0);
                    }];
                }
            }
        } break;
        default:
            break;
    }
}

#pragma mark - tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.text = @"2015.12.01";

    return cell;
}

@end

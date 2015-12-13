//
//  KMLocationVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMLocationVC.h"
#import <MapKit/MapKit.h>
#import "KxMenu.h"
#import "KMBundleDevicesResModel.h"
#import "KMDeviceSetModel.h"
#import "KMLocationSetCell.h"

#define kButtonHeight       40
#define kTableViewHeight    130

#define kButtonTagCheck     100         // 打开
#define kButtonTagRegular   101         // 历史?定期
#define kButtonTagSos       102         // 救援

#define kDefaultIMEILen     8           // 如果本地没有用户名取IMEI最后5位

@interface KMLocationVC () <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, KMLocationSetCellDelegate>

@property (nonatomic, strong) UIButton *cardBtn;
@property (nonatomic, strong) UIButton *historyBtn;
@property (nonatomic, strong) UIButton *sosBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *rightNarBtn;

/**
 *  设备列表
 */
@property (nonatomic, strong) NSArray *devicesArray;

/**
 *  历史记录模型
 */
@property (nonatomic, strong) KMDeviceSetModel *deviceSetModel;

@property (nonatomic, assign) NSInteger currentSelectBtn;

@end

@implementation KMLocationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self configNavBar];
    [self configView];
    
    [self getDevicesFromServer];
}

#pragma mark - 获取设备列表
- (void)getDevicesFromServer
{
    // 设置数据模型
    [KMDeviceSetModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"sos" : @"KMDevicePointModel",
                 // @"sos" : [KMDevicePointModel class],
                 @"regular" : @"KMDevicePointModel",
                 // @"regular" : [KMDevicePointModel class]
                 @"check" : @"KMDevicePointModel"
                 // @"check" : [KMDevicePointModel class]
                 };
    }];

    WS(ws);
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"Call_VC_getdevices", APP_LAN_TABLE, nil)];
    [[KMNetAPI manager] getDevicesWithid:member.userModel.id
                                     key:member.userModel.key
                                   block:^(int code, NSString *res) {
                                       KMBundleDevicesResModel *devices = [KMBundleDevicesResModel mj_objectWithKeyValues:res];
                                       ws.devicesArray = devices.content.devices;
                                       if (code == 0 && devices.status == kNetReqSuccess) {
                                           [ws handleLocationSetWithIMEI:[ws.devicesArray firstObject]];
                                       } else {
                                           [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Call_VC_getdevices_fail", APP_LAN_TABLE, nil)];
                                       }
                                   }];
}

- (void)handleLocationSetWithIMEI:(NSString *)imei
{
    WS(ws);
    [[KMNetAPI manager] requestLocationSetWithIMEI:imei
                                             block:^(int code, NSString *res) {
                                                 KMNetworkResModel *model = [KMNetworkResModel mj_objectWithKeyValues:res];
                                                 if (code == 0 && model.status == kNetReqSuccess) {
                                                     [SVProgressHUD dismiss];
                                                     ws.deviceSetModel = [KMDeviceSetModel mj_objectWithKeyValues:model.content];
                                                     [ws.tableView reloadData];
                                                     
                                                     // 更新右侧标题
                                                     NSString *name = [KMMemberManager userNameWithIMEI:imei];
                                                     if (name == nil) {
                                                         name = [imei substringFromIndex:kDefaultIMEILen];
                                                     }
                                                     [ws.rightNarBtn setTitle:name
                                                                     forState:UIControlStateNormal];
                                                 } else {
                                                     [SVProgressHUD showErrorWithStatus:kNetReqFailStr];
                                                 }
                                             }];
}

- (void)configNavBar
{
    [KxMenu setTintColor:[UIColor grayColor]];

    self.rightNarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightNarBtn setTitle:NSLocalizedStringFromTable(@"Location_VC_latest_record", APP_LAN_TABLE, nil)
                      forState:UIControlStateNormal];
    self.rightNarBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.rightNarBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]]
                                forState:UIControlStateNormal];
    self.rightNarBtn.layer.cornerRadius = 6;
    self.rightNarBtn.clipsToBounds = YES;
    [self.rightNarBtn addTarget:self
                         action:@selector(rightBarButtonDidClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    self.rightNarBtn.frame = CGRectMake(0, 0, 80, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNarBtn];
    
    self.rightNarBtn.hidden = YES;

    self.navigationItem.title = NSLocalizedStringFromTable(@"MAIN_VC_location_btn", APP_LAN_TABLE, nil);
}

- (void)configView
{
    // 地图
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
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
    self.cardBtn.tag = kButtonTagCheck;
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
    self.historyBtn.tag = kButtonTagRegular;
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
    self.sosBtn.tag = kButtonTagSos;
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

#pragma mark - 右侧导航栏最新记录-选择
- (void)rightBarButtonDidClicked:(UIBarButtonItem *)sender
{
    NSMutableArray *menuItems = [NSMutableArray array];

    for (NSString *imei in self.devicesArray) {
        // 首先根据imei找本地存储的用户名
        NSString *name = [KMMemberManager userNameWithIMEI:imei];
        if (name == nil) {
            name = [imei substringFromIndex:imei.length - kDefaultIMEILen];
        }

        KxMenuItem *item = [KxMenuItem menuItem:name
                                          image:nil
                                         target:self
                                         action:@selector(rightMenuCliecked:)];
        item.object = imei;
        [menuItems addObject:item];
    }

    [KxMenu showMenuInView:[[UIApplication sharedApplication].windows lastObject]
                  fromRect:CGRectMake(SCREEN_WIDTH - 100, 30, 80, 30)
                 menuItems:menuItems];
}

- (void)rightMenuCliecked:(KxMenuItem *)item
{
    NSLog(@"imei = %@", item.object);
    
    // 请求这个imei的设备信息
    [SVProgressHUD showWithStatus:kNetReqNowStr];
    [self handleLocationSetWithIMEI:item.object];
}

#pragma mark - 打卡, 历史, 救援按钮点击
- (void)btnDidClicked:(UIButton *)sender
{
    self.rightNarBtn.hidden = NO;
    self.currentSelectBtn = sender.tag;
    [self.tableView reloadData];

    static int current_location = 0;
    switch (sender.tag) {
        case kButtonTagCheck:       // 打卡
        {
            // 跟新tableView的位置
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
        case kButtonTagRegular:       // 历史
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
        case kButtonTagSos:       // 救援
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

#pragma mark - KMLocationSetCellDelegate
- (void)KMLocationSetCellBtnDidClicked:(id)model btn:(UIButton *)button
{
    NSLog(@"model = %@, %d", model, button.tag);
    switch (self.currentSelectBtn) {
        case kButtonTagCheck:       // 打卡
        {
            // TODO: 可能需要改Check的模型
            for (int i = 0; i < self.deviceSetModel.check.count; i++) {
                if (model == self.deviceSetModel.check[i]) {
                    KMDevicePointModel *model = self.deviceSetModel.check[i];
                    model.selectIndex = button.tag;
                } else {
                    KMDevicePointModel *model = self.deviceSetModel.check[i];
                    model.selectIndex = 0;
                }
            }
        } break;
        case kButtonTagRegular:     // 历史
        {
            for (int i = 0; i < self.deviceSetModel.regular.count; i++) {
                if (model == self.deviceSetModel.regular[i]) {
                    KMDevicePointModel *model = self.deviceSetModel.regular[i];
                    model.selectIndex = button.tag;
                } else {
                    KMDevicePointModel *model = self.deviceSetModel.regular[i];
                    model.selectIndex = 0;
                }
            }
        } break;
        case kButtonTagSos:         // 救援
        {
            for (int i = 0; i < self.deviceSetModel.sos.count; i++) {
                if (model == self.deviceSetModel.sos[i]) {
                    KMDevicePointModel *model = self.deviceSetModel.sos[i];
                    model.selectIndex = button.tag;
                } else {
                    KMDevicePointModel *model = self.deviceSetModel.sos[i];
                    model.selectIndex = 0;
                }
            }
        } break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retCount = 0;

    switch (self.currentSelectBtn) {
        case kButtonTagCheck:       // 打开
            retCount = self.deviceSetModel.check.count;
            break;
        case kButtonTagRegular:     // 历史
            retCount = self.deviceSetModel.regular.count;
            break;
        case kButtonTagSos:         // 救援
            retCount = self.deviceSetModel.sos.count;
            break;
        default:
            break;
    }

    return retCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMLocationSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[KMLocationSetCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"cell"];
    }
    
    cell.delegate = self;

    switch (self.currentSelectBtn) {
        case kButtonTagCheck:       // 打卡
            cell.model = self.deviceSetModel.check[indexPath.row];
            break;
        case kButtonTagRegular:     // 历史
            cell.model = self.deviceSetModel.regular[indexPath.row];
            break;
        case kButtonTagSos:         // 救援
            cell.model = self.deviceSetModel.sos[indexPath.row];
            break;
        default:
            break;
    }

    return cell;
}

@end

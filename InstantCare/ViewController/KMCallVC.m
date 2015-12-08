//
//  KMCallVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMCallVC.h"
#import "KMCallCell.h"
#import "KMCallView.h"
#import "KMNetAPI.h"
#import "KMBundleDevicesResModel.h"

@interface KMCallVC() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *devicesArray;

@end

@implementation KMCallVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavBar];
    [self configView];
    [self getDevicesFromServer];
}

- (void)configNavBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-button"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBarButtonDidClicked:)];
    self.navigationItem.title = NSLocalizedStringFromTable(@"MAIN_VC_call_btn", APP_LAN_TABLE, nil);
}

- (void)configView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)getDevicesFromServer
{
    WS(ws);
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"Call_VC_getdevices", APP_LAN_TABLE, nil)];
    [[KMNetAPI manager] getDevicesWithid:member.userModel.id
                                     key:member.userModel.key
                                   block:^(int code, NSString *res) {
                                       NSLog(@"res = %@", res);
                                       KMBundleDevicesResModel *devices = [KMBundleDevicesResModel mj_objectWithKeyValues:res];
                                       NSLog(@"devices = %@", devices.content.devices);
                                       ws.devicesArray = devices.content.devices;
                                       if (code == 0 && devices.status == kNetReqSuccess) {
                                           [SVProgressHUD dismiss];
                                           [ws.tableView reloadData];
                                       } else {
                                           [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Call_VC_getdevices_fail", APP_LAN_TABLE, nil)];
                                       }
                                   }];
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devicesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMCallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[KMCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    NSString *imei = self.devicesArray[indexPath.row];

    // 头像
    UIImage *headerImage = [KMMemberManager userHeaderImageWithIMEI:imei];
    if (headerImage) {      // 已经存储过头像
        cell.headImageView.image = headerImage;
    } else {                // 没有在这个手机存储头像，使用默认的头像
        cell.headImageView.image = [UIImage imageNamed:@"omg_call_noimage"];
    }

    // 手表
    KMUserWatchType watchType = [KMMemberManager userWatchTypeWithIMEI:imei];
    switch (watchType) {
        case KM_WATCH_TYPE_GOLD:
            cell.watchImageView.image = [UIImage imageNamed:@"omg_call_icon_watch_gold"];
            break;
        case KM_WATCH_TYPE_BLACK:
            cell.watchImageView.image = [UIImage imageNamed:@"omg_call_icon_watch_black"];
            break;
        case KM_WATCH_TYPE_ORANGE:
            cell.watchImageView.image = [UIImage imageNamed:@"omg_call_icon_watch_orange"];
            break;
        default:
            break;
    }

    // 姓名
    NSString *userName = [KMMemberManager userNameWithIMEI:imei];
    if (userName) {         // 已经设置过姓名
        cell.nameLabel.text = userName;
    } else {                // 没有设置姓名，使用默认的姓名
        cell.nameLabel.text = NSLocalizedStringFromTable(@"Call_VC_getdevices_user_name_not_set", APP_LAN_TABLE, nil);
    }

    // 电话号码
    NSString *phoneNumber = [KMMemberManager userPhoneNumberWithIMEI:imei];
    if (phoneNumber) {      // 设置过电话号码
        cell.phoneLabel.text = phoneNumber;
    } else {                // 没有设置过
        cell.phoneLabel.text = NSLocalizedStringFromTable(@"Call_VC_getdevices_phone_number_not_set", APP_LAN_TABLE, nil);
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *imei = self.devicesArray[indexPath.row];
    if (![KMMemberManager userPhoneNumberWithIMEI:imei]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Call_VC_getdevices_phone_number_not_set_tip", APP_LAN_TABLE, nil)];
        return;
    }

    KMCallView *callView = [[KMCallView alloc] init];
    callView.nameLabel.text = [KMMemberManager userNameWithIMEI:imei];
    callView.phoneLabel.text = [KMMemberManager userPhoneNumberWithIMEI:imei];
    [self.view addSubview:callView];
    [callView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end

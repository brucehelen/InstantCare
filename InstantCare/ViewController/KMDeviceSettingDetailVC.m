//
//  KMDeviceSettingDetailVC.m
//  InstantCare
//
//  Created by 朱正晶 on 15/12/6.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMDeviceSettingDetailVC.h"
#import "KMNetAPI.h"
#import "KMDeviceSettingResModel.h"
#import "KMDeviceSettingEditCell.h"

/**
 *
 Swtich 2byte
 bit1 跌倒開關
 bit2 監聽開關
 bit3 防打擾開關
 bit4 定時開機
 bit5 定時關機
 bit6 抬手亮屏
 bit9 bit8 bit7 GPS上傳間隔
 0x000:關; 0x001:5mins;0x010:15mins;0x011:30mins;0x100:60mins
 bit12 bit11 bit10 通話時間限定
 0x000:關; 0x001:5mins;0x010:15mins;0x011:30mins;0x100:60mins
 bit14 bit13 定期上傳週期時間設定
 0x00:30mins; 0x01:60mins;0x10:90mins;0x011:120mins;
 bit15~bit16 reserved
 */
typedef NS_ENUM(NSInteger, KMDeviceSettingMASK) {
    KM_DEVICE_SETTING_FALL_DOWN_MASK        = 0x0001,       // 跌倒侦测
    KM_DEVICE_SETTING_BACK_LISTEN_MASK      = 0x0002,       // 背景监听
//    KM_DEVICE_SETTING_KEEP_QUIT_MASK        = 0x0004,       // 防打扰开关
    KM_DEVICE_SETTING_SLEEP_TIME_MASK       = 0x0008,       // 定时关机
    KM_DEVICE_SETTING_TIME_SWITCH_MASK      = 0x0010,       // 定时开机
    KM_DEVICE_SETTING_WATCH_LIGTH_MASK      = 0x0020        // 抬手亮屏
};

@interface KMDeviceSettingDetailVC() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray1;
@property (nonatomic, strong) NSArray *dataArray2;
@property (nonatomic, strong) KMDeviceSettingModel *deviceSettingModel;

@end

@implementation KMDeviceSettingDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self initData];
    [self configNavBar];
    [self configView];
}

- (void)initData
{
    self.dataArray1 = @[NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_falldown", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_poweron_time", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_poweroff_time", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_listen", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_light_on", APP_LAN_TABLE, nil),
                        ];
    self.dataArray2 = @[NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_gps_on", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_upload", APP_LAN_TABLE, nil)];
}

- (void)configNavBar
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_title", APP_LAN_TABLE, nil);
}

- (void)configView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    WS(ws);
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws requestDeviceSetting];
    }];

    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"Common_network_request_now", APP_LAN_TABLE, nil)];
    [self requestDeviceSetting];
}

- (void)requestDeviceSetting
{
    WS(ws);
    [[KMNetAPI manager] getDevicesSettingsWithIMEI:self.imei
                                             block:^(int code, NSString *res) {
                                                 [ws.tableView.mj_header endRefreshing];
                                                 KMDeviceSettingResModel *resModel = [KMDeviceSettingResModel mj_objectWithKeyValues:res];

                                                 if (code == 0 && resModel.content) {
                                                     [SVProgressHUD dismiss];
                                                     ws.deviceSettingModel = resModel.content;
                                                     [ws.tableView reloadData];
                                                 } else {
                                                     [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Common_network_request_fail", APP_LAN_TABLE, nil)];
                                                 }
                                             }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.dataArray1.count;
        case 1:
            return self.dataArray2.count;
        default:
            break;
    }

    return 0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_start_frequency", APP_LAN_TABLE, nil);
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (indexPath.section == 0) {       // UISwitch开关
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"cell"];

        }
        
        cell.textLabel.text = self.dataArray1[indexPath.row];
        
        UISwitch *mSwitch = [[UISwitch alloc] init];
        mSwitch.tag = indexPath.row;
        [mSwitch addTarget:self
                    action:@selector(switchDidClick:)
          forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = mSwitch;
        
        //
        switch (indexPath.row) {
            case 0:             // 跌倒侦测
                if (self.deviceSettingModel.setting & KM_DEVICE_SETTING_FALL_DOWN_MASK) {
                    mSwitch.on = YES;
                } else {
                    mSwitch.on = NO;
                }
                break;
            case 1:             // 定时开关
                if (self.deviceSettingModel.setting & KM_DEVICE_SETTING_TIME_SWITCH_MASK) {
                    mSwitch.on = YES;
                } else {
                    mSwitch.on = NO;
                }
                break;
            case 2:             // 定时关机
                if (self.deviceSettingModel.setting & KM_DEVICE_SETTING_SLEEP_TIME_MASK) {
                    mSwitch.on = YES;
                } else {
                    mSwitch.on = NO;
                }
                break;
            case 3:             // 背景监听
                if (self.deviceSettingModel.setting & KM_DEVICE_SETTING_BACK_LISTEN_MASK) {
                    mSwitch.on = YES;
                } else {
                    mSwitch.on = NO;
                }
                break;
            case 4:             // 抬手亮屏
                if (self.deviceSettingModel.setting & KM_DEVICE_SETTING_WATCH_LIGTH_MASK) {
                    mSwitch.on = YES;
                } else {
                    mSwitch.on = NO;
                }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {        // 时间间隔设置
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell == nil) {
            cell = [[KMDeviceSettingEditCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"cell2"];
        }
        KMDeviceSettingEditCell *newCell = (KMDeviceSettingEditCell *)cell;
        newCell.titleLabel.text = self.dataArray2[indexPath.row];
        /**
         *
         bit9 bit8 bit7 GPS上傳間隔
         0x000:關; 0x001:5mins;0x010:15mins;0x011:30mins;0x100:60mins
         bit14 bit13 定期上傳週期時間設定
         0x00:30mins; 0x01:60mins;0x10:90mins;0x011:120mins;
         */
        NSString *detailString;
        switch (indexPath.row) {
            case 0:         // GPS启动频率
            {
                int gpsValue = self.deviceSettingModel.setting >> 6 & 0x7;
                if (gpsValue == 0) {            // GPS关闭
                    detailString = NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_shutdown", APP_LAN_TABLE, nil);
                } else if (gpsValue == 0x1) {   // 5分钟
                    detailString = [NSString stringWithFormat:@"%@5%@",
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                } else if (gpsValue == 0x02) {  // 15分钟
                    detailString = [NSString stringWithFormat:@"%@15%@",
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                } else if (gpsValue == 0x03) {  // 30分钟
                    detailString = [NSString stringWithFormat:@"%@30%@",
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                } else if (gpsValue == 0x04) {  // 60分钟
                    detailString = [NSString stringWithFormat:@"%@60%@",
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                }
            } break;
            case 1:         // 定期上传间隔频率
            {
                int uploadValue = self.deviceSettingModel.setting >> 12 & 0x3;
                if (uploadValue == 0) {             // 30分钟
                    detailString = [NSString stringWithFormat:@"%@30%@",
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                } else if (uploadValue == 0x1) {    // 60分钟
                    detailString = [NSString stringWithFormat:@"%@60%@",
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                } else if (uploadValue == 0x02) {   // 90分钟
                    detailString = [NSString stringWithFormat:@"%@90%@",
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                } else if (uploadValue == 0x03) {   // 120分钟
                    detailString = [NSString stringWithFormat:@"%@120%@",
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                    NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                }
            } break;
            default:
                break;
        }

        newCell.detailLabel.text = detailString;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:     // GPS启动频率
            {
                int gpsValue = self.deviceSettingModel.setting >> 6 & 0x7;
                NSArray *actions = @[NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_shutdown", APP_LAN_TABLE, nil),
                                     [NSString stringWithFormat:@"%@5%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"%@15%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"%@30%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"%@60%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)]];
                [self presentTimeChooseWithTitle:self.dataArray2[indexPath.row]
                                         actions:actions
                                     chooseIndex:gpsValue];
            } break;
            case 1:     // 上传间隔频率
            {
                int uploadValue = self.deviceSettingModel.setting >> 12 & 0x3;
                NSArray *actions = @[[NSString stringWithFormat:@"%@30%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"%@60%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"%@90%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"%@120%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every", APP_LAN_TABLE, nil),
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)]];
                [self presentTimeChooseWithTitle:self.dataArray2[indexPath.row]
                                         actions:actions
                                     chooseIndex:uploadValue];
            } break;
            default:
                break;
        }
    }
}

- (void)presentTimeChooseWithTitle:(NSString *)title
                           actions:(NSArray *)actions
                       chooseIndex:(NSInteger)index
{
    WS(ws);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertActionStyle style = UIAlertActionStyleDefault;
    for (int i = 0; i < actions.count; i++) {
        if (i == index) {
            style = UIAlertActionStyleDestructive;
        } else {
            style = UIAlertActionStyleDefault;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:actions[i]
                                                         style:style
                                                       handler:^(UIAlertAction *action) {
                                                           if ([title isEqualToString:NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_gps_on",
                                                                                                                 APP_LAN_TABLE,
                                                                                                                 nil)]) {           // GPS启动时间设置
                                                               int setting = [ws setChooseGPSTimeDeviceSetting:ws.deviceSettingModel.setting
                                                                                                         index:i];
                                                               [ws updateDeviceSettings:setting];
                                                           } else if ([title isEqualToString:NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_upload",
                                                                                                                        APP_LAN_TABLE,
                                                                                                                        nil)]) {    // 上传时间设置
                                                               int setting = [ws setChooseUploadTimeDeviceSetting:ws.deviceSettingModel.setting
                                                                                              index:i];
                                                               [ws updateDeviceSettings:setting];
                                                           }
                                                           NSLog(@"index: %d", i);
                                                        }];
        [alertController addAction:action];
    }

    // 取消
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Common_cancel", APP_LAN_TABLE, nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:action1];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (int)setDeviceSetting:(int)setting
                  index:(NSInteger)index
{
    int ret;
    switch (index) {
        case 0:         // 跌倒侦测
            ret = setting | KM_DEVICE_SETTING_FALL_DOWN_MASK;
            break;
        case 1:         // 定时开关
            ret = setting | KM_DEVICE_SETTING_TIME_SWITCH_MASK;
            break;
        case 2:         // 定时关机
            ret = setting | KM_DEVICE_SETTING_SLEEP_TIME_MASK;
            break;
        case 3:         // 背景监听
            ret = setting | KM_DEVICE_SETTING_BACK_LISTEN_MASK;
            break;
        case 4:         // 抬手亮屏
            ret = setting | KM_DEVICE_SETTING_WATCH_LIGTH_MASK;
            break;
        default:
            break;
    }

    return ret;
}

- (int)clearDeviceSetting:(int)setting
                    index:(NSInteger)index
{
    int ret;
    switch (index) {
        case 0:         // 跌倒侦测
            ret = setting & ~KM_DEVICE_SETTING_FALL_DOWN_MASK;
            break;
        case 1:         // 定时开关
            ret = setting & ~KM_DEVICE_SETTING_TIME_SWITCH_MASK;
            break;
        case 2:         // 定时关机
            ret = setting & ~KM_DEVICE_SETTING_SLEEP_TIME_MASK;
            break;
        case 3:         // 背景监听
            ret = setting & ~KM_DEVICE_SETTING_BACK_LISTEN_MASK;
            break;
        case 4:         // 抬手亮屏
            ret = setting & ~KM_DEVICE_SETTING_WATCH_LIGTH_MASK;
            break;
        default:
            break;
    }

    return ret;
}

/**
 *  设置GPS启动频率
 *
 *  @param setting 当前的setting值
 *  @param index   要设定的序号(0,1,2,3,4)
 *
 *  @return 新设定的setting值
 */
- (int)setChooseGPSTimeDeviceSetting:(int)setting
                               index:(NSInteger)index
{
    /**
     bit9 bit8 bit7 GPS上傳間隔
     0x000:關; 0x001:5mins;0x010:15mins;0x011:30mins;0x100:60mins
     */
    long setmask = (index & 0x07) << 6;
    long mask = 0x07 << 6;
    long ret = (setting & ~mask) | setmask;
    
    return (int)ret;
}

/**
 *  上传时间设定
 *
 *  @param setting 当前setting值
 *  @param index   序号(0,1,2,3)
 *
 *  @return 新的setting
 */
- (int)setChooseUploadTimeDeviceSetting:(int)setting
                                  index:(NSInteger)index
{
    /*
     bit14 bit13 定期上傳週期時間設定
     0x00:30mins; 0x01:60mins;0x10:90mins;0x011:120mins;
     */
    long setmask = (index & 0x03) << 12;
    long mask = 0x03 << 12;
    long ret = (setting & ~mask) | setmask;
    
    return (int)ret;
}


#pragma mark - UISwitch-更新设定
- (void)switchDidClick:(UISwitch *)mSwitch
{
    int setting;
    BOOL state = mSwitch.isOn;
    NSLog(@"mSwitch %d", mSwitch.isOn);

    if (state) {
        setting = [self setDeviceSetting:self.deviceSettingModel.setting index:mSwitch.tag];
    } else {
        setting = [self clearDeviceSetting:self.deviceSettingModel.setting index:mSwitch.tag];
    }
    
    [self updateDeviceSettings:setting];
}

- (void)updateDeviceSettings:(int)setting
{
    KMDeviceSettingModel *model = [KMDeviceSettingModel new];

    model.id = member.userModel.id;
    model.key = member.userModel.key;
    model.target = self.imei;
    model.foot_length = self.deviceSettingModel.foot_length;
    model.weight = self.deviceSettingModel.weight;
    model.height = self.deviceSettingModel.height;
    model.sos1 = self.deviceSettingModel.sos1;
    model.sos2 = self.deviceSettingModel.sos2;
    model.sos3 = self.deviceSettingModel.sos3;
    model.contact1 = self.deviceSettingModel.contact1;
    model.contact2 = self.deviceSettingModel.contact2;
    model.contact3 = self.deviceSettingModel.contact3;
    model.setting = setting;
    self.deviceSettingModel.setting = setting;
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"Common_network_request_now", APP_LAN_TABLE, nil)];
    WS(ws);
    [[KMNetAPI manager] updateDeviceSettingsWithModel:model
                                                block:^(int code, NSString *res) {
                                                    if (code == 0) {
                                                        [ws requestDeviceSetting];
                                                    } else {
                                                        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Common_network_request_fail", APP_LAN_TABLE, nil)];
                                                    }
                                                }];
}


@end

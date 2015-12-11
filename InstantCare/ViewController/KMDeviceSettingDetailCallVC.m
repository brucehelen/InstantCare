//
//  KMDeviceSettingDetailCallVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/11.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMDeviceSettingDetailCallVC.h"
#import "KMDeviceSettingResModel.h"
#import "KMDeviceSettingEditCell.h"
#import "KMImageTitleButton.h"
#import "CustomIOSAlertView.h"

#define KM_DEVICE_SETTING_KEEP_QUIT_MASK    0x0004  // 防打扰开关
#define kBottomBtnHeight    40


@interface KMDeviceSettingDetailCallVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KMDeviceSettingModel *deviceSettingModel;

@property (nonatomic, strong) NSArray *dataArray1;      // 第一组的row标题
@property (nonatomic, strong) NSArray *dataArray2;      // 第二组亲情号码row标题
@property (nonatomic, strong) NSArray *dataArray3;      // 第三组紧急号码row标题

@property (nonatomic, strong) CustomIOSAlertView *alertView;        // 填写新的号码
@property (nonatomic, strong) NSIndexPath *currentIndexPath;        // 当前选择的路径

@end

@implementation KMDeviceSettingDetailCallVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initDataArray];
    [self configNavBar];
    [self configView];
}

- (void)initDataArray
{
    self.dataArray1 = @[NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_limit", APP_LAN_TABLE, nil)];
    self.dataArray2 = @[NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_first_group", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_second_group", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_third_group", APP_LAN_TABLE, nil)];
    self.dataArray3 = @[NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_first_group", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_second_group", APP_LAN_TABLE, nil),
                        NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_third_group", APP_LAN_TABLE, nil)];
}

- (void)configNavBar
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_title", APP_LAN_TABLE, nil);
}

- (void)configView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:         // 来电静音
            number = 2;
            break;
        case 1:         // 亲情号码
            number = self.dataArray2.count;
            break;
        case 2:         // 紧急号码
            number = self.dataArray3.count;
            break;
        default:
            break;
    }

    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:         // 来电静音
        {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"cell1"];
                }
                
                cell.textLabel.text = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_mute", APP_LAN_TABLE, nil);
                UISwitch *mSwitch = [[UISwitch alloc] init];
                mSwitch.tag = indexPath.row;
                [mSwitch addTarget:self
                            action:@selector(switchDidClick:)
                  forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = mSwitch;
                
                if (self.deviceSettingModel.setting & KM_DEVICE_SETTING_KEEP_QUIT_MASK) {
                    mSwitch.on = YES;
                } else {
                    mSwitch.on = NO;
                }
            } else if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                if (cell == nil) {
                    cell = [[KMDeviceSettingEditCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:@"cell2"];
                }
                KMDeviceSettingEditCell *newCell = (KMDeviceSettingEditCell *)cell;
                newCell.titleLabel.text = self.dataArray1[0];
                
                // bit12 bit11 bit10 通話時間限定
                int callLimit = (self.deviceSettingModel.setting >> 9) & 0x07;
                NSString *detailString = nil;
                switch (callLimit) {
                    case 0:     // 关闭
                    {
                        detailString = NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_shutdown", APP_LAN_TABLE, nil);
                    } break;
                    case 1:     // 5分钟
                    {
                        detailString = [NSString stringWithFormat:@"5%@",
                                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                    } break;
                    case 2:     // 15分钟
                    {
                        detailString = [NSString stringWithFormat:@"15%@",
                                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                    } break;
                    case 3:     // 30分钟
                    {
                        detailString = [NSString stringWithFormat:@"30%@",
                                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                    } break;
                    case 4:     // 60分钟
                    {
                        detailString = [NSString stringWithFormat:@"60%@",
                                        NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)];
                    } break;
                    default:
                        break;
                }
                newCell.detailLabel.text = detailString;
            }
        } break;
        case 1:         // 亲情号码
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (cell == nil) {
                cell = [[KMDeviceSettingEditCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:@"cell2"];
            }
            KMDeviceSettingEditCell *newCell = (KMDeviceSettingEditCell *)cell;
            newCell.titleLabel.text = self.dataArray2[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    newCell.detailLabel.text = self.deviceSettingModel.contact1;
                    break;
                case 1:
                    newCell.detailLabel.text = self.deviceSettingModel.contact2;
                    break;
                case 2:
                    newCell.detailLabel.text = self.deviceSettingModel.contact3;
                    break;
                default:
                    break;
            }
        } break;
        case 2:         // 紧急号码
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (cell == nil) {
                cell = [[KMDeviceSettingEditCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:@"cell2"];
            }
            KMDeviceSettingEditCell *newCell = (KMDeviceSettingEditCell *)cell;
            newCell.titleLabel.text = self.dataArray3[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    newCell.detailLabel.text = self.deviceSettingModel.sos1;
                    break;
                case 1:
                    newCell.detailLabel.text = self.deviceSettingModel.sos2;
                    break;
                case 2:
                    newCell.detailLabel.text = self.deviceSettingModel.sos3;
                    break;
                default:
                    break;
            }
        } break;
        default:
            break;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_set", APP_LAN_TABLE, nil);
            break;
        case 1:
            title = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_family_number", APP_LAN_TABLE, nil);
            break;
        case 2:
            title = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_sos_number", APP_LAN_TABLE, nil);
            break;
        default:
            break;
    }

    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:             // 通话设置
            if (indexPath.row == 1) {       // 通话限制
                // bit12 bit11 bit10 通話時間限定
                int callLimit = (self.deviceSettingModel.setting >> 9) & 0x07;
                NSArray *actions = @[NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_shutdown", APP_LAN_TABLE, nil),
                                     [NSString stringWithFormat:@"5%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"15%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"30%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)],
                                     [NSString stringWithFormat:@"60%@",
                                      NSLocalizedStringFromTable(@"DeviceSettingDetail_VC_every_minute", APP_LAN_TABLE, nil)]];
                [self presentTimeChooseWithTitle:NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_limit", APP_LAN_TABLE, model)
                                         actions:actions
                                     chooseIndex:callLimit];
            }
            break;
        case 1:             // 亲情号码
        case 2:             // 紧急号码
        {
            self.alertView = [[CustomIOSAlertView alloc] init];
            NSString *title2 = nil;
            switch (indexPath.row) {
                case 0:
                    title2 = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_first_group", APP_LAN_TABLE, nil);
                    break;
                case 1:
                    title2 = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_second_group", APP_LAN_TABLE, nil);
                    break;
                case 2:
                    title2 = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_third_group", APP_LAN_TABLE, nil);
                    break;
                default:
                    break;
            }
            NSString *title1;
            if (indexPath.section == 1) {
                title1 = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_family_number", APP_LAN_TABLE, nil);
            } else if (indexPath.section == 2) {
                title1 = NSLocalizedStringFromTable(@"DeviceSettingDetailCall_VC_call_sos_number", APP_LAN_TABLE, nil);
            }
            NSString *title = [NSString stringWithFormat:@"%@ - %@", title1, title2];
            self.alertView.containerView = [self createNumberInputAlertViewWithTitle:title indexPath:(NSIndexPath *)indexPath];
            self.alertView.buttonTitles = nil;
            [self.alertView setUseMotionEffects:YES];
            [self.alertView show];
        } break;
        default:
            break;
    }
}

- (UIView *)createNumberInputAlertViewWithTitle:(NSString *)title
                                      indexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = [indexPath copy];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view).offset(10);
    }];
    
    // number field
    NSString *number = nil;
    switch (indexPath.section) {
        case 1:         // 亲情号码
        {
            switch (indexPath.row) {
                case 0:     // 第一组
                    number = self.deviceSettingModel.contact1;
                    break;
                case 1:     // 第二组
                    number = self.deviceSettingModel.contact2;
                    break;
                case 2:     // 第三组
                    number = self.deviceSettingModel.contact3;
                    break;
                default:
                    break;
            }
        } break;
        case 2:         // 紧急号码
        {
            switch (indexPath.row) {
                case 0:     // 第一组
                    number = self.deviceSettingModel.sos1;
                    break;
                case 1:     // 第二组
                    number = self.deviceSettingModel.sos2;
                    break;
                case 2:     // 第三组
                    number = self.deviceSettingModel.sos3;
                    break;
                default:
                    break;
            }
        } break;
        default:
            break;
    }

    UITextField *numberTextField = [[UITextField alloc] init];
    numberTextField.tag = 100;
    numberTextField.textAlignment = NSTextAlignmentCenter;
    numberTextField.text = number;
    numberTextField.borderStyle = UITextBorderStyleRoundedRect;
    numberTextField.keyboardType = UIKeyboardTypePhonePad;
    numberTextField.placeholder = NSLocalizedStringFromTable(@"Call_VC_getdevices_phone_number_not_set", APP_LAN_TABLE, nil);
    [view addSubview:numberTextField];
    [numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-10);
        make.height.equalTo(@35);
    }];

    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor grayColor];
    [view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@(kBottomBtnHeight + 1));
    }];

    // 最下面两个按钮
    // 完成 - 200
    KMImageTitleButton *completeBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                          title:NSLocalizedStringFromTable(@"DeviceSetting_VC_add_OK", APP_LAN_TABLE, nil)];
    completeBtn.tag = 200;
    completeBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                           forState:UIControlStateNormal];
    [completeBtn addTarget:self
                    action:@selector(numberSelectBtnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView);
        make.bottom.equalTo(grayView);
        make.width.equalTo(grayView).multipliedBy(0.5).offset(-0.5);
        make.height.equalTo(@kBottomBtnHeight);
    }];

    // 取消 - 201
    KMImageTitleButton *cancelBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_btn_cancel_icon"]
                                                                        title:NSLocalizedStringFromTable(@"DeviceSetting_VC_add_cancel", APP_LAN_TABLE, nil)];
    cancelBtn.tag = 201;
    cancelBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                         forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(numberSelectBtnDidClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(grayView);
        make.bottom.equalTo(grayView);
        make.width.equalTo(grayView).multipliedBy(0.5).offset(0.5);
        make.height.equalTo(@kBottomBtnHeight);
    }];

    return view;
}

- (void)numberSelectBtnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 200:       // 完成
        {
            UITextField *textField = [self.alertView.containerView viewWithTag:100];
            switch (self.currentIndexPath.section) {
                case 1:         // 亲情号码
                    switch (self.currentIndexPath.row) {
                        case 0:
                            self.deviceSettingModel.contact1 = textField.text;
                            break;
                        case 1:
                            self.deviceSettingModel.contact2 = textField.text;
                            break;
                        case 2:
                            self.deviceSettingModel.contact3 = textField.text;
                            break;
                        default:
                            break;
                    }
                    break;
                case 2:         // 紧急号码
                    switch (self.currentIndexPath.row) {
                        case 0:
                            self.deviceSettingModel.sos1 = textField.text;
                            break;
                        case 1:
                            self.deviceSettingModel.sos2 = textField.text;
                            break;
                        case 2:
                            self.deviceSettingModel.sos3 = textField.text;
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
            // 更新数据
            [self updateDeviceSettings:self.deviceSettingModel.setting];
        } break;
        case 201:       // 取消
        {

        } break;
        default:
            break;
    }
    
    [self.alertView close];
    self.alertView = nil;
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
                                                           int setting = [ws setChooseCallTimeDeviceSetting:ws.deviceSettingModel.setting
                                                                                                      index:i];
                                                           [ws updateDeviceSettings:setting];
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


- (void)switchDidClick:(UISwitch *)mSwitch
{
    int setting;
    BOOL state = mSwitch.isOn;
    NSLog(@"mSwitch %d", mSwitch.isOn);
    
    if (state) {
        setting = self.deviceSettingModel.setting | KM_DEVICE_SETTING_KEEP_QUIT_MASK;
    } else {
        setting = self.deviceSettingModel.setting & ~KM_DEVICE_SETTING_KEEP_QUIT_MASK;
    }
    
    [self updateDeviceSettings:setting];
}

/**
 *  设置通话限时
 *
 *  @param setting 当前的setting值
 *  @param index   要设定的序号(0,1,2,3,4)
 *
 *  @return 新设定的setting值
 */
- (int)setChooseCallTimeDeviceSetting:(int)setting
                                index:(NSInteger)index
{
    /**
     bit12 bit11 bit10 通話時間限定
     0x000:關; 0x001:5mins;0x010:15mins;0x011:30mins;0x100:60mins
     */
    long setmask = (index & 0x07) << 9;
    long mask = 0x07 << 9;
    long ret = (setting & ~mask) | setmask;

    return (int)ret;
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

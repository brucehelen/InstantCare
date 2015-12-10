//
//  KMDeviceEditVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/2.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMDeviceEditVC.h"
#import "KMDeviceSettingEditCell.h"
#import "KMImageTitleButton.h"
#import "KMDeviceSettingDetailVC.h"
#import "iCarousel.h"
#import "CustomIOSAlertView.h"


#define kEdgeOffset         20
#define kHeadWidth          100
#define kTextFieldHeight    30
#define kWatchSelBtnWidth   30
#define kWatchSelBtnHeiht   50
#define kBottomBtnHeight    40          // 更换手表底部两个button的高度

@interface KMDeviceEditVC() <UITableViewDataSource, UITableViewDelegate, iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) UIImageView *headImageView;       // 头像
@property (nonatomic, strong) UITextField *nameTextField;       // 姓名
@property (nonatomic, strong) UITextField *phoneTextField;      // 电话号码
@property (nonatomic, strong) UITextField *imeiTextField;       // IMEI

// 手表的一些设定
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *settingTitleArray;
@property (nonatomic, strong) NSArray *settingDetailArray;

@property (nonatomic, strong) UIButton *watchBtn;               // 选择手表按钮

// 手表选择
@property (nonatomic, strong) iCarousel *carouselView;              // 手表选择view
@property (nonatomic, strong) CustomIOSAlertView *watchSelectView;  // 跳出手表选择界面
@property (nonatomic, assign) KMUserWatchType selectWatchType;      // 用户选择的手表样式

@end

@implementation KMDeviceEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSettingArray];
    [self configNavBar];
    [self configView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)initSettingArray
{
    self.settingTitleArray = @[NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_device_set", APP_LAN_TABLE, nil),
                               NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_call_set", APP_LAN_TABLE, nil),
                               NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_body_set", APP_LAN_TABLE, nil),
                               NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_device_reset", APP_LAN_TABLE, nil)];
    self.settingDetailArray = @[NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_device_set_detail", APP_LAN_TABLE, nil),
                                NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_call_set_detail", APP_LAN_TABLE, nil),
                                NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_body_set_detail", APP_LAN_TABLE, nil),
                                NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_device_reset_detail", APP_LAN_TABLE, nil)];
}

- (void)configNavBar
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"DeviceEdit_VC_title", APP_LAN_TABLE, nil);
}

- (void)configView
{
    // 头像
    UIImage *headImage = [KMMemberManager userHeaderImageWithIMEI:self.imei];
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.headImageView.image = headImage;
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kEdgeOffset + 5);
        make.width.height.equalTo(@kHeadWidth);
        make.top.equalTo(@(kEdgeOffset + 64));
    }];
    
    // 点击以更换
    UILabel *clickTipLabel = [[UILabel alloc] init];
    clickTipLabel.textAlignment = NSTextAlignmentCenter;
    clickTipLabel.text = NSLocalizedStringFromTable(@"DeviceSetting_VC_edit_change_icon", APP_LAN_TABLE, nil);
    [self.view addSubview:clickTipLabel];
    [clickTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right);
        make.top.equalTo(self.headImageView).with.offset(10);
    }];
    
    // 手表按钮 - 100
    self.watchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.watchBtn.tag = 100;
    self.watchBtn.contentMode = UIViewContentModeScaleAspectFit;
    self.selectWatchType = [KMMemberManager userWatchTypeWithIMEI:self.imei];
    [self.watchBtn setBackgroundImage:[KMMemberManager userWatchImageWithIMEI:self.imei]
                             forState:UIControlStateNormal];
    [self.watchBtn addTarget:self
                 action:@selector(btnDidClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.watchBtn];
    [self.watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-2*kEdgeOffset);
        make.centerY.equalTo(clickTipLabel);
        make.width.equalTo(@30);
        make.height.equalTo(@50);
    }];
    
    WS(ws);
    [clickTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.watchBtn.mas_left);
    }];
    
    // 姓名
    NSString *userName = [KMMemberManager userNameWithIMEI:self.imei];
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    self.nameTextField.placeholder = NSLocalizedStringFromTable(@"Call_VC_getdevices_user_name_not_set", APP_LAN_TABLE, nil);
    if (userName) {
        self.nameTextField.text = userName;
    }
    [self.view addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(20);
        make.bottom.equalTo(self.headImageView);
        make.right.equalTo(self.view).with.offset(-kEdgeOffset);
        make.height.equalTo(@kTextFieldHeight);
    }];
    
    // 电话号码
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.textAlignment = NSTextAlignmentCenter;
    self.phoneTextField.placeholder = NSLocalizedStringFromTable(@"Call_VC_getdevices_phone_number_not_set", APP_LAN_TABLE, nil);
    self.phoneTextField.text = [KMMemberManager userPhoneNumberWithIMEI:self.imei];
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kEdgeOffset);
        make.right.equalTo(self.view).offset(-kEdgeOffset);
        make.top.equalTo(self.headImageView.mas_bottom).offset(kEdgeOffset);
        make.height.equalTo(@kTextFieldHeight);
    }];
    
    // IMEI
    self.imeiTextField = [[UITextField alloc] init];
    self.imeiTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.imeiTextField.textAlignment = NSTextAlignmentCenter;
    self.imeiTextField.text = self.imei;
    self.imeiTextField.enabled = NO;
    [self.view addSubview:self.imeiTextField];
    [self.imeiTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kEdgeOffset);
        make.right.equalTo(self.view).offset(-kEdgeOffset);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(10);
        make.height.equalTo(@kTextFieldHeight);
    }];
    
    // 相关设定
    self.tableView = [[UITableView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).with.offset(-kEdgeOffset);
        make.top.equalTo(self.imeiTextField.mas_bottom).with.offset(kEdgeOffset);
        make.bottom.equalTo(self.view).with.offset(-50);
    }];

    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws.view);
        make.height.equalTo(@41);
    }];
    // 最下面两个按钮
    KMImageTitleButton *OKlBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                     title:NSLocalizedStringFromTable(@"DeviceSetting_VC_OK", APP_LAN_TABLE, nil)];
    OKlBtn.tag = 101;
    OKlBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [OKlBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                         forState:UIControlStateNormal];
    [OKlBtn addTarget:self
                  action:@selector(btnDidClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKlBtn];
    [OKlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5).offset(-0.5);
        make.height.equalTo(@40);
    }];
    KMImageTitleButton *cancelBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_btn_cancel_icon"]
                                                                        title:NSLocalizedStringFromTable(@"DeviceSetting_VC_cancel", APP_LAN_TABLE, nil)];
    cancelBtn.tag = 102;
    cancelBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                         forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(btnDidClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5).offset(-0.5);
        make.height.equalTo(@40);
    }];
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:       // 切换手表
        {
            self.watchSelectView = [[CustomIOSAlertView alloc] init];
            self.watchSelectView.parentView = self.view;
            self.watchSelectView.containerView = [self createWatchSelectView];
            self.watchSelectView.buttonTitles = nil;
            [self.watchSelectView setUseMotionEffects:YES];
            [self.watchSelectView show];
            // 切换到当前用户选择的手表
            KMUserWatchType type = [KMMemberManager userWatchTypeWithIMEI:self.imei];
            [self.carouselView scrollToItemAtIndex:type animated:YES];
        } break;
        case 101:       // 底部完成按钮
        {
            // 保存用户名、手机号、手表类型
            if (self.nameTextField.text.length != 0) {
                [KMMemberManager addUserName:self.nameTextField.text IMEI:self.imei];
                NSLog(@"self.nameTextField.text = %@, %@", self.nameTextField.text, [KMMemberManager userNameWithIMEI:self.imei]);
            }
            if (self.phoneTextField.text.length != 0) {
                [KMMemberManager addUserPhoneNumber:self.phoneTextField.text IMEI:self.imei];
                NSLog(@"self.nameTextField.text = %@, %@", self.phoneTextField.text, [KMMemberManager userPhoneNumberWithIMEI:self.imei]);
            }
            
            [KMMemberManager addUserWatchType:self.selectWatchType IMEI:self.imei];

            //
            [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"Common_save_success", APP_LAN_TABLE, nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } break;
        case 102:       // 底部取消按钮
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMDeviceSettingEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[KMDeviceSettingEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.titleLabel.text = self.settingTitleArray[indexPath.row];
    cell.detailLabel.text = self.settingDetailArray[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    KMDeviceSettingDetailVC *vc = [[KMDeviceSettingDetailVC alloc] init];
    vc.imei = self.imei;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择手表样式
- (UIView *)createWatchSelectView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    
    // 上方说明标签
    UILabel *selectLabel = [[UILabel alloc] init];
    selectLabel.text = NSLocalizedStringFromTable(@"DeviceEdit_VC_watch_select_title", APP_LAN_TABLE, nil);
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:selectLabel];
    [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view).offset(10);
    }];
    
    // 手表选择滑动view
    self.carouselView = [[iCarousel alloc] init];
    self.carouselView.type = iCarouselTypeRotary;
    self.carouselView.dataSource = self;
    self.carouselView.delegate = self;
    [view addSubview:self.carouselView];
    [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(kWatchSelBtnWidth);
        make.right.equalTo(view).offset(-kWatchSelBtnWidth);
        make.top.equalTo(selectLabel.mas_bottom).offset(10);
        make.height.equalTo(@150);
    }];

    WS(ws);
    // 左边选择按钮
    UIButton *leftSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftSelBtn.tag = 100;
    leftSelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftSelBtn setImage:[UIImage imageNamed:@"omg_setting_btn_left"]
                forState:UIControlStateNormal];
    [leftSelBtn addTarget:self
                   action:@selector(watchSelBtnDidClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftSelBtn];
    [leftSelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(ws.carouselView.mas_left);
        make.centerY.equalTo(ws.carouselView);
        make.height.equalTo(@kWatchSelBtnHeiht);
    }];
    
    // 右边的按钮
    UIButton *rightSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSelBtn.tag = 101;
    rightSelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightSelBtn setImage:[UIImage imageNamed:@"omg_setting_btn_right"]
                 forState:UIControlStateNormal];
    [rightSelBtn addTarget:self
                    action:@selector(watchSelBtnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightSelBtn];
    [rightSelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.left.equalTo(ws.carouselView.mas_right);
        make.centerY.equalTo(ws.carouselView);
        make.height.equalTo(@kWatchSelBtnHeiht);
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
                    action:@selector(watchSelBtnDidClicked:)
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
                  action:@selector(watchSelBtnDidClicked:)
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

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSLog(@"viewForItemAtIndex = %d", (int)index);

    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        switch (index) {
            case KM_WATCH_TYPE_GOLD:
                ((UIImageView *)view).image = [UIImage imageNamed:@"omg_setting_icon_watch_gold"];
                break;
            case KM_WATCH_TYPE_BLACK:
                ((UIImageView *)view).image = [UIImage imageNamed:@"omg_setting_icon_watch_black"];
                break;
            case KM_WATCH_TYPE_ORANGE:
                ((UIImageView *)view).image = [UIImage imageNamed:@"omg_setting_icon_watch_orange"];
                break;
            default:
                break;
        }
    }

    return view;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 2.05f;
        }
        default:
        {
            return value;
        }
    }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    NSLog(@"carouselDidEndScrollingAnimation %f, %@", carousel.scrollOffset, NSStringFromCGSize(carousel.contentOffset));
}

#pragma mark - 手表选择按钮
- (void)watchSelBtnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:       // 左边按钮
        {
            NSInteger index = (NSInteger)self.carouselView.scrollOffset + 1;
            [self.carouselView scrollToItemAtIndex:index animated:YES];
        } break;
        case 101:       // 右边按钮
        {
            NSInteger index = (NSInteger)self.carouselView.scrollOffset - 1;
            [self.carouselView scrollToItemAtIndex:index animated:YES];
        } break;
        case 200:       // 完成按钮
        {
            // 存储手表类型
            self.selectWatchType = (NSInteger)self.carouselView.scrollOffset;
            NSLog(@"select watch type = %ld", (long)self.selectWatchType);

            // 更新按钮上面显示的图标
            [self.watchBtn setBackgroundImage:[KMMemberManager userWatchImageWithType:self.selectWatchType]
                                     forState:UIControlStateNormal];
            [self.watchBtn setNeedsDisplay];

            // 删除弹出view
            [self.watchSelectView removeFromSuperview];
            self.carouselView.delegate = nil;
            self.carouselView.dataSource = nil;
            [self.carouselView removeFromSuperview];
            self.watchSelectView = nil;
        } break;
        case 201:       // 取消按钮
        {
            [self.watchSelectView removeFromSuperview];
            self.carouselView.delegate = nil;
            self.carouselView.dataSource = nil;
            [self.carouselView removeFromSuperview];
            self.watchSelectView = nil;
        } break;
        default:
            break;
    }
}


@end

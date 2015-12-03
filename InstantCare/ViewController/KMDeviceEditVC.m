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


#define kEdgeOffset         20
#define kHeadWidth          100
#define kTextFieldHeight    30

@interface KMDeviceEditVC() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *headImageView;       // 头像
@property (nonatomic, strong) UITextField *nameTextField;       // 姓名
@property (nonatomic, strong) UITextField *phoneTextField;      // 电话号码
@property (nonatomic, strong) UITextField *imeiTextField;       // IMEI
@property (nonatomic, strong) UITableView *tableView;           // 一些设定


@end

@implementation KMDeviceEditVC

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(rightBarButtonDidClicked:)];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"MAIN_VC_menu_device", APP_LAN_TABLE, nil);
}

- (void)configView
{
    // 头像
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.backgroundColor = [UIColor greenColor];
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
    UIButton *watchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    watchBtn.tag = 100;
    watchBtn.contentMode = UIViewContentModeScaleAspectFit;
    // TODO: 根据服务端返回的数据显示不同的icon
    [watchBtn setBackgroundImage:[UIImage imageNamed:@"omg_setting_icon_watch_gold"]
                        forState:UIControlStateNormal];
    [watchBtn addTarget:self
                 action:@selector(btnDidClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:watchBtn];
    [watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-2*kEdgeOffset);
        make.centerY.equalTo(clickTipLabel);
        make.width.equalTo(@30);
        make.height.equalTo(@50);
    }];
    
    [clickTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(watchBtn.mas_left);
    }];
    
    // 姓名
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
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
        make.width.equalTo(self.view).multipliedBy(0.5);
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
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.equalTo(@40);
    }];
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonDidClicked:(UIBarButtonItem *)item
{
    
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:       // 手表图片
            
            break;
        case 101:       // 完成
            break;
        case 102:       // 取消
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

    cell.titleLabel.text = @"硬件设定";
    cell.detailLabel.text = @"跌倒侦测, GPS启动频率, 上传间隔...";

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

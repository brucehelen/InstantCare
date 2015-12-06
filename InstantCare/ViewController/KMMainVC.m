//
//  KMMainVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/11/30.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMMainVC.h"
#import "KMPictureCarouselView.h"
#import "KMImageTitleButton.h"
#import "KMLocationVC.h"
#import "KMCallVC.h"
#import "KMIndexMenuView.h"
#import "KMRegisterVC.h"
#import "KMDeviceSettingVC.h"
#import "KMHealthRecordVC.h"
#import "KMVIPServiceVC.h"
#import "KMAcountSettingVC.h"

#define kButtonHeight           0.16
#define kCarouselViewHeight     0.6

@interface KMMainVC () <KMPictureCarouselViewDelegate, KMIndexMenuViewDeleage>

@property (nonatomic, strong) KMIndexMenuView *menuView;

@end

@implementation KMMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%f, %f", SCREEN_WIDTH, SCREEN_HEIGHT);

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
}

- (void)configView
{
    // 图片轮播
    NSArray *images = @[[UIImage imageNamed:@"1.jpg"],
                        [UIImage imageNamed:@"2.jpg"],
                        [UIImage imageNamed:@"3.jpg"]];
    KMPictureCarouselView *pictureView = [[KMPictureCarouselView alloc] initWithImages:images
                                                                                 width:self.view.frame.size.width
                                                                                height:300
                                                                          timeInterval:0];
    pictureView.delegate = self;
    [self.view addSubview:pictureView];
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(kCarouselViewHeight*SCREEN_HEIGHT));
    }];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];

    // 下面四个按钮
    // 1. 定位记录
    KMImageTitleButton *locationBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_main_btn_location_icon"]
                                                                          title:NSLocalizedStringFromTable(@"MAIN_VC_location_btn", APP_LAN_TABLE, nil)];
    locationBtn.tag = 100;
    locationBtn.label.font = [UIFont systemFontOfSize:25];
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                        forState:UIControlStateNormal];
    [locationBtn addTarget:self
                 action:@selector(btnDidClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kButtonHeight*SCREEN_HEIGHT - 1);
        make.right.equalTo(self.view.mas_centerX).offset(-0.5);
        make.height.equalTo(@(kButtonHeight*SCREEN_HEIGHT));
    }];
    
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationBtn).offset(-1);
    }];

    // 2. 健康记录
    KMImageTitleButton *healthBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_main_btn_health_icon"]
                                                                        title:NSLocalizedStringFromTable(@"MAIN_VC_health_btn", APP_LAN_TABLE, nil)];
    healthBtn.tag = 101;
    healthBtn.label.font = [UIFont systemFontOfSize:25];
    [healthBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                           forState:UIControlStateNormal];
    [healthBtn addTarget:self
                    action:@selector(btnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:healthBtn];
    [healthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kButtonHeight*SCREEN_HEIGHT - 1);
        make.left.equalTo(self.view.mas_centerX).offset(0.5);
        make.height.equalTo(@(kButtonHeight*SCREEN_HEIGHT));
    }];

    // 3. 拨打电话
    KMImageTitleButton *callBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_main_btn_phone_icon"]
                                                                      title:NSLocalizedStringFromTable(@"MAIN_VC_call_btn", APP_LAN_TABLE, nil)];
    callBtn.tag = 102;
    callBtn.label.font = [UIFont systemFontOfSize:25];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"omg_service_btn_bonus"]
                         forState:UIControlStateNormal];
    [callBtn addTarget:self
                  action:@selector(btnDidClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(kButtonHeight*SCREEN_HEIGHT));
    }];

    // 4. 会员服务
    KMImageTitleButton *vipBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_main_btn_service_icon"]
                                                                     title:NSLocalizedStringFromTable(@"MAIN_VC_vip_btn", APP_LAN_TABLE, nil)];
    vipBtn.tag = 103;
    vipBtn.label.font = [UIFont systemFontOfSize:25];
    [vipBtn setBackgroundImage:[UIImage imageNamed:@"omg_service_btn_coupon"]
                       forState:UIControlStateNormal];
    [vipBtn addTarget:self
                action:@selector(btnDidClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vipBtn];
    [vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(kButtonHeight*SCREEN_HEIGHT));
    }];
    
    // 侧滑菜单
    self.menuView = [[KMIndexMenuView alloc] init];
    self.menuView.delegate = self;
    self.menuView.hidden = YES;
    [self.view addSubview:self.menuView];
}

#pragma mark - KMPictureCarouselViewDelegate
- (void)BannerViewDidClicked:(NSUInteger)index
{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"Clicked %lu", (unsigned long)index]];
}

#pragma mark - KMIndexMenuViewDeleage
- (void)KMIndexMenuViewDidClicked:(NSUInteger)index
{
    NSLog(@"menu index = %d", (int)index);

    [self.menuView hide];

    switch (index) {
        case 0:         // 账户设定
        {
            KMAcountSettingVC *vc = [[KMAcountSettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 1:         // 装置设定
        {
            KMDeviceSettingVC *vc = [[KMDeviceSettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 2:         // 账号退出
        {
            // 清除登录信息
            member.userModel = nil;
            [self dismissViewControllerAnimated:YES completion:nil];
        } break;
        case 3:         // 语言设定
            break;
        default:
            break;
    }
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)item
{
    if (self.menuView.hidden)
        [self.menuView show];
    else
        [self.menuView hide];
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:           // 定位记录
        {
            KMLocationVC *vc = [[KMLocationVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 101:           // 健康记录
        {
            KMHealthRecordVC *vc = [[KMHealthRecordVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 102:           // 拨打电话
        {
            KMCallVC *vc = [[KMCallVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 103:           // 会员服务
        {
            KMVIPServiceVC *vc = [[KMVIPServiceVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        default:
            break;
    }
}

@end

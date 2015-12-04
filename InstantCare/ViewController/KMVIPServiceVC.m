//
//  KMVIPServiceVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMVIPServiceVC.h"
#import "KMPictureCarouselView.h"
#import "KMImageTitleButton.h"
#import "KMIndexMenuView.h"

#define kButtonHeight           0.16
#define kCarouselViewHeight     0.6

@interface KMVIPServiceVC() <KMPictureCarouselViewDelegate, KMIndexMenuViewDeleage>

@end

@implementation KMVIPServiceVC

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
    self.navigationItem.title = NSLocalizedStringFromTable(@"MAIN_VC_vip_btn", APP_LAN_TABLE, nil);
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        make.height.equalTo(@(kButtonHeight*SCREEN_HEIGHT*2 + 2));
    }];

    // 下面四个按钮
    // 1. 电子钱包
    KMImageTitleButton *locationBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_service_btn_wallet_icon"]
                                                                          title:NSLocalizedStringFromTable(@"VIPService_VC_wallet", APP_LAN_TABLE, nil)];
    locationBtn.tag = 100;
    locationBtn.label.font = [UIFont systemFontOfSize:25];
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"omg_service_btn_wallet"]
                           forState:UIControlStateNormal];
    [locationBtn addTarget:self
                    action:@selector(btnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kButtonHeight*SCREEN_HEIGHT - 1);
        make.right.equalTo(self.view.mas_centerX).with.offset(-0.5);
        make.height.equalTo(@(kButtonHeight*SCREEN_HEIGHT));
    }];

    // 2. 超级商城
    KMImageTitleButton *healthBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_service_btn_market_icon"]
                                                                        title:NSLocalizedStringFromTable(@"VIPService_VC_super_mall", APP_LAN_TABLE, nil)];
    healthBtn.tag = 101;
    healthBtn.label.font = [UIFont systemFontOfSize:25];
    [healthBtn setBackgroundImage:[UIImage imageNamed:@"omg_service_btn_market"]
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

    // 3. 红利专区
    KMImageTitleButton *callBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_service_btn_bonus_icon"]
                                                                      title:NSLocalizedStringFromTable(@"VIPService_VC_bonus_area", APP_LAN_TABLE, nil)];
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
        make.right.equalTo(self.view.mas_centerX).offset(-0.5);
        make.height.equalTo(@(kButtonHeight*SCREEN_HEIGHT));
    }];

    // 4. 电子票券
    KMImageTitleButton *vipBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_service_btn_coupon_icon"]
                                                                     title:NSLocalizedStringFromTable(@"VIPService_VC_electronic_ticket", APP_LAN_TABLE, nil)];
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
        make.left.equalTo(self.view.mas_centerX).offset(0.5);
        make.height.equalTo(@(kButtonHeight*SCREEN_HEIGHT));
    }];
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:           // 电子钱包
        {
            [SVProgressHUD showInfoWithStatus:@"电子钱包"];
        } break;
        case 101:           // 超级商城
        {
            [SVProgressHUD showInfoWithStatus:@"超级商城"];
        } break;
        case 102:           // 红利专区
        {
            [SVProgressHUD showInfoWithStatus:@"红利专区"];
        } break;
        case 103:           // 电子票券
        {
            [SVProgressHUD showInfoWithStatus:@"电子票券"];
        } break;
        default:
            break;
    }
}

@end


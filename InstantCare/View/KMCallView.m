//
//  KMCallView.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMCallView.h"
#import "KMImageTitleButton.h"

#define kButtonHeight       70

@interface KMCallView()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UILabel *callTypeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@end


@implementation KMCallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    
    return self;
}

- (void)configView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    self.callTypeLabel = [[UILabel alloc] init];
    self.callTypeLabel.font = [UIFont boldSystemFontOfSize:20];
    self.callTypeLabel.text = NSLocalizedStringFromTable(@"Call_VC_calltype", APP_LAN_TABLE, nil);
    [view addSubview:self.callTypeLabel];
    [self.callTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(10);
    }];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(self.callTypeLabel.mas_bottom).with.offset(10);
    }];
    
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor grayColor];
    [view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@(kButtonHeight + 1));
    }];

    KMImageTitleButton *speedDailBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_call_btn_call_icon"]
                                                                           title:NSLocalizedStringFromTable(@"Call_VC_SpeedDial", APP_LAN_TABLE, nil)];
    speedDailBtn.tag = 100;
    speedDailBtn.label.font = [UIFont systemFontOfSize:25];
    [speedDailBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                            forState:UIControlStateNormal];
    [speedDailBtn addTarget:self
                     action:@selector(btnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:speedDailBtn];
    [speedDailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.right.equalTo(view.mas_centerX).offset(-0.5);
        make.height.equalTo(@kButtonHeight);
    }];
    
    KMImageTitleButton *envListenBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_call_btn_secretcall_icon"]
                                                                           title:NSLocalizedStringFromTable(@"Call_VC_Envlistening", APP_LAN_TABLE, nil)];
    envListenBtn.tag = 101;
    envListenBtn.label.font = [UIFont systemFontOfSize:25];
    [envListenBtn setBackgroundImage:[UIImage imageNamed:@"omg_call_btn_secretcall"]
                            forState:UIControlStateNormal];
    [envListenBtn addTarget:self
                     action:@selector(btnDidClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:envListenBtn];
    [envListenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(view);
        make.left.equalTo(view.mas_centerX).offset(0.5);
        make.height.equalTo(@kButtonHeight);
    }];
    
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(@200);
    }];
    
    // 添加背景点击事件
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                        action:@selector(handleTapGesture:)];
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:sigleTapRecognizer];
}

- (void)btnDidClicked:(UIButton *)sender
{
    // TODO:
    
}

- (void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer
{
    [self removeFromSuperview];
}

@end

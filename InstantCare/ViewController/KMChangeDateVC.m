//
//  KMChangeDateVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/15.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMChangeDateVC.h"

#define kButtonHeight       40

@interface KMChangeDateVC ()
/**
 *  开始日期
 */
@property (nonatomic, strong) UIDatePicker *startDatePicker;
/**
 *  结束日期
 */
@property (nonatomic, strong) UIDatePicker *endDatePicker;
/**
 *  确定按钮
 */
@property (nonatomic, strong) UIButton *okBtn;
/**
 *  取消按钮
 */
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation KMChangeDateVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self configView];

}

- (void)configView
{
    WS(ws);

    // 标题
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:22];
    label.text = kLoadStringWithKey(@"HealthRecord_VC_change_date_title");
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.top.equalTo(ws.view).offset(30);
    }];

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 330)];
    // 开始日期
    self.startDatePicker = [[UIDatePicker alloc] init];
    self.startDatePicker.datePickerMode = UIDatePickerModeDate;
    self.startDatePicker.date = self.startDate ? self.startDate : [NSDate date];
    [containerView addSubview:self.startDatePicker];
    [self.startDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(containerView);
        make.height.equalTo(@150);
    }];

    // 结束日期
    self.endDatePicker = [[UIDatePicker alloc] init];
    self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    self.endDatePicker.date = self.endDate ? self.endDate : [NSDate date];
    [containerView addSubview:self.endDatePicker];
    [self.endDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(containerView);
        make.height.equalTo(@150);
    }];
    
    containerView.center = self.view.center;
    [self.view addSubview:containerView];
    
    UIView *grayView = [UIView new];
    grayView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws.view);
        make.height.equalTo(@(kButtonHeight + 1));
    }];

    // 底部确认按钮
    self.okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okBtn.tag = 100;
    [self.okBtn setImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                forState:UIControlStateNormal];
    self.okBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.okBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [self.okBtn setTitle:kLoadStringWithKey(@"VC_login_OK")
                forState:UIControlStateNormal];
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"omg_call_btn_call"]
                          forState:UIControlStateNormal];
    [self.okBtn addTarget:self
                   action:@selector(btnDidClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(ws.view);
        make.width.equalTo(ws.view).multipliedBy(0.5).offset(-0.5);
        make.height.equalTo(@(kButtonHeight));
    }];

    // 底部取消按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.tag = 101;
    [self.cancelBtn setImage:[UIImage imageNamed:@"omg_btn_cancel_icon"]
                    forState:UIControlStateNormal];
    self.cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.cancelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.cancelBtn setTitle:kLoadStringWithKey(@"Common_cancel")
                forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_glucose_onclick"]
                          forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self
                       action:@selector(btnDidClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(ws.view);
        make.width.equalTo(ws.view).multipliedBy(0.5).offset(-0.5);
        make.height.equalTo(@(kButtonHeight));
    }];
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:       // 确认
        {
            if (self.startDatePicker.date.timeIntervalSince1970 > self.endDatePicker.date.timeIntervalSince1970) {
                [SVProgressHUD showErrorWithStatus:kLoadStringWithKey(@"HealthRecord_VC_change_date_error")];
                return;
            }

            WS(ws);
            [self dismissViewControllerAnimated:YES
                                     completion:^{
                                         if ([ws.delegate respondsToSelector:@selector(changeDateComplete:endDate:)]) {
                                             [ws.delegate changeDateComplete:ws.startDatePicker.date
                                                                     endDate:ws.endDatePicker.date];
                                         }
                                     }];
        } break;
        case 101:       // 取消
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
            break;
        default:
            break;
    }
}

@end

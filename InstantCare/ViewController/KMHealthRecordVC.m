//
//  KMHealthRecordVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMHealthRecordVC.h"
#import "PNChart.h"
#import "KMNetworkResModel.h"
#import "KMHealthSetModel.h"
#import "KMChangeDateVC.h"

#define kButtonHeight       50
#define kEdgeOffset         10
#define kLineChartHeight    220

@interface KMHealthRecordVC() <PNChartDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  没有点击按钮时显示的说明文字
 */
@property (nonatomic, strong) UILabel *noBtnDidClieckLabel;
/**
 *  底部更改测量区间按钮
 */
@property (nonatomic, strong) UIButton *bottomChangeDateButton;
/**
 *  健康数据模型
 */
@property (nonatomic, strong) KMHealthSetModel *healthSetModel;
/**
 *  说明标签
 */
@property (nonatomic, strong) UILabel *inforLabel;
/**
 *  标准值按钮
 */
@property (nonatomic, strong) UIButton *standButton;

@end

@implementation KMHealthRecordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavBar];
    [self configView];
}

- (void)configNavBar
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"MAIN_VC_health_btn", APP_LAN_TABLE, nil);
}

- (void)configView
{
    WS(ws);
    // 数据模型初始化
    [KMHealthSetModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"bpm" : @"KMBpmModel",
                 @"bgm" : @"KMBgmModel",
                 @"hrate" : @"KMHrateModel",
                 @"steps" : @"KMStepsModel"
                 };
    }];

    // 没有按钮点击时的提示信息
    self.noBtnDidClieckLabel = [UILabel new];
    self.noBtnDidClieckLabel.text = kLoadStringWithKey(@"HealthRecord_VC_init_tip");
    self.noBtnDidClieckLabel.textAlignment = NSTextAlignmentCenter;
    self.noBtnDidClieckLabel.numberOfLines = 0;
    self.noBtnDidClieckLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.noBtnDidClieckLabel];
    [self.noBtnDidClieckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(50);
        make.right.equalTo(ws.view).offset(-50);
        make.centerY.equalTo(ws.view).offset((64 + kEdgeOffset + 2*kButtonHeight)/2.0);
    }];

    // 底部按钮
    self.bottomChangeDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomChangeDateButton setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                                           forState:UIControlStateNormal];
    [self.bottomChangeDateButton setImage:[UIImage imageNamed:@"omg_btn_edit_icon"]
                                 forState:UIControlStateNormal];
    [self.bottomChangeDateButton setTitle:kLoadStringWithKey(@"HealthRecord_VC_change_date")
                                 forState:UIControlStateNormal];
    self.bottomChangeDateButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.bottomChangeDateButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    self.bottomChangeDateButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.bottomChangeDateButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [self.bottomChangeDateButton addTarget:self
                                    action:@selector(changeMeasureDate)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomChangeDateButton];
    [self.bottomChangeDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(kButtonHeight));
    }];
    self.bottomChangeDateButton.hidden = YES;
    
    self.inforLabel = [UILabel new];
    self.inforLabel.numberOfLines = 0;
    self.inforLabel.font = [UIFont systemFontOfSize:20];
    
    // 标准值按钮
    self.standButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.standButton setBackgroundImage:[UIImage imageWithColor:RGB(45, 177, 17)]
                                forState:UIControlStateNormal];
    [self.standButton setTitle:kLoadStringWithKey(@"HealthRecord_VC_pedometer_standard")
                      forState:UIControlStateNormal];
    self.standButton.layer.cornerRadius = 5;
    self.standButton.clipsToBounds = YES;
    self.standButton.hidden = YES;
    [self.view addSubview:self.standButton];
    [self.standButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.view).offset(-kEdgeOffset);
        make.bottom.equalTo(ws.bottomChangeDateButton.mas_top).offset(-kEdgeOffset);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];

    // 灰色背景，显示出细线
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.left.right.equalTo(ws.view);
        make.height.equalTo(@(kButtonHeight*2 + 3));
    }];

    // 血压 - 100
    UIButton *bloodPressureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bloodPressureBtn.tag = 100;
    bloodPressureBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    bloodPressureBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    bloodPressureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [bloodPressureBtn setTitle:NSLocalizedStringFromTable(@"HealthRecord_VC_blood_pressure", APP_LAN_TABLE, nil)
                      forState:UIControlStateNormal];
    [bloodPressureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bloodPressureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    bloodPressureBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [bloodPressureBtn setImage:[UIImage imageNamed:@"omg_health_btn_bloodpressure_icon"]
                      forState:UIControlStateNormal];
    [bloodPressureBtn setImage:[UIImage imageNamed:@"omg_health_btn_bloodpressure_onclick_icon"]
                      forState:UIControlStateSelected];
    [bloodPressureBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_bloodpressure"]
                                forState:UIControlStateNormal];
    [bloodPressureBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_bloodpressure_onclick"]
                                forState:UIControlStateSelected];
    [bloodPressureBtn addTarget:self
                         action:@selector(btnDidClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bloodPressureBtn];
    [bloodPressureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view);
        make.top.equalTo(ws.view).offset(64 + 1);
        make.right.equalTo(ws.view.mas_centerX).with.offset(-0.5);
        make.height.equalTo(@kButtonHeight);
    }];

    // 血糖 - 101
    UIButton *bloodSugarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bloodSugarBtn.tag = 101;
    bloodSugarBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    bloodSugarBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    bloodSugarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [bloodSugarBtn setTitle:NSLocalizedStringFromTable(@"HealthRecord_VC_blood_sugar", APP_LAN_TABLE, nil)
                   forState:UIControlStateNormal];
    [bloodSugarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bloodSugarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    bloodSugarBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [bloodSugarBtn setImage:[UIImage imageNamed:@"omg_health_btn_glucose_icon"]
                   forState:UIControlStateNormal];
    [bloodSugarBtn setImage:[UIImage imageNamed:@"omg_health_btn_glucose_onclick_icon"]
                   forState:UIControlStateSelected];
    [bloodSugarBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_bloodpressure"]
                             forState:UIControlStateNormal];
    [bloodSugarBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_glucose_onclick"]
                             forState:UIControlStateSelected];
    [bloodSugarBtn addTarget:self
                      action:@selector(btnDidClicked:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bloodSugarBtn];
    [bloodSugarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.view);
        make.top.equalTo(ws.view).offset(64 + 1);
        make.left.equalTo(ws.view.mas_centerX).offset(0.5);
        make.height.equalTo(@kButtonHeight);
    }];

    // 心率 - 102
    UIButton *hartRateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hartRateBtn.tag = 102;
    hartRateBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    hartRateBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    hartRateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [hartRateBtn setTitle:NSLocalizedStringFromTable(@"HealthRecord_VC_heart_rate", APP_LAN_TABLE, nil)
                 forState:UIControlStateNormal];
    [hartRateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hartRateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    hartRateBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [hartRateBtn setImage:[UIImage imageNamed:@"omg_health_btn_heartbeat_icon"]
                 forState:UIControlStateNormal];
    [hartRateBtn setImage:[UIImage imageNamed:@"omg_health_btn_heartbeat_onclick_icon"]
                 forState:UIControlStateSelected];
    [hartRateBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_bloodpressure"]
                           forState:UIControlStateNormal];
    [hartRateBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_heartbeat_onclick"]
                           forState:UIControlStateSelected];
    [hartRateBtn addTarget:self
                    action:@selector(btnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hartRateBtn];
    [hartRateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bloodPressureBtn);
        make.top.equalTo(bloodPressureBtn.mas_bottom).offset(1);
        make.height.equalTo(@kButtonHeight);
    }];

    // 计步 - 103
    UIButton *pedometerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pedometerBtn.tag = 103;
    pedometerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    pedometerBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    pedometerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [pedometerBtn setTitle:NSLocalizedStringFromTable(@"HealthRecord_VC_pedometer", APP_LAN_TABLE, nil)
                 forState:UIControlStateNormal];
    [pedometerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pedometerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    pedometerBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [pedometerBtn setImage:[UIImage imageNamed:@"omg_health_btn_steps_icon"]
                 forState:UIControlStateNormal];
    [pedometerBtn setImage:[UIImage imageNamed:@"omg_health_btn_steps_onclick_icom"]
                 forState:UIControlStateSelected];
    [pedometerBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_bloodpressure"]
                           forState:UIControlStateNormal];
    [pedometerBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_steps_onclick"]
                           forState:UIControlStateSelected];
    [pedometerBtn addTarget:self
                     action:@selector(btnDidClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pedometerBtn];
    [pedometerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bloodSugarBtn);
        make.top.equalTo(bloodSugarBtn.mas_bottom).offset(1);
        make.height.equalTo(@kButtonHeight);
    }];
}

- (void)btnDidClicked:(UIButton *)sender
{
    self.bottomChangeDateButton.hidden = NO;
    self.standButton.hidden = NO;

    // 如果这个按钮已经被选中，直接返回
    if (sender.selected) return;

    // 取消选择状态
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:100 + i];
        button.selected = NO;
    }

    sender.selected = YES;

    NSString *key = nil;
    switch (sender.tag) {
        case 100:           // 血压
            key = @"bpm";
            break;
        case 101:           // 血糖
            key = @"bgm";
            break;
        case 102:           // 心率
            key = @"heartRate";
            break;
        case 103:           // 计步
            key = @"steps";
            break;
        default:
            break;
    }

    if (key == nil) return;

    WS(ws);
    [SVProgressHUD showWithStatus:kNetReqNowStr];
    [[KMNetAPI manager] getHealthInfoWithKey:key
                                       block:^(int code, NSString *res) {
                                           KMNetworkResModel *resModel = [KMNetworkResModel mj_objectWithKeyValues:res];
                                           if (code == 0 && resModel.status == kNetReqSuccess) {
                                               [SVProgressHUD dismiss];
                                               ws.healthSetModel = [KMHealthSetModel mj_objectWithKeyValues:resModel.content];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [ws createLineChartViewWithModel:ws.healthSetModel];
                                               });
                                           } else {
                                               [SVProgressHUD showErrorWithStatus:resModel.msg ? resModel.msg : kNetReqFailStr];
                                           }
                                       }];
}

#pragma mark - 画图
- (void)createLineChartViewWithModel:(KMHealthSetModel *)model
{
    WS(ws);

    // 如果之前有显示，先删除
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }

    self.scrollView = [UIScrollView new];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(64 + kButtonHeight*2 + 3 + 3*kEdgeOffset,
                                                                 kEdgeOffset,
                                                                 kButtonHeight + kEdgeOffset,
                                                                 kEdgeOffset));
    }];

    UIView *container = [UIView new];
    [self.scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.scrollView);
        make.width.equalTo(ws.scrollView);
    }];

    // 存储数据数组
    NSArray *dataArray = nil;
    // 存储线的颜色
    NSArray *colorArray = nil;
    // 存储日期 - x坐标使用
    NSMutableArray *dateStringArray = [NSMutableArray array];
    // 存储标题
    NSArray *titleArray = nil;

    if (model.bpm) {        // 血压
        // 先转换日期
        for (KMBpmModel *bpmModel in model.bpm) {
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
            NSDate *date = [inputFormatter dateFromString:bpmModel.date];
            bpmModel.convertDate = date;
        }

        // 按日期排序
        NSArray *newModel = [model.bpm sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            KMBpmModel *model1 = obj1;
            KMBpmModel *model2 = obj2;
            if (model1.convertDate.timeIntervalSince1970 > model2.convertDate.timeIntervalSince1970) {
                return NSOrderedAscending;
            }

            if (model1.convertDate.timeIntervalSince1970 < model2.convertDate.timeIntervalSince1970) {
                return NSOrderedDescending;
            }

            return NSOrderedSame;
        }];

        NSMutableArray *sbpArray = [NSMutableArray array];          // 低压数组
        NSMutableArray *dbpArray = [NSMutableArray array];          // 高压数组
        NSMutableArray *pluseArray = [NSMutableArray array];        // 脉搏数组
        for (int i = 0; i < newModel.count; i++) {
            KMBpmModel *bpmModel = newModel[i];
            [sbpArray addObject:@(bpmModel.sbp)];
            [dbpArray addObject:@(bpmModel.dbp)];
            [pluseArray addObject:@(bpmModel.pluse)];

            // 转换日期给x轴坐标使用
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"MM-dd"];
            NSString *dateString = [inputFormatter stringFromDate:bpmModel.convertDate];
            [dateStringArray addObject:dateString];
        }

        dataArray = @[dbpArray, sbpArray, pluseArray];
        colorArray = @[RGB(97, 167, 188), RGB(163, 193, 72), RGB(183, 117, 188)];
        titleArray = @[kLoadStringWithKey(@"HealthRecord_VC_dbp_title"),
                       kLoadStringWithKey(@"HealthRecord_VC_sbp_title"),
                       kLoadStringWithKey(@"HealthRecord_VC_pluse_title")];
        
        // 设置底部标签
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yy-MM-dd"];
        KMBpmModel *firstModel = [newModel firstObject];
        NSString *lastCheckDate = [inputFormatter stringFromDate:firstModel.convertDate];
        self.inforLabel.text = [NSString stringWithFormat:@"%@: %@\n%@(mmHg): %@\n%@(mmHg): %@\n%@: %@",
                                kLoadStringWithKey(@"HealthRecord_VC_last_checktime"),
                                lastCheckDate,
                                kLoadStringWithKey(@"HealthRecord_VC_dbp_title"),
                                @(firstModel.dbp),
                                kLoadStringWithKey(@"HealthRecord_VC_sbp_title"),
                                @(firstModel.sbp),
                                kLoadStringWithKey(@"HealthRecord_VC_pluse_title"),
                                @(firstModel.pluse)];
        
    } else if (model.bgm) {     // 血糖
        // 先转换日期
        for (KMBgmModel *bpmModel in model.bgm) {
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
            NSDate *date = [inputFormatter dateFromString:bpmModel.date];
            bpmModel.convertDate = date;
        }

        // 按日期排序
        NSArray *newModel = [model.bgm sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            KMBgmModel *model1 = obj1;
            KMBgmModel *model2 = obj2;
            if (model1.convertDate.timeIntervalSince1970 > model2.convertDate.timeIntervalSince1970) {
                return NSOrderedAscending;
            }

            if (model1.convertDate.timeIntervalSince1970 < model2.convertDate.timeIntervalSince1970) {
                return NSOrderedDescending;
            }

            return NSOrderedSame;
        }];

        NSMutableArray *glucoseArray = [NSMutableArray array];          // 全血血糖数组
        NSMutableArray *plasmaArray = [NSMutableArray array];           // 血浆血糖数组
        for (int i = 0; i < newModel.count; i++) {
            KMBgmModel *bgmModel = newModel[i];
            [glucoseArray addObject:@(bgmModel.glucose)];
            [plasmaArray addObject:@(bgmModel.plasma)];

            // 转换日期给x轴坐标使用
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"MM-dd"];
            NSString *dateString = [inputFormatter stringFromDate:bgmModel.convertDate];
            [dateStringArray addObject:dateString];
        }

        dataArray = @[glucoseArray, plasmaArray];
        colorArray = @[RGB(97, 167, 188), RGB(163, 193, 72)];
        titleArray = @[kLoadStringWithKey(@"HealthRecord_VC_glucose_title"),
                       kLoadStringWithKey(@"HealthRecord_VC_plasma_title")];
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yy-MM-dd"];
        KMBgmModel *firstModel = [newModel firstObject];
        NSString *lastCheckDate = [inputFormatter stringFromDate:firstModel.convertDate];
        self.inforLabel.text = [NSString stringWithFormat:@"%@: %@\n%@(mg/dl): %@\n%@(mg/dl): %@",
                                kLoadStringWithKey(@"HealthRecord_VC_last_checktime"),
                                lastCheckDate,
                                kLoadStringWithKey(@"HealthRecord_VC_glucose_title"),
                                @(firstModel.glucose),
                                kLoadStringWithKey(@"HealthRecord_VC_plasma_title"),
                                @(firstModel.plasma)];
    } else if (model.hrate) {       // 心率
        // 先转换日期
        for (KMHrateModel *hrateModel in model.hrate) {
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
            NSDate *date = [inputFormatter dateFromString:hrateModel.end];
            hrateModel.convertDate = date;
        }

        // 按日期排序
        NSArray *newModel = [model.hrate sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            KMHrateModel *model1 = obj1;
            KMHrateModel *model2 = obj2;
            if (model1.convertDate.timeIntervalSince1970 > model2.convertDate.timeIntervalSince1970) {
                return NSOrderedAscending;
            }
            
            if (model1.convertDate.timeIntervalSince1970 < model2.convertDate.timeIntervalSince1970) {
                return NSOrderedDescending;
            }
            
            return NSOrderedSame;
        }];
        
        NSMutableArray *array1 = [NSMutableArray array];        // 数据组
        NSMutableArray *array3 = [NSMutableArray array];        // 颜色
        for (KMHrateModel *hrateModel in newModel) {
            // 数据
            [array1 addObject:@(hrateModel.avg)];

            //
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"MM-dd"];
            NSString *dateString = [inputFormatter stringFromDate:hrateModel.convertDate];
            [dateStringArray addObject:dateString];

            // 绿色
            [array3 addObject:PNGreen];
        }

        dataArray = array1;
        colorArray = array3;
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yy-MM-dd"];
        KMHrateModel *firstModel = [newModel firstObject];
        NSString *lastCheckDate = [inputFormatter stringFromDate:firstModel.convertDate];
        self.inforLabel.text = [NSString stringWithFormat:@"%@: %@\n%@: %@ / min",
                                kLoadStringWithKey(@"HealthRecord_VC_last_checktime"),
                                lastCheckDate,
                                kLoadStringWithKey(@"HealthRecord_VC_heart_rate"),
                                @(firstModel.avg)];
    } else if (model.steps) {       // 计步
        // 先转换日期
        for (KMStepsModel *stepsModel in model.steps) {
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
            NSDate *date = [inputFormatter dateFromString:stepsModel.end];
            stepsModel.convertDate = date;
        }

        // 按日期排序
        NSArray *newModel = [model.steps sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            KMStepsModel *model1 = obj1;
            KMStepsModel *model2 = obj2;
            if (model1.convertDate.timeIntervalSince1970 > model2.convertDate.timeIntervalSince1970) {
                return NSOrderedAscending;
            }
            
            if (model1.convertDate.timeIntervalSince1970 < model2.convertDate.timeIntervalSince1970) {
                return NSOrderedDescending;
            }
            
            return NSOrderedSame;
        }];
        
        NSMutableArray *array1 = [NSMutableArray array];        // 数据组
        NSMutableArray *array3 = [NSMutableArray array];        // 颜色
        for (KMStepsModel *stepsModel in newModel) {
            // 数据
            [array1 addObject:@(stepsModel.steps)];
            
            //
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"MM-dd"];
            NSString *dateString = [inputFormatter stringFromDate:stepsModel.convertDate];
            [dateStringArray addObject:dateString];
            
            // 绿色
            [array3 addObject:PNGreen];
        }
        
        dataArray = array1;
        colorArray = array3;
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yy-MM-dd"];
        KMStepsModel *firstModel = [newModel firstObject];
        NSString *lastCheckDate = [inputFormatter stringFromDate:firstModel.convertDate];
        self.inforLabel.text = [NSString stringWithFormat:@"%@: %@\n%@: %@\n%@: %@ kcal\n%@: %@ km",
                                kLoadStringWithKey(@"HealthRecord_VC_last_checktime"),
                                lastCheckDate,
                                kLoadStringWithKey(@"HealthRecord_VC_pedometer_numbers"),
                                @(firstModel.steps),
                                kLoadStringWithKey(@"HealthRecord_VC_pedometer_cal"),
                                @(firstModel.cal),
                                kLoadStringWithKey(@"HealthRecord_VC_pedometer_dis"),
                                @(firstModel.dis)];
    } else {
        DMLog(@"model error: %@", model);
        return;
    }

    // 血压和血糖使用线条图表
    if (model.bgm || model.bpm) {
        // For Line Chart
        PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2*kEdgeOffset, kLineChartHeight)];
        lineChart.showCoordinateAxis = YES;
        lineChart.legendStyle = PNLegendItemStyleSerial;
        lineChart.legendFont = [UIFont systemFontOfSize:14];
        [lineChart setXLabels:dateStringArray];
        
        // save PNLineChartData
        NSMutableArray *realArray = [NSMutableArray array];
        for (int i = 0; i < dataArray.count; i++) {
            NSArray *array = dataArray[i];
            PNLineChartData *data = [PNLineChartData new];
            data.dataTitle = titleArray[i];
            data.inflexionPointStyle = PNLineChartPointStyleCircle;
            data.color = colorArray[i];
            data.itemCount = array.count;
            data.getData = ^(NSUInteger index) {
                CGFloat yValue = [array[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            
            [realArray addObject:data];
        }
        
        lineChart.chartData = realArray;
        [lineChart strokeChart];
        
        [container addSubview:lineChart];
        
        // 显示在图表下的说明文字
        UIView *titleView = [lineChart getLegendWithMaxWidth:SCREEN_WIDTH - 2*kEdgeOffset];
        titleView.center = CGPointMake((SCREEN_WIDTH - 2*kEdgeOffset)/2.0, kLineChartHeight + titleView.frame.size.height/2.0);
        [container addSubview:titleView];
        
        //
        [self.inforLabel removeFromSuperview];
        [container addSubview:self.inforLabel];
        [self.inforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(container);
            make.top.equalTo(titleView.mas_bottom).offset(25);
        }];
        
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.inforLabel.mas_bottom);
        }];
    } else if (model.hrate || model.steps) {        // 心率和计步使用柱状图
        PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2*kEdgeOffset, kLineChartHeight)];
        barChart.backgroundColor = [UIColor clearColor];
        barChart.yLabelFormatter = ^(CGFloat yValue){
            return [NSString stringWithFormat:@"%d", (int)yValue];
        };

        barChart.yChartLabelWidth = 20.0;
        barChart.chartMarginLeft = 30.0;
        barChart.chartMarginRight = 10.0;
        barChart.chartMarginTop = 5.0;
        barChart.chartMarginBottom = 10.0;

        barChart.labelMarginTop = 5.0;
        barChart.showChartBorder = YES;
        [barChart setXLabels:dateStringArray];
        [barChart setYValues:dataArray];
        [barChart setStrokeColors:colorArray];
        barChart.isGradientShow = NO;
        barChart.isShowNumbers = NO;

        [barChart strokeChart];

        barChart.delegate = self;
        [container addSubview:barChart];
        
        [self.inforLabel removeFromSuperview];
        [container addSubview:self.inforLabel];
        [self.inforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(container);
            make.top.equalTo(barChart.mas_bottom).offset(25);
        }];
        
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.inforLabel.mas_bottom);
        }];
    }
    
    // 将标准值按钮放到最前面
    [self.view bringSubviewToFront:self.standButton];
}

#pragma mark - PNChartDelegate
- (void)userClickedOnBar:(PNBar *)bar Index:(NSInteger)barIndex
{
    NSLog(@"Click on bar %@", @(barIndex));
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [bar.layer addAnimation:animation forKey:@"Float"];
}

- (void)changeMeasureDate
{
    KMChangeDateVC *vc = [[KMChangeDateVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end

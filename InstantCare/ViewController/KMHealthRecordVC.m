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

#define kButtonHeight       50
#define kEdgeOffset         10

@interface KMHealthRecordVC()

@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  健康数据模型
 */
@property (nonatomic, strong) KMHealthSetModel *healthSetModel;

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
    // 数据模型初始化
    [KMHealthSetModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"bpm" : @"KMBpmModel",
                 @"bgm" : @"KMBgmModel",
                 @"steps" : @"KMStepsModel"
                 };
    }];

    // 灰色背景，显示出细线
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
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
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64 + 1);
        make.right.equalTo(self.view.mas_centerX).with.offset(-0.5);
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
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64 + 1);
        make.left.equalTo(self.view.mas_centerX).offset(0.5);
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
    
    [self createLineChartViewWithHeight:1 model:nil];
}

- (void)btnDidClicked:(UIButton *)sender
{
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
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(64 + kButtonHeight*2 + 3 + kEdgeOffset,
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
    
    NSArray *dataArray = nil;
    if (model.bpm) {        // 血压
        NSMutableArray *sbpArray = [NSMutableArray array];      // 低压数组
        NSMutableArray *dbpArray = [NSMutableArray array];      // 高压数组
        NSMutableArray *pluseArray = [NSMutableArray array];    // 脉搏数组
        for (int i = 0; i < model.bpm.count; i++) {
            KMBpmModel *bpmModel = model.bpm[i];
            [sbpArray addObject:@(bpmModel.sbp)];
            [dbpArray addObject:@(bpmModel.dbp)];
            [pluseArray addObject:@(bpmModel.pluse)];
            
            // 转日期
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
            NSDate *date = [inputFormatter dateFromString:bpmModel.date];
        }
        
        dataArray = @[sbpArray, dbpArray, pluseArray];
    }

    //For Line Chart
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2*kEdgeOffset, 200.0)];
    lineChart.showCoordinateAxis = YES;
    [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5", @"SEP 5", @"SEP 5"]];

    // Line Chart No.1
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @200, @300];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // Line Chart No.2
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @120, @250];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };

    lineChart.chartData = @[data01, data02];
    [lineChart strokeChart];
    
    [container addSubview:lineChart];

    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineChart.mas_bottom);
    }];
}



@end

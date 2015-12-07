//
//  KMDeviceSettingDetailVC.m
//  InstantCare
//
//  Created by 朱正晶 on 15/12/6.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMDeviceSettingDetailVC.h"

@interface KMDeviceSettingDetailVC() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray1;
@property (nonatomic, strong) NSArray *dataArray2;

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-button"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBarButtonDidClicked:)];
    
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
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
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
            return 5;
        case 1:
            return 2;
        default:
            break;
    }

    return 0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Hello";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"cell"];

        }
        
        cell.textLabel.text = self.dataArray1[indexPath.row];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"cell2"];
        }
        
        cell.textLabel.text = self.dataArray2[indexPath.row];
    }

    return cell;
}

@end

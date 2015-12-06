//
//  KMAccountEditVC.m
//  InstantCare
//
//  Created by 朱正晶 on 15/12/6.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMAccountEditVC.h"

@implementation KMAccountEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNarBar];
}

- (void)configNarBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-button"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBarButtonDidClicked:)];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"AccountEdit_VC_title", APP_LAN_TABLE, nil);
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

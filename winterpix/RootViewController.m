//
//  ViewController.m
//  winterpix
//
//  Created by SSC on 2014/04/10.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setHidden:YES];
    HomeViewController* controller = [[HomeViewController alloc] init];
    [self pushViewController:controller animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

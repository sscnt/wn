//
//  HomeViewController.m
//  winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //// Background Image
    UIImage* imageBg;
    if ([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4) {
        imageBg = [UIImage imageNamed:@"bg.png"];
    }else if([UIDevice resolution] == UIDeviceResolution_iPhoneRetina5){
        imageBg = [UIImage imageNamed:@"bg-568h.png"];
    }
    _bgView = [[UIHomeBgView alloc] initWithFrame:self.view.bounds];
    _bgView.bgImage = imageBg;
    [self.view addSubview:_bgView];
    
    //// Splash Image
    if ([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4) {
        imageBg = [UIImage imageNamed:@"Default.png"];
    }else if([UIDevice resolution] == UIDeviceResolution_iPhoneRetina5){
        imageBg = [UIImage imageNamed:@"Default-568h.png"];
    }
    _splashView = [[UIHomeBgView alloc] initWithFrame:self.view.bounds];
    _splashView.bgImage = imageBg;
    [self.view addSubview:_splashView];
    
    //// Animate
    __block UIHomeBgView* _s = _splashView;
    [UIView animateWithDuration:0.30f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        _s.alpha = 0.0f;
    } completion:^(BOOL finished){
        [_s removeFromSuperview];
        _s = nil;
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

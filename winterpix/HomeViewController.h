//
//  HomeViewController.h
//  winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeBgView.h"
#import "UIHomeSourceButton.h"

@interface HomeViewController : UIViewController
{
    UIHomeBgView* _bgView;
    UIHomeBgView* _splashView;
    UIHomeSourceButton* _photosButton;
    UIHomeSourceButton* _cameraButton;
}

@end

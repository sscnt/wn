//
//  UIHomeBgView.h
//  winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIHomeBgViewBgType){
    UIHomeBgViewBgTypeSplash = 1,
    UIHomeBgViewBgTypeBg
};


@interface UIHomeBgView : UIView

@property (nonatomic, assign) UIHomeBgViewBgType type;

@end

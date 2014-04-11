//
//  UIHomeSourceButton.h
//  Winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIHomeSourceButtonIconType){
    UIHomeSourceButtonIconTypePhotos = 1,
    UIHomeSourceButtonIconTypeCamera
};

@interface UIHomeSourceButton : UIButton

@property (nonatomic, assign) UIHomeSourceButtonIconType iconType;

@end

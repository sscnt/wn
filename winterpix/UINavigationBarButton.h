//
//  UINavigationBarButton.h
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarButtonType){
    NavigationBarButtonTypeOpacity = 1,
    NavigationBarButtonTypeSnowfall
};

@interface UINavigationBarButton : UIButton
{
    UIImageView* _iconImageView;
}

@property (nonatomic, assign) NavigationBarButtonType type;
@property (nonatomic, assign) BOOL selected;

- (id)initWithType:(NavigationBarButtonType)type;
- (void)setIcon;

@end

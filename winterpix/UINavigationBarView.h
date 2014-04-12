//
//  UISelectionNavigationBar.h
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBarButton.h"

typedef NS_ENUM(NSInteger, NavigationBarViewPosition){
    NavigationBarViewPositionTop = 1,
    NavigationBarViewPositionBottom
};

@interface UINavigationBarView : UIView
{
    CGFloat _leftButtonPositionLeft;
    CGFloat _rightButtonPositionLeft;
    UILabel* _titleLabel;
}

@property (nonatomic, assign) NavigationBarViewPosition position;
@property (nonatomic, assign) CGFloat buttonWidth;

- (id)initWithPosition:(NavigationBarViewPosition)position;
- (void)appendButtonToLeft:(UIButton*)button;
- (void)appendButtonToRight:(UIButton*)button;
- (void)setTitle:(NSString*)title;
- (void)setOpacity:(CGFloat)opacity;

@end

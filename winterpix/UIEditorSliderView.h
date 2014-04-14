//
//  UIEditorSliderView.h
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISliderView.h"

@class UIEditorSliderView;

@protocol UIEditorSliderViewDelegate
- (void)slider:(UIEditorSliderView*)slider DidValueChange:(CGFloat)value;
- (void)sliderDidValueResetToDefault:(UIEditorSliderView*)slider;
- (BOOL)sliderShouldValueResetToDefault:(UIEditorSliderView*)slider;
- (void)touchesBeganWithSlider:(UIEditorSliderView*)slider;
- (void)touchesEndedWithSlider:(UIEditorSliderView*)slider;
@end

typedef NS_ENUM(NSInteger, EditorSliderIconType){
    EditorSliderIconTypeOpacity = 1,
    EditorSliderIconTypeTemp,
    EditorSliderIconTypeBrightness,
    EditorSliderIconTypeSnowfall,
    EditorSliderIconTypeSnowDirection
};

@interface UIEditorSliderView : UIView <UISliderViewDelegate>
{
    UISliderView* _slider;
    UIImageView* _iconImageView;
    UIButton* _iconButton;
}

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat defaultValue;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, weak) id<UIEditorSliderViewDelegate> delegate;
@property (nonatomic, assign) EditorSliderIconType iconType;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) SliderViewTitlePosition titlePosition;
@property (nonatomic, assign) BOOL locked;

- (void)resetToDefault;
- (void)resetToDefaultPosition;

@end

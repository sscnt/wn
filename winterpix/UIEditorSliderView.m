//
//  UIEditorSliderView.m
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UIEditorSliderView.h"

@implementation UIEditorSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

        //// Slider
        CGFloat sliderWidth = frame.size.width - 38.0f;
        _slider = [[UISliderView alloc] initWithFrame:CGRectMake(36.0f, 0.0f, sliderWidth, 42.0f)];
        _slider.center = CGPointMake(_slider.center.x, self.bounds.size.height / 2.0f);
        _slider.delegate = self;
        [self addSubview:_slider];
        
        self.backgroundColor = [UIColor clearColor];        
        self.alpha = 0.70f;
        self.defaultValue = 0.0f;
    }
    return self;
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    _slider.locked = locked;
}

- (CGFloat)value
{
    return _slider.value;
}

- (void)setValue:(CGFloat)value
{
    _slider.value = value;
}

- (void)setDefaultValue:(CGFloat)defaultValue
{
    _defaultValue = defaultValue;
    self.value = defaultValue;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _slider.title = title;
}

- (void)resetToDefault
{
    if(_locked){
        return;
    }
    if ([self.delegate sliderShouldValueResetToDefault:self]) {
        [self resetToDefaultPosition];
        [self.delegate sliderDidValueResetToDefault:self];        
    }
}

- (void)resetToDefaultPosition
{
    _slider.value = self.defaultValue;
}

- (void)setIconType:(EditorSliderIconType)iconType
{
    _iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    [_iconButton addTarget:self action:@selector(resetToDefault) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat marginTop = 0.0f;
    CGFloat marginLeft = 0.0f;
    switch (iconType) {
        case EditorSliderIconTypeOpacity:
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"opacity-60.png"]];
            break;
        case EditorSliderIconTypeSnowfall:
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"snowfall-60.png"]];
            break;
        case EditorSliderIconTypeTemp:
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kelvin-60.png"]];
            break;
        case EditorSliderIconTypeSnowDirection:
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"direction-60.png"]];
            break;
        case EditorSliderIconTypeBrightness:
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levels-60.png"]];
            break;

    }
    _iconButton.center = CGPointMake(23.0f + marginLeft, self.bounds.size.height / 2.0f + marginTop);
    _iconImageView.center = CGPointMake(_iconButton.bounds.size.width / 2.0f, _iconButton.bounds.size.height / 2.0f);
    _iconImageView.alpha = _alpha;
    [_iconButton addSubview:_iconImageView];
    [self addSubview:_iconButton];
}

#pragma mark delegate

- (void)slider:(UISliderView*)slider DidValueChange:(CGFloat)value
{
    [self.delegate slider:self DidValueChange:value];
}

- (void)touchesBeganWithSlider:(UISliderView *)slider
{
    self.alpha = 1.0f;
    [self.delegate touchesBeganWithSlider:self];
}

- (void)touchesEndedWithSlider:(UISliderView *)slider
{
    self.alpha = 0.70f;
    [self.delegate touchesEndedWithSlider:self];
}

- (void)touchesMovedWithSlider:(UISliderView *)slider
{

}

- (void)setTitlePosition:(SliderViewTitlePosition)titlePosition
{
    _slider.titlePosition = titlePosition;
}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    if(_slider){
        _slider.alpha = alpha;
    }
    if (_iconImageView) {
        _iconImageView.alpha = alpha;
    }
}

@end

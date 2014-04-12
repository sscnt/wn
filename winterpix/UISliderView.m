//
//  UISliderVIew.m
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UISliderView.h"

@implementation UISliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _paddingHorizontal = 15.0f;
        _paddingVertical = 10.0f;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        _titleLabel.alpha = 0.9f;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        NSArray *langs = [NSLocale preferredLanguages];
        NSString *currentLanguage = [langs objectAtIndex:0];
        if([currentLanguage compare:@"ja"] == NSOrderedSame) {
            _titleLabel.font = [UIFont fontWithName:@"mplus-1c-bold" size:15.0f];
        } else {
            _titleLabel.font = [UIFont fontWithName:@"Aller-Bold" size:16.0f];
        }
        [self addSubview:_titleLabel];
        
        CGFloat radius = floorf((frame.size.height - 2.0f - _paddingVertical * 2.0f) / 2.0f);
        _thumbView = [[UISliderThumbVIew alloc] initWithRadius:radius];
        _thumbView.center = CGPointMake(frame.size.width / 2.0f, frame.size.height / 2.0f - 1.0f);
        UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragThumb:)];
        recognizer.maximumNumberOfTouches = 1;
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        [self addSubview:_thumbView];
        [self bringSubviewToFront:_thumbView];
        
        _thumbStartX = radius + 1.0f + _paddingHorizontal;
        _thumbEndX = frame.size.width - radius - 1.0f - _paddingHorizontal;
        self.value = 1.0f;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
}

- (CGFloat)value
{
    return _value;
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    CGFloat x = [self calcPoxitionByValue:value];
    _thumbView.center = CGPointMake(x, _thumbView.center.y);
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    _thumbView.locked = locked;
}

- (CGFloat)calcPoxitionByValue:(CGFloat)value
{
    return (_thumbEndX - _thumbStartX) * value + _thumbStartX;
}

- (CGFloat)calcValueByThumbPosition:(CGFloat)x
{
    CGFloat value = (x - _thumbStartX) / (_thumbEndX - _thumbStartX);
    return MAX(MIN(value, 1.0), 0.0f);
}

- (void)didDragThumb:(UIPanGestureRecognizer *)sender
{
    if(_locked){
        return;
    }
    UISliderThumbVIew* thumbView = _thumbView;
    CGPoint transitionPoint = [sender translationInView:thumbView];
    
    CGFloat x = thumbView.center.x + transitionPoint.x;
    if (x > _thumbEndX) {
        x = _thumbEndX;
    }else if (x < _thumbStartX){
        x = _thumbStartX;
    }
    
    CGPoint movedPoint = CGPointMake(x, thumbView.center.y);
    thumbView.center = movedPoint;
    
    _value = [self calcValueByThumbPosition:x];
    [self.delegate slider:self DidValueChange:_value];
    
    [sender setTranslation:CGPointZero inView:thumbView];
    
    switch (sender.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            [self.delegate touchesBeganWithSlider:self];
            break;
        case UIGestureRecognizerStateChanged:
            [self.delegate touchesMovedWithSlider:self];
            break;
        case UIGestureRecognizerStateEnded:
            [self.delegate touchesEndedWithSlider:self];
            break;
        case UIGestureRecognizerStateCancelled:
            [self.delegate touchesEndedWithSlider:self];
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)setTitlePosition:(SliderViewTitlePosition)titlePosition
{
    _titlePosition = titlePosition;
    switch (titlePosition) {
        case SliderViewTitlePositionCenter:
            _titleLabel.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
            break;
        case SliderViewTitlePositionLeft:
            _titleLabel.center = CGPointMake(10.0f + _titleLabel.bounds.size.width / 2.0f + _paddingHorizontal, self.bounds.size.height / 2.0f);
            break;
        case SliderViewTitlePositionRight:
            _titleLabel.center = CGPointMake(self.bounds.size.width - 10.0f - _titleLabel.bounds.size.width / 2.0f - _paddingHorizontal, self.bounds.size.height / 2.0f);
            break;
        default:
            _titleLabel.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
            break;
    }
    NSArray *langs = [NSLocale preferredLanguages];
    NSString *currentLanguage = [langs objectAtIndex:0];
    if([currentLanguage compare:@"ja"] == NSOrderedSame) {
        if([UIDevice isIOS6]){
            _titleLabel.center = CGPointMake(_titleLabel.center.x, _titleLabel.center.y + 1.0f);
        }
    } else {
    }

}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    _titleLabel.alpha = _alpha;
    [self setNeedsDisplay];
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: _alpha];
    UIColor* bgColor = [UIColor colorWithWhite:26.0f/255.0f alpha:0.60f];
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1.0f + _paddingHorizontal, 1.0f + _paddingVertical, rect.size.width - 2.0f - _paddingHorizontal * 2.0f, rect.size.height - 2.0f - _paddingVertical * 2.0) cornerRadius: rect.size.height];
    [strokeColor setStroke];
    [bgColor setFill];
    [roundedRectanglePath fill];
    roundedRectanglePath.lineWidth = 2;
    [roundedRectanglePath stroke];
}

@end

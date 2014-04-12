//
//  UISaveToVIew.m
//  Vintage
//
//  Created by SSC on 2014/03/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UISaveDialogView.h"
#import "UISaveToButton.h"

@implementation UISaveDialogView

- (id)init
{
    CGFloat buttonHeight = 50.0f;
    CGRect frame = CGRectMake(20.0f, 0.0f, [UIScreen screenSize].width - 40.0f, buttonHeight * 3.0f + 2.0f);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.70f];
        
        //// Camera roll
        _buttonCameraRoll = [[UISaveToButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, buttonHeight)];
        _buttonCameraRoll.saveTo = SaveToCameraRoll;
        [_buttonCameraRoll addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonCameraRoll setTitle:NSLocalizedString(@"CAMERA ROLL", Nil) forState:UIControlStateNormal];
        [self addSubview:_buttonCameraRoll];
        
        //// Twitter
        _buttonTwitter = [[UISaveToButton alloc] initWithFrame:CGRectMake(0.0f, [_buttonCameraRoll bottom] + 1.0f, frame.size.width, buttonHeight)];
        _buttonTwitter.saveTo = SaveToTwitter;
        [_buttonTwitter addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonTwitter setTitle:NSLocalizedString(@"TWITTER", Nil) forState:UIControlStateNormal];
        [self addSubview:_buttonTwitter];
        
        //// Instagram
        _buttonInstagram = [[UISaveToButton alloc] initWithFrame:CGRectMake(0.0f, [_buttonTwitter bottom] + 1.0f, frame.size.width, buttonHeight)];
        _buttonInstagram.saveTo = SaveToInstagram;
        [_buttonInstagram addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonInstagram setTitle:NSLocalizedString(@"INSTAGRAM", Nil) forState:UIControlStateNormal];
        [self addSubview:_buttonInstagram];
        
    }
    return self;
}

- (void)didPressButton:(UISaveToButton *)button
{
    _buttonCameraRoll.selected = NO;
    
    button.selected = YES;
    [self.delegate saveToView:self DidSelectSaveTo:button.saveTo];
}

- (void)clearSelected
{
    _buttonCameraRoll.selected = NO;
}

@end

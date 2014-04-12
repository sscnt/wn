//
//  EditorViewController.m
//  Winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "EditorViewController.h"

@interface EditorViewController ()

@end

@implementation EditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //// Layout
    [self.view setBackgroundColor:[UIColor colorWithWhite:26.0f/255.0f alpha:1.0]];
    
    
    //// Preview
    CGSize originalImageSize = [CurrentImage originalImageSize];
    CGFloat width = [UIScreen screenSize].width;
    CGFloat height = originalImageSize.height * width / originalImageSize.width;
    CGFloat max_height = [UIScreen screenSize].height - 254.0f;
    if (height > max_height) {
        width *= max_height / height;
        height = max_height;
    }
    _previewImageView = [[UIEditorPreviewImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    if([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4){
        _previewImageView.center = CGPointMake([UIScreen screenSize].width / 2.0f, [UIScreen screenSize].height / 2.0f - MAX(([UIScreen screenSize].height - 128.0f - height) / 2.0f, 0.0f));
    }else{
        _previewImageView.center = CGPointMake([UIScreen screenSize].width / 2.0f, [UIScreen screenSize].height / 2.0f - MIN(MAX(([UIScreen screenSize].height - height - 118.0f) / 2.0f, 0.0f), 83.0f));
    }
    [self.view addSubview:_previewImageView];

    
    //// Bottom Bar
    _bottomNavigationBar = [[UINavigationBarView alloc] initWithPosition:NavigationBarViewPositionBottom];
    [_bottomNavigationBar setOpacity:1.0f];
    
    //////// Save
    UISaveButton* buttonSave = [[UISaveButton alloc] init];
    [buttonSave addTarget:self action:@selector(didPressSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [_bottomNavigationBar appendButtonToRight:buttonSave];
    [self.view addSubview:_bottomNavigationBar];
    
    //////// Opacity
    _buttonOpacity = [[UINavigationBarButton alloc] initWithType:NavigationBarButtonTypeOpacity];
    _buttonOpacity.selected = YES;
    _buttonOpacity.tag = AdjustmentViewIdOpacity;
    [_buttonOpacity addTarget:self action:@selector(didPressAdjustmentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomNavigationBar appendButtonToLeft:_buttonOpacity];
    
    //////// Snowfall
    _buttonSnowfall = [[UINavigationBarButton alloc] initWithType:NavigationBarButtonTypeBrightness];
    _buttonSnowfall.tag = AdjustmentViewIdSnowfall;
    [_buttonSnowfall addTarget:self action:@selector(didPressAdjustmentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomNavigationBar appendButtonToLeft:_buttonSnowfall];
    
    //// Top Bar
    _topNavigationBar = [[UINavigationBarView alloc] initWithPosition:NavigationBarViewPositionTop];
    [_topNavigationBar setTitle:NSLocalizedString(@"EDIT", nil)];
    UICloseButton* buttonClose = [[UICloseButton alloc] init];
    [buttonClose addTarget:self action:@selector(didPressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [_topNavigationBar appendButtonToLeft:buttonClose];
    [self.view addSubview:_topNavigationBar];
    
    //// Label
    _percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen screenSize].width, 44.0f)];
    _percentageLabel.center = _previewImageView.center;
    if([UIDevice isCurrentLanguageJapanese]) {
        _percentageLabel.font = [UIFont fontWithName:@"mplus-1c-bold" size:20.0f];
    } else {
        _percentageLabel.font = [UIFont fontWithName:@"SheepSansBold" size:20.0f];
    }
    _percentageLabel.textAlignment = NSTextAlignmentCenter;
    _percentageLabel.backgroundColor = [UIColor clearColor];
    _percentageLabel.textColor = [UIColor whiteColor];
    _percentageLabel.numberOfLines = 0;
    _percentageLabel.shadowColor = [UIColor blackColor];
    _percentageLabel.shadowOffset = CGSizeMake(1, 1);
    _percentageLabel.hidden = YES;
    [self.view addSubview:_percentageLabel];
    
}

#pragma mark ready

- (void)didFinishResizing
{
    
}

- (void)test
{
    UIImage* image = [CurrentImage originalImage];
    
    
    @autoreleasepool {
        GPUEffectColdWinter* effect = [[GPUEffectColdWinter alloc] init];
        effect.imageToProcess = image;
        image = [effect process];
    }
    
    @autoreleasepool {
        GPUEffectAutumnToWinter* effect = [[GPUEffectAutumnToWinter alloc] init];
        effect.imageToProcess = image;
        image = [effect process];
        
    }
    
    UIImageView* view = [[UIImageView alloc] initWithImage:image];
    view.frame = CGRectMake(0.0f, 0.0f, [UIScreen width], [UIScreen width] / image.size.width * image.size.height);
    [self.view addSubview:view];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

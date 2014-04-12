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
    CGFloat width = [CurrentImage editorImageSize].width / [[UIScreen mainScreen] scale];
    CGFloat height = [CurrentImage editorImageSize].height / [[UIScreen mainScreen] scale];
    _previewImageView = [[UIEditorPreviewImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    if([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4){
        _previewImageView.center = CGPointMake([UIScreen screenSize].width / 2.0f, [UIScreen screenSize].height / 2.0f - MAX(([UIScreen screenSize].height - 128.0f - height) / 2.0f, 0.0f));
    }else{
        _previewImageView.center = CGPointMake([UIScreen screenSize].width / 2.0f, [UIScreen screenSize].height / 2.0f - MIN(MAX(([UIScreen screenSize].height - height - 118.0f) / 2.0f, 0.0f), 83.0f));
    }
    [self.view addSubview:_previewImageView];
    
    //// Sliders
    //////// Opacity
    _sliderOpacity = [[UIEditorSliderView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, [UIScreen screenSize].width, 42.0f)];
    _sliderOpacity.tag = EditorSliderIconTypeOpacity;
    _sliderOpacity.delegate = self;
    _sliderOpacity.title = NSLocalizedString(@"Opacity", nil);
    _sliderOpacity.iconType = EditorSliderIconTypeOpacity;
    _sliderOpacity.titlePosition = SliderViewTitlePositionCenter;
    _sliderOpacity.defaultValue = 1.0f;
    _sliderOpacity.value = [Processor instance].opacity;
    //////// Haze
    _sliderTemp = [[UIEditorSliderView alloc] initWithFrame:CGRectMake(0.0f, 10.0f + _sliderOpacity.frame.size.height, [UIScreen screenSize].width, 42.0f)];
    _sliderTemp.tag = EditorSliderIconTypeTemp;
    _sliderTemp.delegate = self;
    _sliderTemp.title = NSLocalizedString(@"Temperature", nil);
    _sliderTemp.iconType = EditorSliderIconTypeTemp;
    _sliderTemp.titlePosition = SliderViewTitlePositionCenter;
    _sliderTemp.defaultValue = 0.0f;
    _sliderTemp.value = [Processor instance].temp;
    //////// Adjustment
    _adjustmentOpacity = [[UISliderContainer alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen screenSize].width, _sliderOpacity.bounds.size.height * 2.0f + 20.0f)];
    _adjustmentOpacity.tag = AdjustmentViewIdOpacity;
    [_adjustmentOpacity addSubview:_sliderOpacity];
    [_adjustmentOpacity addSubview:_sliderTemp];
    _adjustmentOpacity.hidden = YES;
    [self.view addSubview:_adjustmentOpacity];

    
    //////// Snowfall
    //////////// Global
    _sliderSnowfall = [[UIEditorSliderView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, [UIScreen screenSize].width, 42.0f)];
    _sliderSnowfall.tag = EditorSliderIconTypeSnowfall;
    _sliderSnowfall.delegate = self;
    _sliderSnowfall.title = NSLocalizedString(@"Brightness", nil);
    _sliderSnowfall.iconType = EditorSliderIconTypeSnowfall;
    _sliderSnowfall.titlePosition = SliderViewTitlePositionLeft;
    _sliderSnowfall.defaultValue = 0.5f;
    //////////// Levels
    _sliderSnowRadius = [[UIEditorSliderView alloc] initWithFrame:CGRectMake(0.0f, 10.0f + _sliderSnowfall.frame.size.height, [UIScreen screenSize].width, 42.0f)];
    _sliderSnowRadius.tag = EditorSliderIconTypeSnowRadius;
    _sliderSnowRadius.delegate = self;
    _sliderSnowRadius.title = NSLocalizedString(@"Levels", nil);
    _sliderSnowRadius.iconType = EditorSliderIconTypeSnowRadius;
    _sliderSnowRadius.titlePosition = SliderViewTitlePositionLeft;
    _sliderSnowRadius.defaultValue = 0.5f;
    //////// Adjustment
    _adjustmentSnowfall = [[UISliderContainer alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen screenSize].width, _sliderSnowfall.bounds.size.height * 2.0f + 20.0f)];
    _adjustmentSnowfall.tag = AdjustmentViewIdSnowfall;
    [_adjustmentSnowfall addSubview:_sliderSnowfall];
    [_adjustmentSnowfall addSubview:_sliderSnowRadius];
    _adjustmentSnowfall.hidden = YES;
    [self.view addSubview:_adjustmentSnowfall];
    
    
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
    UIImage* image = [CurrentImage resizedImageForEditor];
    if (image) {
        image = [Processor executeWithImage:image];
        [_previewImageView removeLoadingIndicator];
        _previewImageView.imageOriginal = image;
        _previewImageView.isPreviewReady = YES;
        [_previewImageView toggleOriginalImage:YES];
        [_previewImageView renderImageOriginal];
        [self slideUpAdjustment:self.adjustmentOpacity Completion:nil];
    }
}

- (void)processForEditor
{
    
    UIImage* image = [CurrentImage resizedImageForEditor];
    if (image) {
        image = [Processor executeWithImage:image];
        _previewImageView.imageOriginal = image;
        [_previewImageView toggleOriginalImage:YES];
        [_previewImageView renderImageOriginal];
        [self unlockAllSliders];
    }

}

#pragma mark slider


- (void)slideDownAdjustment:(UISliderContainer *)adjustment Completion:(void (^)(BOOL))completion
{
    if (_isSliding) {
        LOG(@"sliding.");
        return;
    }
    _isSliding = YES;
    __block EditorViewController* _self = self;
    __block UISliderContainer* _adjustment = adjustment;
    [UIView animateWithDuration:0.10f animations:^{
        _adjustment.frame = CGRectMake(_adjustment.frame.origin.x, [UIScreen screenSize].height - 44.0f, _adjustment.frame.size.width, _adjustment.frame.size.height);
    } completion:^(BOOL finished){
        _adjustment.hidden = YES;
        _self.isSliding = NO;
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)slideUpAdjustment:(UISliderContainer *)adjustment Completion:(void (^)(BOOL))completion
{
    if (_isSliding) {
        LOG(@"sliding.");
        return;
    }
    _isSliding = YES;
    [adjustment setY:[UIScreen screenSize].height - 44.0f];
    adjustment.hidden = NO;
    _adjustmentCurrent = adjustment;
    __block EditorViewController* _self = self;
    [UIView animateWithDuration:0.10f animations:^{
        _self.adjustmentCurrent.frame = CGRectMake(_self.adjustmentCurrent.frame.origin.x, [UIScreen screenSize].height - _self.adjustmentCurrent.bounds.size.height - 44.0f, _self.adjustmentCurrent.frame.size.width, _self.adjustmentCurrent.frame.size.height);
    } completion:^(BOOL finished){
        _self.isSliding = NO;
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)slideDownCurrentAdjustmentAndSlideUpAdjustment:(UISliderContainer *)adjustment
{
    if (_adjustmentCurrent) {
        __block UISliderContainer* _adjustment = adjustment;
        __block EditorViewController* _self = self;
        [self slideDownAdjustment:_adjustmentCurrent Completion:^(BOOL finished){
            [_self slideUpAdjustment:_adjustment Completion:nil];
        }];
    }else{
        [self slideUpAdjustment:adjustment Completion:nil];
    }
}

- (void)lockAllSliders
{
    if(_adjustmentCurrent.locked){
        return;
    }
    _adjustmentCurrent.locked = YES;
    if(_adjustmentCurrent == _adjustmentSnowfall){
        _sliderSnowfall.locked = YES;
        _sliderSnowRadius.locked = YES;
        return;
    }
    if(_adjustmentCurrent == _adjustmentOpacity){
        _sliderOpacity.locked = YES;
        _sliderTemp.locked = YES;
        return;
    }
}

- (void)unlockAllSliders
{
    
    _adjustmentCurrent.locked = NO;
    if(_adjustmentCurrent == _adjustmentSnowfall){
        _sliderSnowfall.locked = NO;
        _sliderSnowRadius.locked = NO;
        return;
    }
    if(_adjustmentCurrent == _adjustmentOpacity){
        _sliderOpacity.locked = NO;
        _sliderTemp.locked = NO;
        return;
    }
}

- (void)showCurrentValueWithSlider:(UIEditorSliderView *)slider
{
    _percentageLabel.hidden = NO;
    switch (slider.tag) {
        case EditorSliderIconTypeOpacity:
            _percentageLabel.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Opacity", nil), (int)roundf(slider.value * 100.0f)];
            break;
        case EditorSliderIconTypeTemp:
            _percentageLabel.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Temperature", nil), (int)roundf(slider.value * 100.0f)];
            break;
        case EditorSliderIconTypeSnowfall:
            _percentageLabel.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Saturation", nil), (int)roundf(slider.value * 100.0f)];
            break;
        case EditorSliderIconTypeSnowRadius:
            _percentageLabel.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Vibrance", nil), (int)roundf(slider.value * 100.0f)];
            break;
    }
    
    
}

- (void)applyValueWithSlider:(UIEditorSliderView *)slider
{
    switch (slider.tag) {
        case EditorSliderIconTypeTemp:
            [Processor instance].temp = slider.value;
            break;
        case EditorSliderIconTypeOpacity:
            [Processor instance].opacity = slider.value;
            break;
        case EditorSliderIconTypeSnowRadius:
            [Processor instance].snowRadius = slider.value;
            break;
        case EditorSliderIconTypeSnowfall:
            [Processor instance].snowfall = slider.value;
            break;
    }
    
}

#pragma mark save dialog

- (void)showSaveDialog
{
    if(_dialogState != DialogStateDidHide){
        return;
    }
    _dialogState = DialogStateWillShow;
    
    if(!_dialogBgImageView){
        _dialogBgImageView = [[UIEditorDialogBgImageView alloc] init];
        _dialogBgImageView.delegate = self;
    }
    UIImage* dialogBgImage = [CurrentImage dialogBgImage];
    
    _dialogBgImageView.hidden = YES;
    _dialogBgImageView.alpha = 0.70f;
    [_dialogBgImageView setImage:dialogBgImage];
    [_dialogBgImageView setCenter:_previewImageView.center];
    [self.view addSubview:_dialogBgImageView];
    
    if(!_saveDialogView){
        _saveDialogView = [[UISaveDialogView alloc] init];
        _saveDialogView.delegate = self;
    }
    _saveDialogView.alpha = 0.0f;
    [_saveDialogView setY:[UIScreen screenSize].height];
    [self.view addSubview:_saveDialogView];
    
    CGFloat width = dialogBgImage.size.width * [UIScreen screenSize].height / dialogBgImage.size.height;
    CGFloat height = [UIScreen screenSize].height;
    if (width < [UIScreen screenSize].width) {
        height *= [UIScreen screenSize].width / width;
        width = [UIScreen screenSize].width;
    }
    CGRect frame = CGRectMake(0.0f, 0.0f, width, height);
    _dialogBgImageView.frame = frame;
    _dialogBgImageView.center = _previewImageView.center;
    frame = _dialogBgImageView.frame;
    _dialogBgImageView.frame = _previewImageView.frame;
    _dialogBgImageView.hidden = NO;
    
    CGPoint center = self.view.center;
    CGFloat saveToViewTop = [UIScreen height] - _saveDialogView.frame.size.height - 40.0f;
    
    [self slideDownAdjustment:_adjustmentCurrent Completion:nil];
    
    __block EditorViewController* _self = self;
    [UIView animateWithDuration:0.20f animations:^{
        _self.saveDialogView.alpha = 1.0f;
        [_self.saveDialogView setY:saveToViewTop];
        [_self.topNavigationBar setY:-44.0f];
        [_self.bottomNavigationBar setY:[UIScreen screenSize].height];
        _self.dialogBgImageView.frame = frame;
        _self.dialogBgImageView.center = center;
        _self.dialogBgImageView.alpha = 1.0f;
    } completion:^(BOOL finished){
        _self.dialogState = DialogStateDidShow;
    }];
}

- (void)hideSaveDialog
{
    [CurrentImage deleteLastSavedImage];
    if(_dialogState != DialogStateDidShow){
        return;
    }
    CGRect frame = _previewImageView.frame;
    __block EditorViewController* _self = self;
    [UIView animateWithDuration:0.20f animations:^{
        [_self.saveDialogView setY:[UIScreen screenSize].height];
        _self.saveDialogView.alpha = 0.0f;
        _self.dialogBgImageView.frame = frame;
        [_self.topNavigationBar setY:0.0f];
        [_self.bottomNavigationBar setY:[UIScreen screenSize].height - 44.0f];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.10f animations:^{
            _self.dialogBgImageView.alpha = 0.0f;
        } completion:^(BOOL finished){
            _self.dialogState = DialogStateDidHide;
            [_self.dialogBgImageView removeFromSuperview];
        }];
    }];
}



#pragma mark button events

- (void)didPressAdjustmentButton:(UINavigationBarButton *)button
{
    if (_isSliding) {
        return;
    }
    if(_isApplying){
        return;
    }
    _buttonSnowfall.selected = NO;
    _buttonOpacity.selected = NO;
    button.selected = YES;
    UISliderContainer* adjustment;
    switch (button.tag) {
        case AdjustmentViewIdOpacity:
            adjustment = _adjustmentOpacity;
            [_topNavigationBar setTitle:NSLocalizedString(@"OPACITY", nil)];
            break;
        case AdjustmentViewIdSnowfall:
            adjustment = _adjustmentSnowfall;
            [_topNavigationBar setTitle:NSLocalizedString(@"SNOWFALL", nil)];
            break;
        default:
            break;
    }
    [self slideDownCurrentAdjustmentAndSlideUpAdjustment:adjustment];
}

- (void)didPressSaveButton
{
    if(_isApplying){
        return;
    }
    if(_isSliding){
        return;
    }
    [self showSaveDialog];
}

- (void)didPressCloseButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark slider delegate


- (void)slider:(UIEditorSliderView*)slider DidValueChange:(CGFloat)value
{
    if (_isApplying) {
        return;
    }

    [self showCurrentValueWithSlider:slider];
    
}

- (BOOL)sliderShouldValueResetToDefault:(UIEditorSliderView *)slider
{
    if (_isApplying) {
        return false;
    }else{
        [_previewImageView toggleBlurredImage:YES WithDuration:0.10f];
        return true;
    }
}

- (void)sliderDidValueResetToDefault:(UIEditorSliderView *)slider
{
    if (_isApplying) {
        
    }else{
        [self lockAllSliders];
        [self applyValueWithSlider:slider];
        [self processForEditor];
    }
}

- (void)touchesBeganWithSlider:(UIEditorSliderView *)slider
{
    if (_isApplying) {
        return;
    }
    LOG(@"touchstart");
    [_previewImageView toggleBlurredImage:YES WithDuration:0.10f];
    
}

- (void)touchesEndedWithSlider:(UIEditorSliderView *)slider
{
    LOG(@"touchesend");
    _percentageLabel.hidden = YES;
    if (!_previewImageView.isPreviewReady) {
        LOG(@"preview not ready.");
        [slider resetToDefaultPosition];
        return;
    }
    
    if (_isApplying) {
        return;
    }
    [self lockAllSliders];
    [self applyValueWithSlider:slider];
    [self processForEditor];
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

//
//  EditorViewController.h
//  Winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "SVProgressHUD.h"
#import "GPUImageEffects.h"
#import "GPUEffectColdWinter.h"
#import "GPUEffectAutumnToWinter.h"
#import "UINavigationBarView.h"
#import "UINavigationBarButton.h"
#import "UICloseButton.h"
#import "UISaveButton.h"
#import "UIEditorSliderView.h"
#import "UISliderContainer.h"
#import "UIEditorPreviewImageView.h"
#import "UIEditorDialogBgImageView.h"
#import "UISaveDialogView.h"
#import "ShareInstagramViewController.h"

typedef NS_ENUM(NSInteger, AdjustmentViewId){
    AdjustmentViewIdOpacity = 1,
    AdjustmentViewIdSnowfall
};

typedef NS_ENUM(NSInteger, DialogState){
    DialogStateWillShow = 1,
    DialogStateDidShow,
    DialogStateWillHide,
    DialogStateDidHide,
};

@interface EditorViewController : UIViewController <UIEditorSliderViewDelegate, UIEditorPreviewDelegate, UIEditorDialogBgImageViewDelegate, UISaveDialogViewDelegate, UIDocumentInteractionControllerDelegate>
{
    UIEditorSliderView* _sliderOpacity;
    UIEditorSliderView* _sliderTemp;
    UIEditorSliderView* _sliderBrightness;
    UIEditorSliderView* _sliderSnowfall;
    UIEditorSliderView* _sliderSnowDirection;
    UINavigationBarButton* _buttonOpacity;
    UINavigationBarButton* _buttonSnowfall;

    UILabel* _percentageLabel;
    UIDocumentInteractionController* _interactionController;
}


@property (nonatomic, assign) DialogState dialogState;
@property (nonatomic, assign) BOOL isSaving;
@property (nonatomic, assign) BOOL isApplying;
@property (nonatomic, assign) BOOL isSliding;
@property (nonatomic, strong) UINavigationBarView* topNavigationBar;
@property (nonatomic, strong) UINavigationBarView* bottomNavigationBar;
@property (nonatomic, weak) UISliderContainer* adjustmentCurrent;
@property (nonatomic, strong) UISliderContainer* adjustmentOpacity;
@property (nonatomic, strong) UISliderContainer* adjustmentSnowfall;
@property (nonatomic, strong) UIEditorPreviewImageView* previewImageView;
@property (nonatomic, strong) UISaveDialogView* saveDialogView;
@property (nonatomic, strong) UIEditorDialogBgImageView* dialogBgImageView;
@property (nonatomic, strong) UIImage* editorImage;
@property (nonatomic, strong) UIImage* editorBlurredImage;


- (void)didFinishResizing;
- (void)processForEditor;

- (void)slideDownAdjustment:(UISliderContainer*)adjustment Completion:(void (^)(BOOL))completion;
- (void)slideUpAdjustment:(UISliderContainer*)adjustment Completion:(void (^)(BOOL))completion;
- (void)slideDownCurrentAdjustmentAndSlideUpAdjustment:(UISliderContainer *)adjustment;

- (void)showSaveDialog;
- (void)hideSaveDialog;

- (void)didPressAdjustmentButton:(UINavigationBarButton*)button;
- (void)didPressCloseButton;
- (void)didPressSaveButton;

@end

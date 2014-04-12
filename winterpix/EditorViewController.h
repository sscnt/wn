//
//  EditorViewController.h
//  Winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
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

@interface EditorViewController : UIViewController{
    UIEditorSliderView* _sliderOpacity;
    UIEditorSliderView* _sliderTemp;
    UIEditorSliderView* _sliderSnowfall;
    UIEditorSliderView* _sliderSnowRadius;
    UINavigationBarButton* _buttonOpacity;
    UINavigationBarButton* _buttonSnowfall;
    
    UILabel* _percentageLabel;
    UIDocumentInteractionController* _interactionController;
}


@property (nonatomic, assign) BOOL faceDetected;
@property (nonatomic, strong) UINavigationBarView* topNavigationBar;
@property (nonatomic, strong) UINavigationBarView* bottomNavigationBar;
@property (nonatomic, weak) UISliderContainer* adjustmentOpacity;
@property (nonatomic, strong) UISliderContainer* adjustmentSnowfall;
@property (nonatomic, strong) UIEditorPreviewImageView* previewImageView;

- (void)didFinishResizing;

@end

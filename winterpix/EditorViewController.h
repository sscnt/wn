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

@interface EditorViewController : UIViewController

@property (nonatomic, assign) BOOL faceDetected;

- (void)didFinishResizing;

@end

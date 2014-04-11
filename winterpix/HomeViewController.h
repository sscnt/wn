//
//  HomeViewController.h
//  winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIHomeBgView.h"
#import "UIHomeSourceButton.h"
#import "EditorViewController.h"

@interface HomeViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIHomeBgView* _bgView;
    UIHomeBgView* _splashView;
    UIHomeSourceButton* _photosButton;
    UIHomeSourceButton* _cameraButton;
}

- (void)didPressButton:(UIHomeSourceButton*)sender;

- (void)didPressCameraButton;
- (void)didPressPhotosButton;

- (void)showErrorAlertWithMessage:(NSString*)message;

- (void)goToEffectsViewControllerWithImage:(UIImage*)image;

@end

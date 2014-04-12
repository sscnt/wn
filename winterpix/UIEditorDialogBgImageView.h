//
//  UIEditorDialogBgImageView.h
//  Vintage
//
//  Created by SSC on 2014/03/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIEditorDialogBgImageView;

@protocol UIEditorDialogBgImageViewDelegate
- (void)touchesBeganWithBackgroundImageView:(UIEditorDialogBgImageView*)slider;
- (void)touchesEndedWithBackgroundImageView:(UIEditorDialogBgImageView*)slider;
@end

@interface UIEditorDialogBgImageView : UIImageView

@property (nonatomic, assign) id<UIEditorDialogBgImageViewDelegate> delegate;

@end

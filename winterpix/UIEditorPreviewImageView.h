//
//  UIEditorPreviewImageView.h
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRenderImageView.h"

@class UIEditorPreviewImageView;

@protocol UIEditorPreviewDelegate
- (void)previewIsReady:(UIEditorPreviewImageView*)preview;
- (void)previewDidTouchDown:(UIEditorPreviewImageView*)preview;
- (void)previewDidTouchUp:(UIEditorPreviewImageView*)preview;
@end

@interface UIEditorPreviewImageView : UIButton
{
    UIImageView* _imageViewLoading;
    UIImageView* _imageViewOriginal;
    UIImageView* _imageViewPreview;
    UIImageView* _imageViewBlurred;
}

@property (nonatomic, assign) CGFloat opacity;
@property (nonatomic, assign) BOOL isPreviewReady;
@property (nonatomic, strong) UIImageView* previewImageView;
@property (nonatomic, weak) UIImage* imageOriginal;
@property (nonatomic, weak) UIImage* imagePreview;
@property (nonatomic, weak) UIImage* imageBlurred;
@property (nonatomic, assign) id<UIEditorPreviewDelegate> delegate;

- (void)removeLoadingIndicator;

- (void)toggleBlurredImage:(BOOL)show;
- (void)toggleBlurredImage:(BOOL)show WithDuration:(CGFloat)duration;
- (void)toggleOriginalImage:(BOOL)show;

- (void)didTouchUp;
- (void)didTouchDown;

@end

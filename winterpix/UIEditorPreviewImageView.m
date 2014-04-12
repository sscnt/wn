//
//  UIEditorPreviewImageView.m
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UIEditorPreviewImageView.h"

@implementation UIEditorPreviewImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isPreviewReady = NO;
        [self setBackgroundColor:[UIColor colorWithWhite:33.0f/255.0f alpha:1.0f]];
        
        _imageViewBlurred = [[UIRenderImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        _imageViewBlurred.hidden = YES;
        [self addSubview:_imageViewBlurred];
        _imageViewOriginal = [[UIRenderImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        _imageViewOriginal.hidden = YES;
        [self addSubview:_imageViewOriginal];
        
        [self addTarget:self action:@selector(didTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didTouchUp) forControlEvents:UIControlEventTouchUpInside];
        
        
        //// Loading
        _imageViewLoading = [[UIImageView alloc] initWithImage:[UIImage animatedGIFNamed:@"loading-48"]];
        _imageViewLoading.center = CGPointMake(roundf(frame.size.width / 2.0), roundf(frame.size.height / 2.0));
        [self addSubview:_imageViewLoading];
    }
    return self;
}

- (void)removeLoadingIndicator
{
    if (_imageViewLoading) {
        [_imageViewLoading removeFromSuperview];
        _imageViewLoading = nil;
    }
}

- (void)toggleOriginalImage:(BOOL)show
{
    LOG(@"toggleOriginalImage: %d", show);
    if (show) {
        _imageViewOriginal.hidden = NO;
        _imageViewOriginal.alpha = 1.0f;
    }else{
        _imageViewOriginal.hidden = YES;
        _imageViewOriginal.alpha = 0.0f;
    }
}

- (void)toggleBlurredImage:(BOOL)show
{
    LOG(@"toggleBlurredImage: %d", show);
    if (show) {
        _imageViewBlurred.hidden = NO;
        _imageViewBlurred.alpha = 1.0f;
    }else{
        _imageViewBlurred.hidden = YES;
        _imageViewBlurred.alpha = 0.0f;
    }
}

- (void)toggleBlurredImage:(BOOL)show WithDuration:(CGFloat)duration
{
    if (self.isPreviewReady == NO) {
        return;
    }
    __block UIEditorPreviewImageView* _self = self;
    LOG(@"toggleBlurredImageWithDuration: %d", show);
    if (show) {
        _imageViewBlurred.alpha = 0.0f;
        _imageViewBlurred.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            _imageViewBlurred.alpha = 1.0f;
        } completion:^(BOOL finished){
            
        }];
    }else{
        if(_imageViewBlurred.hidden){
            [self.delegate previewIsReady:_self];
            return;
        }
        _imageViewBlurred.alpha = 1.0f;
        _imageViewBlurred.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            _imageViewBlurred.alpha = 0.0f;
        } completion:^(BOOL finished){
            _imageViewBlurred.hidden = YES;
            [_self.delegate previewIsReady:_self];
        }];
    }
}

- (void)setImageOriginal:(UIImage *)imageOriginal
{
    _imageViewOriginal.image = imageOriginal;
}

- (void)setImageBlurred:(UIImage *)imageBlurred
{
    _imageBlurred = imageBlurred;
}

- (void)renderImageOriginal
{
    [_imageViewOriginal setNeedsDisplay];
}

- (void)didTouchUp
{
    [self.delegate previewDidTouchUp:self];
}

- (void)didTouchDown
{
    [self.delegate previewDidTouchDown:self];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end

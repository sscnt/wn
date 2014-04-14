//
//  ShareInstagramViewController.h
//  Vintage
//
//  Created by SSC on 2014/04/02.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareInstagramViewController : UIViewController<UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong) UIDocumentInteractionController *interactionController;

- (void)setImage:(UIImage *)image;

@end

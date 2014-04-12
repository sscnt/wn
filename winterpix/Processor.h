//
//  Processor.h
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUEffectAutumnToWinter.h"
#import "GPUEffectColdWinter.h"

@protocol ProcessorDelegate <NSObject>
@optional


@end

@interface Processor : NSObject

@property (nonatomic, assign) BOOL faceDetected;
@property (nonatomic, assign) float opacity;
@property (nonatomic, assign) float temp;
@property (nonatomic, assign) float snowfall;
@property (nonatomic, assign) float snowRadius;

+ (Processor*)instance;

+ (UIImage*)executeWithImage:(UIImage*)image;
+ (UIImage*)executeWithCurrentOriginalImage;

@end

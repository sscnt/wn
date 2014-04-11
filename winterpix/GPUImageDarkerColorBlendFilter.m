//
//  GPUImageDarkerBlendFilter.m
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageDarkerColorBlendFilter.h"

NSString *const kGPUImageDarkerColorBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     if(overlay.r < base.r){
         base.r = overlay.r;
     }
     if(overlay.g < base.g){
         base.g = overlay.g;
     }
     if(overlay.b < base.b){
         base.b = overlay.b;
     }
     gl_FragColor = base;
 }
 );


@implementation GPUImageDarkerColorBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageDarkerColorBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

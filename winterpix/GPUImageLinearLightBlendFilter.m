//
//  GPUImageLinearLightBlendFilter.m
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageLinearLightBlendFilter.h"


NSString *const kGPUImageLinearLightBlendFilterFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     mediump vec3 result = base.rgb + 2.0 * overlay.rgb - 1.0;
     result.r = max(0.0, min(result.r, 1.0));
     result.g = max(0.0, min(result.g, 1.0));
     result.b = max(0.0, min(result.b, 1.0));
     
     gl_FragColor = vec4(result * overlay.a + base.rgb * (1.0 - overlay.a), 1.0);
 }
 );


@implementation GPUImageLinearLightBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageLinearLightBlendFilterFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

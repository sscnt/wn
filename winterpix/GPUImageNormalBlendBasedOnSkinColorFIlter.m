//
//  GPUImageNormalBlendBasedOnSkinColorFIlter.m
//  Winterpix
//
//  Created by SSC on 2014/04/14.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageNormalBlendBasedOnSkinColorFIlter.h"


NSString *const kGPUImageNormalBlendBasedOnSkinColorNormalBlendBasedOnSkinColorFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec3 v3 = base.rgb - vec3(252.0 / 255.0, 252.0 / 255.0, 196.0 / 255.0);
     v3 = v3 * v3;
     mediump float dist = sqrt(v3.x + v3.y + v3.z);
     dist = 1.0 - dist;
     dist = max(min(dist, 1.0), 0.0);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     mediump vec3 result = base.rgb * dist + overlay.rgb * (1.0 - dist);
     result.r = max(0.0, min(result.r, 1.0));
     result.g = max(0.0, min(result.g, 1.0));
     result.b = max(0.0, min(result.b, 1.0));
     
     
     gl_FragColor = vec4(result * overlay.a + base.rgb * (1.0 - overlay.a), 1.0);
 }
 );


@implementation GPUImageNormalBlendBasedOnSkinColorFIlter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageNormalBlendBasedOnSkinColorNormalBlendBasedOnSkinColorFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}
@end

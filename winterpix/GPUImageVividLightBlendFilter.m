//
//  GPUImageVividLightBlendFIlter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageVividLightBlendFilter.h"

NSString *const kGPUImageVividLightBlendFragmentShaderString = SHADER_STRING
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
     
     
     mediump float ra;
     if (overlay.r < 0.5) {
         if(overlay.r == 0.0){
             ra = 0.0;
         } else {
             ra = 1.0 - (1.0 - base.r) / (2.0 * overlay.r);
         }
     } else {
         if(overlay.r == 1.0){
             ra = 1.0;
         } else {
             ra = base.r / (2.0 * (1.0 - overlay.r));
         }
     }
     mediump float ga;
     if (overlay.g < 0.5) {
         if(overlay.g == 0.0){
             ga = 0.0;
         } else {
             ga = 1.0 - (1.0 - base.g) / (2.0 * overlay.g);
         }
     } else {
         if(overlay.g == 1.0){
             ga = 1.0;
         } else {
             ga = base.g / (2.0 * (1.0 - overlay.g));
         }
     }
     mediump float ba;
     if (overlay.b < 0.5) {
         if(overlay.b == 0.0){
             ba = 0.0;
         } else {
             ba = 1.0 - (1.0 - base.b) / (2.0 * overlay.b);
         }
     } else {
         if(overlay.b == 1.0){
             ba = 1.0;
         } else {
             ba = base.b / (2.0 * (1.0 - overlay.b));
         }
     }
     
     ra = min(1.0, max(0.0, ra));
     ga = min(1.0, max(0.0, ga));
     ba = min(1.0, max(0.0, ba));
     
     ra = ra * overlay.a + (1.0 - overlay.a) * base.r;
     ga = ga * overlay.a + (1.0 - overlay.a) * base.g;
     ba = ba * overlay.a + (1.0 - overlay.a) * base.b;
     
     gl_FragColor = vec4(ra, ga, ba, 1.0);
 }
 );



@implementation GPUImageVividLightBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageVividLightBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end


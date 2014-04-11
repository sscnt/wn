//
//  GPULevelsImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPULevelsImageFilter.h"

@implementation GPULevelsImageFilter

NSString *const kGravyLevelsFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float lvLowWeight;
 uniform mediump float lvMidWeight;
 uniform mediump float lvHighWeight;
 uniform mediump float histHighestValue;
 uniform mediump float histLowestValue;
 uniform mediump float diffHighAndMid;
 uniform mediump float diffMidAndLow;
 uniform mediump float mtplHM;
 uniform mediump float mtplML;
 uniform int sigmoid;
 
 void main()
 {
     // Sample the input pixel
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float r = pixel.r * 0.8588 + 0.0625;
     mediump float g = pixel.g * 0.8588 + 0.0625;
     mediump float b = pixel.b * 0.8588 + 0.0625;
     
     mediump float y = 0.299 * r + 0.587 * g + 0.114 * b;
     mediump float u = -0.169 * r - 0.331 * g + 0.500 * b;
     mediump float v = 0.500 * r - 0.419 * g - 0.081 * b;
     mediump float _y;
     
     if(y > lvMidWeight){
         _y = (y - lvMidWeight) * 0.500 * mtplHM + 0.500;
     } else {
         _y = (y - lvLowWeight) * 0.500 * mtplML;
     }
     if(sigmoid == 0){
         y = _y;
         
     } else{
         y = y + (_y - y) * ((1.0 / (1.0 + pow(2.718282, y * 12.0 - 6.0))) + 0.5);
     }
     
     
     y = max(0.0 , min(1.0, y));
     
     r = y + 1.402 * v - 0.0625;
     g = y - 0.344 * u - 0.714 * v - 0.0625;
     b = y + 1.772 * u - 0.0625;
     
     r *= 1.164;
     g *= 1.164;
     b *= 1.164;
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
     
     // saturation
     mediump float m60 = 0.0166665;
     mediump float max = max(r, max(g, b));
     mediump float min = min(r, min(g, b));
     mediump float h = 0.0;
     
     if(max == min){
         
     } else if(max == r){
         h = 60.0 * (g - b) / (max - min);
     } else if(max == g){
         h = 60.0 * (b - r) / (max - min) + 120.0;
     } else if(max == b){
         h = 60.0 * (r - g) / (max - min) + 240.0;
     }
     if(h < 0.0){
         h += 360.0;
         
     }
     
     mediump float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     v = max;
     
     mediump float _s;
     int index = 0;
     
     _s = (1.0 - cos(s * 3.1415927)) * min(1.0, max(0.0, (0.5 - lvMidWeight) * 2.3));
     _s *= (1.0 - cos(y * 3.1415927)) * min(1.0, max(0.0, (1.0 - lvHighWeight) * 2.3));
     _s *= 0.4 * (0.5 - cos(h * 0.0174533)) + 0.8;
     s += _s;
     
     s = max(0.0, min(1.0, s));
     
     int hi = int(floor(mod(h * m60, 6.0)));
     mediump float f = (h * m60) - float(floor(h * m60));
     mediump float p = v * (1.0 - s);
     mediump float q = v * (1.0 - s * f);
     mediump float t = v * (1.0 - s * (1.0 - f));
     
     if(hi == 0){
         r = v;
         g = t;
         b = p;
     } else if(hi == 1){
         r = q;
         g = v;
         b = p;
     } else if(hi == 2){
         r = p;
         g = v;
         b = t;
     } else if(hi == 3){
         r = p;
         g = q;
         b = v;
     } else if(hi == 4){
         r = t;
         g = p;
         b = v;
     } else if(hi == 5){
         r = v;
         g = p;
         b = q;
     } else {
         r = v;
         g = t;
         b = p;
     }
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
     
     pixel.r = r;
     pixel.g = g;
     pixel.b = b;
     
     // Save the result
     gl_FragColor = pixel;
 }
 );

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGravyLevelsFragmentShaderString]))
    {
        return nil;
    }
    lvLowWeightUniform = [filterProgram uniformIndex:@"lvLowWeight"];
    self.lvLowWeight = 0.0f;
    
    lvMidWeightUniform = [filterProgram uniformIndex:@"lvMidWeight"];
    self.lvMidWeight = 0.500f;
    
    lvHighWeightUniform = [filterProgram uniformIndex:@"lvHighWeight"];
    self.lvHighWeight = 1.0f;
    
    histHighestValueUniform = [filterProgram uniformIndex:@"histLowestValue"];
    self.histHighestValue = 1.0f;
    
    histLowestValueUniform = [filterProgram uniformIndex:@"histHighestValue"];
    self.histLowestValue = 0.0f;
    
    diffHighAndMidUniform = [filterProgram uniformIndex:@"diffHighAndMid"];
    self.diffHighAndMid = 0.5000;
    
    diffMidAndLowUniform = [filterProgram uniformIndex:@"diffMidAndLow"];
    self.diffMidAndLow = 0.5000;
    
    mtplHMUniform = [filterProgram uniformIndex:@"mtplHM"];
    self.mtplHM = 1.0 / self.diffHighAndMid;
    
    mtplMLUniform = [filterProgram uniformIndex:@"mtplML"];
    self.mtplML = 1.0 / self.diffMidAndLow;
    
    sigmoidUniform = [filterProgram uniformIndex:@"sigmoid"];
    self.sigmoid = 0;
    return self;
}

- (void)setLvLowWeight:(float)lvLowWeight
{
    _lvLowWeight = lvLowWeight;
    [self setFloat:_lvLowWeight forUniform:lvLowWeightUniform program:filterProgram];
    self.diffMidAndLow = _lvMidWeight - _lvLowWeight;
}

- (void)setLvMidWeight:(float)lvMidWeight
{
    _lvMidWeight = lvMidWeight;
    [self setFloat:_lvMidWeight forUniform:lvMidWeightUniform program:filterProgram];
    self.diffHighAndMid = _lvHighWeight - _lvMidWeight;
    self.diffMidAndLow = _lvMidWeight - _lvLowWeight;
}

- (void)setLvHighWeight:(float)lvHighWeight
{
    _lvHighWeight = lvHighWeight;
    [self setFloat:_lvHighWeight forUniform:lvHighWeightUniform program:filterProgram];
    self.diffHighAndMid = _lvHighWeight - _lvMidWeight;
}

- (void)setHistLowestValue:(float)histLowestValue
{
    _histLowestValue = histLowestValue;
    [self setFloat:_histLowestValue forUniform:histLowestValueUniform program:filterProgram];
}

- (void)setHistHighestValue:(float)histHighestValue
{
    _histHighestValue = histHighestValue;
    [self setFloat:_histHighestValue forUniform:histHighestValueUniform program:filterProgram];
}

- (void)setDiffHighAndMid:(float)diffHighAndMid
{
    _diffHighAndMid = diffHighAndMid;
    [self setFloat:_diffHighAndMid forUniform:diffHighAndMidUniform program:filterProgram];
    self.mtplHM = 1.000 / _diffHighAndMid;
}

- (void)setDiffMidAndLow:(float)diffMidAndLow
{
    _diffMidAndLow = diffMidAndLow;
    [self setFloat:_diffMidAndLow forUniform:diffMidAndLowUniform program:filterProgram];
    self.mtplML = 1.000 / _diffMidAndLow;
}

- (void)setMtplHM:(float)mtplHM
{
    _mtplHM = mtplHM;
    [self setFloat:_mtplHM forUniform:mtplHMUniform program:filterProgram];
}

- (void)setMtplML:(float)mtplML
{
    _mtplML = mtplML;
    [self setFloat:_mtplML forUniform:mtplMLUniform program:filterProgram];
}

- (void)setSigmoid:(int)sigmoid
{
    _sigmoid = sigmoid;
    [self setInteger:_sigmoid forUniform:sigmoidUniform program:filterProgram];
}
@end

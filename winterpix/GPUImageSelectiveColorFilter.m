//
//  GPUImageSelectiveColorFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageSelectiveColorFilter.h"

@implementation GPUImageSelectiveColorFilter

NSString *const kGPUImageSelectiveColorFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform mediump float redsCyan;
 uniform mediump float redsMagenta;
 uniform mediump float redsYellow;
 uniform mediump float redsBlack;
 
 uniform mediump float yellowsCyan;
 uniform mediump float yellowsMagenta;
 uniform mediump float yellowsYellow;
 uniform mediump float yellowsBlack;
 
 uniform mediump float greensCyan;
 uniform mediump float greensMagenta;
 uniform mediump float greensYellow;
 uniform mediump float greensBlack;
 
 uniform mediump float cyansCyan;
 uniform mediump float cyansMagenta;
 uniform mediump float cyansYellow;
 uniform mediump float cyansBlack;
 
 uniform mediump float bluesCyan;
 uniform mediump float bluesMagenta;
 uniform mediump float bluesYellow;
 uniform mediump float bluesBlack;
 
 uniform mediump float magentasCyan;
 uniform mediump float magentasMagenta;
 uniform mediump float magentasYellow;
 uniform mediump float magentasBlack;
 
 uniform mediump float whitesCyan;
 uniform mediump float whitesMagenta;
 uniform mediump float whitesYellow;
 uniform mediump float whitesBlack;
 
 uniform mediump float neutralsCyan;
 uniform mediump float neutralsMagenta;
 uniform mediump float neutralsYellow;
 uniform mediump float neutralsBlack;
 
 uniform mediump float blacksCyan;
 uniform mediump float blacksMagenta;
 uniform mediump float blacksYellow;
 uniform mediump float blacksBlack;
 
 vec3 rgb2xyz(mediump vec3 color){
     mat3 adobe;
     adobe[0] = vec3(0.576669, 0.297345, 0.027031);
     adobe[1] = vec3(0.185558, 0.627364, 0.070689);
     adobe[2] = vec3(0.188229, 0.075291, 0.991338);
     mat3 srgb;
     srgb[0] = vec3(0.412391, 0.212639, 0.019331);
     srgb[1] = vec3(0.357584, 0.715169, 0.119195);
     srgb[2] = vec3(0.180481, 0.072192, 0.950532);
     return adobe * color;
 }
 
 vec3 xyz2rgb(mediump vec3 color){
     mat3 adobe;
     adobe[0] = vec3(2.041588, -0.969244, 0.013444);
     adobe[1] = vec3(-0.565007, 1.875968, -0.118362);
     adobe[2] = vec3(-0.344731, 0.041555, 1.015175);
     mat3 srgb;
     srgb[0] = vec3(3.240970 , -0.969244  , 0.055630 );
     srgb[1] = vec3(-1.537383 , 1.875968  , -0.203977  );
     srgb[2] = vec3(-0.498611, 0.041555, 1.056972);
     return adobe * color;
 }
 
 float xyz2labFt(mediump float t){
     if(t > 0.00885645167){
         return 116.0 * pow(t, 0.33333333333) - 16.0;
     } else{
         return 903.296296296 * t;
     }
 }
 
 vec3 xyz2lab(mediump vec3 color){
     mediump float l = xyz2labFt(color.y);
     mediump float a = 4.31034482759 * (xyz2labFt(color.x / 0.9642) - l);
     mediump float b = 1.72413793103 * (l - xyz2labFt(color.z / 0.8249));
     return vec3(l, a, b);
 }
 
 vec3 lab2xyz(mediump vec3 color){
     mediump float fy = (color.x + 16.0) / 116.0;
     mediump float fx = fy + (color.y / 500.0);
     mediump float fz = fy - (color.z / 200.0);
     mediump float x;
     mediump float y;
     mediump float z;
     if(fy > 0.20689655172)
         y = fy * fy * fy;
     else
         y = 0.00110705645 * (116.0 * fy - 16.0);
     if(fx > 0.20689655172)
         x = fx * fx * fx * 0.9642;
     else
         x = 0.00110705645 * (116.0 * fx - 16.0) * 0.9642;
     if(fz > 0.20689655172)
         z = fz * fz * fz * 0.8249 ;
     else
         z = 0.00110705645 * (116.0 * fz - 16.0) * 0.8249;
     return vec3(x, y, z);
 }
 
 vec3 rgb2lab(mediump vec3 color){
     return xyz2lab(rgb2xyz(color));
 }
 
 vec3 lab2rgb(mediump vec3 color){
     return xyz2rgb(lab2xyz(color));
 }
 
 float labDiff(mediump vec3 dest, mediump vec3 src){
     mediump float deltaL = dest.x - src.x;
     mediump float deltaA = dest.y - src.y;
     mediump float deltaB = dest.z - src.z;
     mediump float deltaE = sqrt(deltaL * deltaL + deltaA * deltaA + deltaB * deltaB);
     mediump float c1 = sqrt(dest.y * dest.y + dest.z * dest.z);
     mediump float c2 = sqrt(src.y * src.y + src.z * src.z);
     mediump float deltaCab = c1 - c2;
     mediump float deltaHab = sqrt(deltaA * deltaA + deltaB * deltaB - deltaCab * deltaCab);
     return deltaHab;
     
     mediump float kL = 1.0;
     mediump float kC = kL;
     mediump float kH = kL;
     mediump float k1 = 0.045;
     mediump float k2 = 0.015;
     mediump float sL = 1.0;
     mediump float sC = 1.0 + k1 * c1;
     mediump float sH = 1.0 + k2 * c1;
     
     mediump float a = deltaL / (kL * sL);
     mediump float b = deltaCab / (kC * sC);
     mediump float c = deltaHab / (kH * sH);
     
     return sqrt(a * a + b * b + c * c);
     
 }
 
 vec3 rgb2hsv(mediump vec3 color){
     mediump float r = color.r;
     mediump float g = color.g;
     mediump float b = color.b;
     
     mediump float max = max(r, max(g, b));
     mediump float min = min(r, min(g, b));
     mediump float h = 0.0;
     if(max < min){
         max = 0.0;
         min = 0.0;
     }
     
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
     h = mod(h, 360.0);
     
     mediump float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     mediump float v = max;
     
     return vec3(h, s, v);
 }
 
 vec3 hsv2rgb(mediump vec3 color){
     mediump float h = color.r;
     mediump float s = color.g;
     mediump float v = color.b;
     mediump float r;
     mediump float g;
     mediump float b;
     mediump float m60 = 0.01665;
     int hi = int(mod(float(floor(h * m60)), 6.0));
     mediump float f = (h * m60) - float(hi);
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
     return vec3(r, g, b);

 }
 
 void main()
 {
     // Sample the input pixel
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     mediump float r = pixel.r;
     mediump float g = pixel.g;
     mediump float b = pixel.b;
     mediump float ra = r;
     mediump float ga = g;
     mediump float ba = b;
     mediump float lum = 0.299 * r + 0.587 * g + 0.114 * b;
     mediump float max = max(r, max(g, b));
     mediump float min = min(r, min(g, b));
     mediump float luminosity = (max + min) / 2.0;
     
     // Convert to CMYK
     mediump float c = 1.0 - r;
     mediump float m = 1.0 - g;
     mediump float y = 1.0 - b;
     mediump float k = min(c, min(m, y));
     if(k == 1.0){
         c = 0.0;
         m = 0.0;
         y = 0.0;
     } else{
         c = (c - k) / (1.0 - k);
         m = (m - k) / (1.0 - k);
         y = (y - k) / (1.0 - k);
     }
     
     // Convert to HSV
     mediump vec3 hsv = rgb2hsv(vec3(r, g, b));
     
     // Convert to LAB
     mediump vec3 lab = rgb2lab(vec3(r, g, b));
     
     
     // Adjustment
     mediump float ca = c;
     mediump float ma = m;
     mediump float ya = y;
     mediump float ka = k;
     
     // Reds
     mediump vec3 redHsv = rgb2hsv(vec3(1.0, 0.0, 0.0));
     mediump float diff = abs(hsv.x - redHsv.x);
     if(diff > 180.0){
         diff = 360.0 - diff;
     }
     mediump float redsWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(redsCyan > 0.0)
         ca += (1.0 - c) * redsCyan * redsWeight * (1.0 - hsv.z);
     else
         ca -= (1.0 - c) * abs(redsCyan) * redsWeight * (1.0 - hsv.z);
     if(redsMagenta > 0.0)
         ma += m * redsMagenta * redsWeight;
     else
         ma -= m * abs(redsMagenta) * redsWeight;
     if(redsYellow > 0.0)
         ya += y * redsYellow * redsWeight;
     else
         ya -= y * abs(redsYellow) * redsWeight;

     // Yellows
     mediump vec3 yellowHsv = rgb2hsv(vec3(1.0, 1.0, 0.0));
     diff = abs(hsv.x - yellowHsv.x);
     mediump float yellowsWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(yellowsCyan > 0.0)
         ca += (1.0 - c) * yellowsCyan * yellowsWeight * (1.0 - hsv.z);
     else
         ca -= (1.0 - c) * abs(yellowsCyan) * yellowsWeight * (1.0 - hsv.z);
     if(yellowsMagenta > 0.0)
         ma += (1.0 - m) * yellowsMagenta * yellowsWeight * (1.0 - hsv.z);
     else
         ma -= (1.0 - m) * abs(yellowsMagenta) * yellowsWeight * (1.0 - hsv.z);
     if(yellowsYellow > 0.0)
         ya += y * yellowsYellow * yellowsWeight;
     else
         ya -= y * abs(yellowsYellow) * yellowsWeight;
     
     // Greens
     mediump vec3 greenHsv = rgb2hsv(vec3(0.0, 1.0, 0.0));
     diff = abs(hsv.x - greenHsv.x);
     mediump float greensWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(greensCyan > 0.0)
         ca += c * greensCyan * greensWeight;
     else
         ca -= c * abs(greensCyan) * sqrt(greensWeight) * 0.8;
     if(greensMagenta > 0.0)
         ma += (1.0 - m) * greensMagenta * greensWeight * (1.0 - hsv.z);
     else
         ma -= (1.0 - m) * abs(greensMagenta) * sqrt(greensWeight) * (1.0 - hsv.z) * 0.6;
     if(greensYellow > 0.0)
         ya += y * greensYellow * greensWeight;
     else
         ya -= y * abs(greensYellow) * sqrt(greensWeight);
     
     // Cyan
     mediump vec3 cyanHsv = rgb2hsv(vec3(0.0, 1.0, 1.0));
     diff = abs(hsv.x - cyanHsv.x);
     mediump float cyansWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(cyansCyan > 0.0)
         ca += c * cyansCyan * cyansWeight;
     else
         ca -= c * abs(cyansCyan) * cyansWeight;
     if(cyansMagenta > 0.0)
         ma += (1.0 - m) * cyansMagenta * cyansWeight * (1.0 - hsv.z);
     else
         ma -= (1.0 - m) * abs(cyansMagenta) * cyansWeight * (1.0 - hsv.z);
     if(cyansYellow > 0.0)
         ya += (1.0 - y) * cyansYellow * cyansWeight * (1.0 - hsv.z);
     else
         ya -= (1.0 - y) * abs(cyansYellow) * cyansWeight * (1.0 - hsv.z);
     
     // Blue
     mediump vec3 blueHsv = rgb2hsv(vec3(0.0, 0.0, 1.0));
     diff = abs(hsv.x - blueHsv.x);
     mediump float bluesWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(bluesCyan > 0.0)
         ca += c * bluesCyan * bluesWeight;
     else
         ca -= c * abs(bluesCyan) * bluesWeight;
     if(bluesMagenta > 0.0)
         ma += m * bluesMagenta * bluesWeight;
     else
         ma -= m * abs(bluesMagenta) * bluesWeight;
     if(bluesYellow > 0.0)
         ya += (1.0 - y) * bluesYellow * bluesWeight * (1.0 - hsv.z);
     else
         ya -= (1.0 - y) * abs(bluesYellow) * bluesWeight * (1.0 - hsv.z);
     
     // Magentas
     mediump vec3 magentaHsv = rgb2hsv(vec3(1.0, 0.0, 1.0));
     diff = abs(hsv.x - magentaHsv.x);
     mediump float magentasWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(magentasCyan > 0.0)
         ca += (1.0 - c) * magentasCyan * magentasWeight * (1.0 - hsv.z);
     else
         ca -= (1.0 - c) * abs(magentasCyan) * magentasWeight * (1.0 - hsv.z);
     if(magentasMagenta > 0.0)
         ma += m * magentasMagenta * magentasWeight;
     else
         ma -= m * abs(magentasMagenta) * magentasWeight;
     if(magentasYellow > 0.0)
         ya += (1.0 - y) * magentasYellow * magentasWeight * (1.0 - hsv.z);
     else
         ya -= (1.0 - y) * abs(magentasYellow) * magentasWeight * (1.0 - hsv.z);
     
     // Wthies
     mediump float whitesWeight = 1.0 - max(0.0, min(hsv.y * 3.0, 1.0));
     whitesWeight = max(0.0, (1.0 - sqrt(hsv.y * 2.0))) * hsv.z;
     if(whitesCyan > 0.0)
         ca += c * whitesCyan * whitesWeight;
     else
         ca -= c * abs(whitesCyan) * whitesWeight;
     if(whitesMagenta > 0.0)
         ma += m * whitesMagenta * whitesWeight;
     else
         ma -= m * abs(whitesMagenta) * whitesWeight;
     if(whitesYellow > 0.0)
         ya += y * whitesYellow * whitesWeight;
     else
         ya -= y * abs(whitesYellow) * whitesWeight;
     
     // Blacks
     mediump float blacksWeight = 1.0 - max(0.0, min((hsv.y - 0.66666666666) * 3.0, 1.0));
     blacksWeight = max(0.0, (1.0 - sqrt(hsv.z * 2.0)));
     if(blacksCyan > 0.0)
         ca += c * blacksCyan * blacksWeight;
     else
         ca -= c * abs(blacksCyan) * blacksWeight;
     if(blacksMagenta > 0.0)
         ma += m * blacksMagenta * blacksWeight;
     else
         ma -= m * abs(blacksMagenta) * blacksWeight;
     if(blacksYellow > 0.0)
         ya += y * blacksYellow * blacksWeight;
     else
         ya -= y * abs(blacksYellow) * blacksWeight;
     
     
     // Neutrals
     mediump float neutralsWeight = min(1.0, ((1.0 - max(0.0, min((hsv.y - 0.4) * 3.0, 1.0))) + sqrt(sin(k * 3.14))));
     neutralsWeight = max(0.0, (1.0 - sqrt(hsv.y))) * (1.0 - whitesWeight) * (1.0 - blacksWeight) + max(0.0, (1.0 - sqrt(hsv.z))) * (1.0 - whitesWeight) * (1.0 - blacksWeight) * (1.0 - blacksWeight);
     if(neutralsCyan > 0.0)
         ca += c * neutralsCyan * neutralsWeight;
     else
         ca -= c * abs(neutralsCyan) * neutralsWeight;
     if(neutralsMagenta > 0.0)
         ma += m * neutralsMagenta * neutralsWeight;
     else
         ma -= m * abs(neutralsMagenta) * neutralsWeight;
     if(neutralsYellow > 0.0)
         ya += y * neutralsYellow * neutralsWeight;
     else
         ya -= y * abs(neutralsYellow) * neutralsWeight;
     

     
     
     c = (ca * (1.0 - ka) + ka);
     m = (ma* (1.0 - ka) + ka);
     y = (ya * (1.0 - ka) + ka);
     
     
     c = max(0.0, min(1.0, c));
     m = max(0.0, min(1.0, m));
     y = max(0.0, min(1.0, y));
     
     
     // Reds
     redsWeight *= hsv.z;
     if(redsBlack > 0.0){
         c -= (1.0 - c) * abs(redsBlack) * redsWeight;
         m += m * redsBlack * redsWeight;
         y += y * redsBlack * redsWeight;
     } else{
         c -= c * abs(redsBlack) * redsWeight;
         m -= m * abs(redsBlack) * redsWeight;
         y -= y * abs(redsBlack) * redsWeight;
     }
     
     // Yellows
     yellowsWeight *= hsv.z;
     if(yellowsBlack > 0.0){
         c += c * yellowsBlack * yellowsWeight;
         m += m * yellowsBlack * yellowsWeight;
         y += y * yellowsBlack * yellowsWeight;
     } else{
         c -= c * abs(yellowsBlack) * yellowsWeight * 0.9;
         m -= m * abs(yellowsBlack) * yellowsWeight * 0.9;
         y -= y * abs(yellowsBlack) * yellowsWeight * 0.9;
     }
     
     // Greens
     greensWeight *= hsv.z;
     if(greensBlack > 0.0){
         c += c * abs(greensBlack) * greensWeight;
         m += m * greensBlack * greensWeight;
         y += y * greensBlack * greensWeight;
     } else{
         c -= c * abs(greensBlack) * greensWeight * 0.8;
         m -= m * abs(greensBlack) * greensWeight * 0.8;
         y -= y * abs(greensBlack) * greensWeight * 0.8;
     }
     
     // Cyans
     cyansWeight *= hsv.z;
     if(cyansBlack > 0.0){
         c += c * abs(cyansBlack) * cyansWeight;
         m += m * cyansBlack * cyansWeight;
         y += y * cyansBlack * cyansWeight;
     } else{
         c -= c * abs(cyansBlack) * cyansWeight * 0.8;
         m -= m * abs(cyansBlack) * cyansWeight * 0.8;
         y -= y * abs(cyansBlack) * cyansWeight * 0.8;
     }
     
     // Blues
     bluesWeight *= hsv.z;
     if(bluesBlack > 0.0){
         c += c * abs(bluesBlack) * bluesWeight;
         m += m * bluesBlack * bluesWeight;
         y += y * bluesBlack * bluesWeight;
     } else{
         c -= c * abs(bluesBlack) * bluesWeight;
         m -= m * abs(bluesBlack) * bluesWeight;
         y -= y * abs(bluesBlack) * bluesWeight;
     }
     
          // Magentas
     magentasWeight *= hsv.z;
     if(magentasBlack > 0.0){
         c += c * abs(magentasBlack) * magentasWeight;
         m += m * magentasBlack * magentasWeight;
         y += y * magentasBlack * magentasWeight;
     } else{
         c -= c * abs(magentasBlack) * magentasWeight * 0.8;
         m -= m * abs(magentasBlack) * magentasWeight * 0.8;
         y -= y * abs(magentasBlack) * magentasWeight * 0.8;
     }
     
     

     // Whites
     if(whitesBlack > 0.0){
         c += c * abs(whitesBlack) * whitesWeight;
         m += m * whitesBlack * whitesWeight;
         y += y * whitesBlack * whitesWeight;
     } else{
         c -= c * abs(whitesBlack) * whitesWeight;
         m -= m * abs(whitesBlack) * whitesWeight;
         y -= y * abs(whitesBlack) * whitesWeight;
     }
     

     // Neutrals
     if(neutralsBlack > 0.0){
         c += c * abs(neutralsBlack) * neutralsWeight;
         m += m * neutralsBlack * neutralsWeight;
         y += y * neutralsBlack * neutralsWeight;
     } else{
         c -= c * abs(neutralsBlack) * neutralsWeight;
         m -= m * abs(neutralsBlack) * neutralsWeight;
         y -= y * abs(neutralsBlack) * neutralsWeight;
     }
     
     
     // Blacks
     if(blacksBlack > 0.0){
         c += c * abs(blacksBlack) * blacksWeight;
         m += m * blacksBlack * blacksWeight;
         y += y * blacksBlack * blacksWeight;
     } else{
         c -= c * abs(blacksBlack) * blacksWeight;
         m -= m * abs(blacksBlack) * blacksWeight;
         y -= y * abs(blacksBlack) * blacksWeight;

     }
     
     
     
     c = max(0.0, min(1.0, c));
     m = max(0.0, min(1.0, m));
     y = max(0.0, min(1.0, y));
     
     ra = (1.0 - c);
     ga = (1.0 - m);
     ba = (1.0 - y);
     
     
     // Check
     r = max(0.0, min(1.0, ra));
     g = max(0.0, min(1.0, ga));
     b = max(0.0, min(1.0, ba));

     pixel.r = r;
     pixel.g = g;
     pixel.b = b;
     
     // Save the result
     gl_FragColor = pixel;
 }
 );


#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageSelectiveColorFilterFragmentShaderString]))
    {
        return nil;
    }
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"redsCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"redsMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"redsYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"redsBlack"] program:filterProgram];
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"yellowsCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"yellowsMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"yellowsYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"yellowsBlack"] program:filterProgram];
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"greensCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"greensMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"greensYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"greensBlack"] program:filterProgram];
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"cyansCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"cyansMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"cyansYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"cyansBlack"] program:filterProgram];
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"bluesCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"bluesMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"bluesYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"bluesBlack"] program:filterProgram];
    return self;
}

- (void)setRedsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"redsCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"redsMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"redsYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"redsBlack"] program:filterProgram];
}
- (void)setYellowsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"yellowsCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"yellowsMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"yellowsYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"yellowsBlack"] program:filterProgram];
}
- (void)setGreensCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"greensCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"greensMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"greensYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"greensBlack"] program:filterProgram];
}
- (void)setCyansCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"cyansCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"cyansMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"cyansYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"cyansBlack"] program:filterProgram];
}
- (void)setBluesCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"bluesCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"bluesMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"bluesYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"bluesBlack"] program:filterProgram];
}
- (void)setMagentasCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"magentasCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"magentasMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"magentasYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"magentasBlack"] program:filterProgram];
}
- (void)setWhitesCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"whitesCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"whitesMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"whitesYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"whitesBlack"] program:filterProgram];
}
- (void)setNeutralsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"neutralsCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"neutralsMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"neutralsYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"neutralsBlack"] program:filterProgram];
}
- (void)setBlacksCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"blacksCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"blacksMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"blacksYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"blacksBlack"] program:filterProgram];
}
@end

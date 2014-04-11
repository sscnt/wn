#import "GPUImageClarityFilter.h"
#import "GPUImageFilter.h"
#import "GPUImageTwoInputFilter.h"
#import "GPUImageGaussianBlurFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageClarityMaskFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform highp float intensity;
 
 void main()
 {
     mediump vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec3 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2).rgb;
     
     mediump vec3 resultColor = vec3(sharpImageColor.rgb * intensity + blurredImageColor * (1.0 - intensity));
     
     if(sharpImageColor.r < resultColor.r){
         resultColor.r = sharpImageColor.r;
     }
     if(sharpImageColor.g < resultColor.g){
         resultColor.g = sharpImageColor.g;
     }
     if(sharpImageColor.b < resultColor.b){
         resultColor.b = sharpImageColor.b;
     }
     
     gl_FragColor = vec4(resultColor, sharpImageColor.a);
 }
 );
#else
NSString *const kGPUImageClarityMaskFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float intensity;
 
 void main()
 {
     vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     vec3 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2).rgb;
     
     vec3 resultColor = vec3(sharpImageColor.rgb * intensity + blurredImageColor * (1.0 - intensity));
     
     if(sharpImageColor.r < resultColor.r){
         resultColor.r = sharpImageColor.r;
     }
     if(sharpImageColor.g < resultColor.g){
         resultColor.g = sharpImageColor.g;
     }
     if(sharpImageColor.b < resultColor.b){
         resultColor.b = sharpImageColor.b;
     }
     
     gl_FragColor = vec4(resultColor, sharpImageColor.a);
 }
 );
#endif

@implementation GPUImageClarityFilter

@synthesize blurRadiusInPixels;
@synthesize intensity = _intensity;

- (id)init;
{
    if (!(self = [super init]))
    {
		return nil;
    }
    
    // First pass: apply a variable Gaussian blur
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [self addFilter:blurFilter];
    
    // Second pass: combine the blurred image with the original sharp one
    unsharpMaskFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kGPUImageClarityMaskFragmentShaderString];
    [self addFilter:unsharpMaskFilter];
    
    // Texture location 0 needs to be the sharp image for both the blur and the second stage processing
    [blurFilter addTarget:unsharpMaskFilter atTextureLocation:1];
    
    self.initialFilters = [NSArray arrayWithObjects:blurFilter, unsharpMaskFilter, nil];
    self.terminalFilter = unsharpMaskFilter;
    
    self.intensity = 1.0;
    self.blurRadiusInPixels = 4.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setBlurRadiusInPixels:(CGFloat)newValue;
{
    blurFilter.blurRadiusInPixels = newValue;
}

- (CGFloat)blurRadiusInPixels;
{
    return blurFilter.blurRadiusInPixels;
}

- (void)setIntensity:(CGFloat)newValue;
{
    _intensity = newValue;
    [unsharpMaskFilter setFloat:newValue forUniformName:@"intensity"];
}

@end
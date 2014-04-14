//
//  HomeViewController.m
//  winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //// Background Image
    _bgView = [[UIHomeBgView alloc] initWithFrame:self.view.bounds];
    _bgView.type = UIHomeBgViewBgTypeBg;
    [self.view addSubview:_bgView];
    
    //// Button
    CGFloat buttonDiam = 100.0f;
    _photosButton = [[UIHomeSourceButton alloc] initWithFrame:CGRectMake(40.0f, [UIScreen height] - 176.0f, buttonDiam, buttonDiam)];
    _photosButton.iconType = UIHomeSourceButtonIconTypePhotos;
    [_photosButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_photosButton];
    _cameraButton = [[UIHomeSourceButton alloc] initWithFrame:CGRectMake([_photosButton right] + 40.0f, [UIScreen height] - 176.0f, buttonDiam, buttonDiam)];
    _cameraButton.iconType = UIHomeSourceButtonIconTypeCamera;
    [_cameraButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraButton];
    
    
    //// Splash Image
    _splashView = [[UIHomeBgView alloc] initWithFrame:self.view.bounds];
    _splashView.type = UIHomeBgViewBgTypeSplash;
    [self.view addSubview:_splashView];;
    
    
    //// Animate
    __block UIHomeBgView* _s = _splashView;
    [UIView animateWithDuration:0.30f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        _s.alpha = 0.0f;
    } completion:^(BOOL finished){
        [_s removeFromSuperview];
        _s = nil;
    }];

}

#pragma mark button events

- (void)didPressButton:(UIHomeSourceButton *)sender
{
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusNotDetermined){
        
    } else if (status == ALAuthorizationStatusRestricted){
        [self showErrorAlertWithMessage:@"no_access_due_to_parental_controls"];
        return;
    } else if (status == ALAuthorizationStatusDenied){
        [self showErrorAlertWithMessage:@"no_access_to_your_photos"];
        return;
    } else if (status == ALAuthorizationStatusAuthorized){
        
    }
    
    
    switch (sender.iconType) {
        case UIHomeSourceButtonIconTypeCamera:
            [self didPressCameraButton];
            break;
        case UIHomeSourceButtonIconTypePhotos:
            [self didPressPhotosButton];
            break;
        default:
            break;
    }
}

- (void)didPressCameraButton
{
    BOOL isCameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(!isCameraAvailable){
        [self showErrorAlertWithMessage:@"Camera is not available."];
        return;
    }
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    pickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)didPressPhotosButton
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark  delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(imageOriginal){
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(imageOriginal, nil, nil, nil);
        }
        [self goToEffectsViewControllerWithImage:imageOriginal];
    } else {
        __weak HomeViewController* _self = self;
        NSURL* imageurl = [info objectForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:imageurl
                 resultBlock: ^(ALAsset *asset)
         {
             ALAssetRepresentation *representation;
             representation = [asset defaultRepresentation];
             UIImage* imageOriginal = [[UIImage alloc] initWithCGImage:representation.fullResolutionImage];
             [_self goToEffectsViewControllerWithImage:imageOriginal];
         }
                failureBlock:^(NSError *error)
         {
         }
         ];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


- (void)goToEffectsViewControllerWithImage:(UIImage *)image
{
    [Processor reset];
    if (image.imageOrientation == UIImageOrientationUp){
        
    }else{
        CGAffineTransform transform = CGAffineTransformIdentity;
        switch (image.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, image.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                break;
        }
        switch (image.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationDown:
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage), 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (image.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                // Grr...
                CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
                break;
        }
        
        // And now we just create a new UIImage from the drawing context
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        image = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
    }
    
    
    CGFloat maxLength = 4096.0f;
    if([UIDevice isiPad]){
        
    }else{
        if([UIDevice underIPhone5s]){
            if([UIDevice underIPhone5]){
                maxLength = MAX_IMAGE_LENGTH_FOR_IPHONE_4S;
            }else{
                maxLength = MAX_IMAGE_LENGTH_FOR_IPHONE_5;
            }
        }else{
            
        }
    }
    
    if(image.size.width > maxLength){
        @autoreleasepool {
            CGFloat height = maxLength / image.size.width * image.size.height;
            image = [image resizedImage:CGSizeMake(maxLength, height) interpolationQuality:kCGInterpolationHigh];
        }
    }
    if(image.size.height > maxLength){
        @autoreleasepool {
            CGFloat width = maxLength / image.size.height * image.size.width;
            image = [image resizedImage:CGSizeMake(width, maxLength) interpolationQuality:kCGInterpolationHigh];
        }
    }
    
    [CurrentImage instance].originalImageSize = image.size;

    
    //// Present
    __block EditorViewController* controller = [[EditorViewController alloc] init];
    controller.modalTransitionStyle = UIModalPresentationPageSheet;
    [self.navigationController pushViewController:controller animated:NO];
    
    __block UIImage* originalImage = image;
    
    __block NSInteger errorCode = 1;
    
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    dispatch_async(q_global, ^{
        @autoreleasepool {
            //// Crop snow
            UIImage* snowImage = [[UIImage imageNamed:@"snow-4096-cryst.png"] croppedImage:CGRectMake(0.0f, 0.0f, [CurrentImage originalImageSize].width, [CurrentImage originalImageSize].height)];
            [CurrentImage saveSnowImage:snowImage];
            
            //// Resize snow
            snowImage = [snowImage resizedImage:[CurrentImage editorImageSize] interpolationQuality:kCGInterpolationHigh];
            [CurrentImage saveSnowImageForEditor:snowImage];
            
            //// Save to home dir
            if([CurrentImage saveOriginalImage:originalImage]){
                //// for editor image
                UIImage* imageForEditor = [originalImage resizedImage:[CurrentImage editorImageSize] interpolationQuality:kCGInterpolationHigh];
                if([CurrentImage saveResizedEditorImage:imageForEditor]){
                    //// Detect faces
                    NSDictionary *options = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
                    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
                    CIImage *ciImage = [[CIImage alloc] initWithCGImage:imageForEditor.CGImage];
                    NSDictionary *imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:CIDetectorImageOrientation];
                    NSArray *array = [detector featuresInImage:ciImage options:imageOptions];
                    
                    if([array count] > 0){
                        LOG(@"Face detected!");
                        [Processor instance].faceDetected = YES;
                    }
                    errorCode = 0;
                }
            }
        }
        dispatch_async(q_main, ^{
            if (errorCode == 0) {
                [controller didFinishResizing];
            }else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Storage is full.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
                [alert show];
            }
        });
    });
}




- (void)showErrorAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:NSLocalizedString(message, nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

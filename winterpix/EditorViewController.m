//
//  EditorViewController.m
//  Winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "EditorViewController.h"

@interface EditorViewController ()

@end

@implementation EditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark ready

- (void)didFinishResizing
{
    [self test];
}

- (void)test
{
    UIImage* image = [CurrentImage originalImage];
    GPUEffectColdWinter* effect = [[GPUEffectColdWinter alloc] init];
    effect.imageToProcess = image;
    image = [effect process];
    UIImageView* view = [[UIImageView alloc] initWithImage:image];
    view.frame = CGRectMake(0.0f, 0.0f, [UIScreen width], [UIScreen width] / image.size.width * image.size.height);
    [self.view addSubview:view];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

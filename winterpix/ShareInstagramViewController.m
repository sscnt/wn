//
//  ShareInstagramViewController.m
//  Vintage
//
//  Created by SSC on 2014/04/02.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "ShareInstagramViewController.h"

@interface ShareInstagramViewController ()

@end

@implementation ShareInstagramViewController


- (void)openInstagram {
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/image.igo"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    self.interactionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.interactionController.UTI = @"com.instagram.exclusivegram";
    self.interactionController.delegate = self;
    
    BOOL present = [self.interactionController presentOpenInMenuFromRect:self.view.frame
                                                                  inView:self.view
                                                                animated:YES];
    if (!present) {
        [self closeView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self openInstagram];
}

- (void)closeView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.interactionController.delegate = nil;
}

- (void)setImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.99f);
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/image.igo"];
    [imageData writeToFile:filePath atomically:YES];
}


#pragma mark - UIDocumentInteractionControllerDelegate

- (void)documentInteractionController:(UIDocumentInteractionController *)controller
        willBeginSendingToApplication:(NSString *)application
{
    
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller
           didEndSendingToApplication:(NSString *)application
{
    [self closeView];
}

- (void) documentInteractionControllerDidDismissOpenInMenu: (UIDocumentInteractionController *) controller
{
    // キャンセルで閉じたとき
    [self closeView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

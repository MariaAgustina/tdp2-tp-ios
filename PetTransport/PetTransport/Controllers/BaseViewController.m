//
//  BaseViewController.m
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property UIActivityIndicatorView *activityView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupActivityIndicatorView];
}

- (void)setupActivityIndicatorView{
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityView.color = [UIColor whiteColor];
    self.activityView.backgroundColor = [UIColor blackColor];
    
    CGRect newFrame = self.activityView.frame;
    CGFloat size = 80;
    
    newFrame.size.width = size;
    newFrame.size.height = size;
    [self.activityView setFrame:newFrame];
    
    self.activityView.layer.cornerRadius = 10;
    self.activityView.center= CGPointMake(self.view.center.x, self.view.center.y-size/2);

}

- (void)showLoading{
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    [self.view bringSubviewToFront:self.activityView];
}

- (void)hideLoading{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
}

@end

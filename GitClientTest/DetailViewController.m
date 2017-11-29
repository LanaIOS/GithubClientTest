//
//  DetailViewController.m
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView {
    
    if (self.detailItem) {
        [self.logoImage sd_setImageWithURL: [NSURL URLWithString:self.detailItem.avatarURL] placeholderImage:nil];
        self.loginLabel.text = self.detailItem.login;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(RepositoryMO *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        
        [self configureView];
    }
}


@end

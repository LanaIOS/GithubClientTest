//
//  DetailViewController.h
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepositoryMO+CoreDataClass.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) RepositoryMO *detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@end


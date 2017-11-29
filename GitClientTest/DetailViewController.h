//
//  DetailViewController.h
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GitClientTest+CoreDataModel.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Event *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end


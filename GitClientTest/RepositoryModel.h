//
//  RepositoryModel.h
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "UserDetailsModel.h"

@interface RepositoryModel : JSONModel

@property (nonatomic) int id;
@property (nonatomic) NSString *full_name;
@property (nonatomic) UserDetailsModel *owner;

@end

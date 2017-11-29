//
//  UserDetailsModel.h
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface UserDetailsModel : JSONModel

@property (nonatomic) NSString *followers_url;
@property (nonatomic) NSString *login;
@property (nonatomic) NSString *avatar_url;

@end

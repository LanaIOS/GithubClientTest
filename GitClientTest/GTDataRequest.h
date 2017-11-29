//
//  GTDataRequest.h
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import <Foundation/Foundation.h>

// completion blocks
typedef void(^GTDataCompletion)(NSData *data);

@interface GTDataRequest : NSObject

- (void)getElementsFromBorder:(int)border completition:(GTDataCompletion)completion;

@end


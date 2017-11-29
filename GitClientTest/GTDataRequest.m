//
//  GTDataModel.m
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import "GTDataRequest.h"

@implementation GTDataRequest

- (void) getElementsFromBorder:(int)border completition:(GTDataCompletion)completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *URLString = [NSString stringWithFormat:@"https://api.github.com/repositories?since=%d",border];
        NSURL *url = [NSURL URLWithString:URLString];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (HTTPStatusCode != 200) {
                    NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                }
                
                if (completion) {
                    completion(data);
                }
            }
            
        }];
        [task resume];
    });
    
}


@end

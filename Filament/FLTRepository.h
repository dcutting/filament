//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTIntegratorConfiguration.h"

typedef void(^FLTRepositoryCompletionHandler)(FLTIntegratorConfiguration *configuration);

@interface FLTRepository : NSObject

- (instancetype)initWithGitURL:(NSURL *)gitURL branchName:(NSString *)branchName;
- (void)checkoutWithCompletionHandler:(FLTRepositoryCompletionHandler)completionHandler;

@end

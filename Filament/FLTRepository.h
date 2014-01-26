//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTIntegratorConfiguration.h"
#import "NSTaskFactory.h"

typedef void(^FLTRepositoryCompletionHandler)(FLTIntegratorConfiguration *configuration);

@interface FLTRepository : NSObject

- (instancetype)initWithGitPath:(NSString *)gitPath taskFactory:(NSTaskFactory *)taskFactory;
- (void)checkoutGitURL:(NSURL *)gitURL branchName:(NSString *)branchName toPath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler;

@end

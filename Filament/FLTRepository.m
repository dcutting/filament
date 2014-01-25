//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTRepository.h"

@implementation FLTRepository

- (instancetype)initWithGitURL:(NSURL *)gitURL branchName:(NSString *)branchName {

    self = [super init];
    return self;
}

- (void)checkoutWithCompletionHandler:(FLTRepositoryCompletionHandler)completionHandler {
    
    
}

@end

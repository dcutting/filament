//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTJob.h"

@implementation FLTJob

- (instancetype)init {
    NSAssert(NO, @"Cannot use default constructor.");
    return nil;
}

- (instancetype)initWithGitURL:(NSURL *)gitURL branchName:(NSString *)branchName {
    self = [super init];
    return self;
}

@end

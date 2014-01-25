//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

@interface FLTJob : NSObject

- (instancetype)initWithGitURL:(NSURL *)gitURL branchName:(NSString *)branchName;

@end

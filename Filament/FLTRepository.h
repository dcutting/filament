//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTFileReader.h"
#import "FLTIntegratorConfiguration.h"
#import "FLTJSONSerialiser.h"
#import "NSTaskFactory.h"

extern NSString *FLTRepositoryErrorDomain;

typedef NS_ENUM(NSInteger, FLTRepositoryErrorCode) {
    FLTRepositoryErrorCodeToolFailure,
    FLTRepositoryErrorCodeBadExitCode,
    FLTRepositoryErrorCodeMissingConfiguration,
    FLTRepositoryErrorCodeCorruptConfiguration
};

typedef void(^FLTRepositoryCompletionHandler)(FLTIntegratorConfiguration *configuration, NSError *error);

@interface FLTRepository : NSObject

- (instancetype)initWithGitPath:(NSString *)gitPath taskFactory:(NSTaskFactory *)taskFactory fileReader:(FLTFileReader *)fileReader jsonSerialiser:(FLTJSONSerialiser *)jsonSerialiser;
- (void)checkoutGitURL:(NSURL *)gitURL branchName:(NSString *)branchName toPath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler;

@end

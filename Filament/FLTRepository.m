//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTRepository.h"

@interface FLTRepository ()

@property (nonatomic, copy) NSString *gitPath;
@property (nonatomic, strong) NSTaskFactory *taskFactory;

@end

@implementation FLTRepository

- (instancetype)initWithGitPath:(NSString *)gitPath taskFactory:(NSTaskFactory *)taskFactory {
    
    self = [super init];
    if (self) {
        _gitPath = gitPath;
        _taskFactory = taskFactory;
    }
    return self;
}

- (void)checkoutGitURL:(NSURL *)gitURL branchName:(NSString *)branchName toPath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler {
    
    NSTask *cloneTask = [self.taskFactory task];
    [cloneTask setLaunchPath:self.gitPath];
    [cloneTask setArguments:@[ @"clone", [gitURL absoluteString], clonePath ]];
    cloneTask.terminationHandler = ^(NSTask *task) {
        [self checkoutBranch:branchName atPath:clonePath completionHandler:completionHandler];
    };
    [cloneTask launch];
}

- (void)checkoutBranch:(NSString *)branchName atPath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler {

    NSTask *checkoutTask = [self.taskFactory task];
    [checkoutTask setCurrentDirectoryPath:clonePath];
    [checkoutTask setLaunchPath:self.gitPath];
    [checkoutTask setArguments:@[ @"checkout", branchName ]];
    [checkoutTask launch];
    
    if (completionHandler) {
        completionHandler(nil);
    }
}

@end

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
    
    NSTask *task = [self.taskFactory task];
    [task setLaunchPath:self.gitPath];
    [task setArguments:@[ @"clone", [gitURL absoluteString], clonePath ]];
    [task launch];
    
    if (completionHandler) {
        completionHandler(nil);
    }
}

@end

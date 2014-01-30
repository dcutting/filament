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
    [cloneTask setArguments:@[
                              @"clone",
                              @"--branch", branchName,
                              [gitURL absoluteString],
                              clonePath
                              ]];
    cloneTask.terminationHandler = ^(NSTask *task) {
        [self parseConfigurationAtClonePath:clonePath completionHandler:completionHandler];
    };
    [cloneTask launch];
}

- (void)parseConfigurationAtClonePath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler {
    
    NSString *configurationPath = [NSString pathWithComponents:@[ clonePath, @".filament" ]];

    NSData *data = [NSData dataWithContentsOfFile:configurationPath];
        
    NSDictionary *jsonConfiguration = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    FLTIntegratorConfiguration *configuration = [FLTIntegratorConfiguration new];
    configuration.resultsPath = [NSString pathWithComponents:@[ clonePath, @"build.json" ]];
    configuration.rootPath = clonePath;
    configuration.workspace = jsonConfiguration[@"workspace"];
    configuration.scheme = jsonConfiguration[@"scheme"];
    
    if (completionHandler) {
        completionHandler(configuration);
    }
}

@end

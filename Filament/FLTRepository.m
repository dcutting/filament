//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTRepository.h"

@class FLTRepositoryTests;

NSString *FLTRepositoryErrorDomain = @"FLTRepositoryErrorDomain";

@interface FLTRepository ()

@property (nonatomic, copy) NSString *gitPath;
@property (nonatomic, strong) NSTaskFactory *taskFactory;
@property (nonatomic, strong) FLTFileReader *fileReader;
@property (nonatomic, strong) FLTJSONSerialiser *jsonSerialiser;

@end

@implementation FLTRepository

- (instancetype)initWithGitPath:(NSString *)gitPath taskFactory:(NSTaskFactory *)taskFactory fileReader:(FLTFileReader *)fileReader jsonSerialiser:(FLTJSONSerialiser *)jsonSerialiser {

    self = [super init];
    if (self) {
        _gitPath = gitPath;
        _taskFactory = taskFactory;
        _fileReader = fileReader;
        _jsonSerialiser = jsonSerialiser;
    }
    return self;
}

- (void)checkoutGitURL:(NSURL *)gitURL branchName:(NSString *)branchName toPath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler {
    
    NSTask *task = [self taskForGitURL:gitURL branchName:branchName clonePath:clonePath];
    
    task.terminationHandler = ^(NSTask *task) {
        [self handleTerminatedTask:task clonePath:clonePath completionHandler:completionHandler];
    };

    @try {
        [task launch];
    } @catch (NSException *exception) {
        [self callCompletionHandler:completionHandler errorCode:FLTRepositoryErrorCodeToolFailure];
    }
}

- (NSTask *)taskForGitURL:(NSURL *)gitURL branchName:(NSString *)branchName clonePath:(NSString *)clonePath {
    
    NSTask *cloneTask = [self.taskFactory task];
    
    [cloneTask setLaunchPath:self.gitPath];
    [cloneTask setArguments:@[ @"clone", @"--branch", branchName, [gitURL absoluteString], clonePath ]];
    
    return cloneTask;
}

- (void)handleTerminatedTask:(NSTask *)task clonePath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler {
    
    if (NSTaskTerminationReasonExit == task.terminationReason) {
        if (0 == task.terminationStatus) {
            [self parseConfigurationAtClonePath:clonePath completionHandler:completionHandler];
        } else {
            [self callCompletionHandler:completionHandler errorCode:FLTRepositoryErrorCodeBadExitCode];
        }
    } else {
        [self callCompletionHandler:completionHandler errorCode:FLTRepositoryErrorCodeToolFailure];
    }
}

- (void)parseConfigurationAtClonePath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler {
    
    NSString *configurationPath = [NSString pathWithComponents:@[ clonePath, @".filament" ]];
    NSData *data = [self.fileReader dataWithContentsOfFile:configurationPath];
    
    if (data) {
        [self parseData:data clonePath:clonePath completionHandler:completionHandler];
    } else {
        [self callCompletionHandler:completionHandler errorCode:FLTRepositoryErrorCodeMissingConfiguration];
    }
}

- (void)parseData:(NSData *)data clonePath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler {
    
    NSDictionary *jsonDictionary = [self.jsonSerialiser JSONObjectWithData:data];
    
    if (jsonDictionary) {
        [self parseJSONDictionary:jsonDictionary clonePath:clonePath completionHandler:completionHandler];
    } else {
        [self callCompletionHandler:completionHandler errorCode:FLTRepositoryErrorCodeCorruptConfiguration];
    }
}

- (void)parseJSONDictionary:(NSDictionary *)jsonDictionary clonePath:(NSString *)clonePath completionHandler:(FLTRepositoryCompletionHandler)completionHandler {

    FLTIntegratorConfiguration *configuration = [FLTIntegratorConfiguration new];
    
    configuration.resultsPath = [NSString pathWithComponents:@[ clonePath, @"build.json" ]];
    configuration.rootPath = clonePath;
    configuration.workspace = jsonDictionary[@"workspace"];
    configuration.scheme = jsonDictionary[@"scheme"];
    
    [self callCompletionHandler:completionHandler configuration:configuration error:nil];
}

- (void)callCompletionHandler:(FLTRepositoryCompletionHandler)completionHandler errorCode:(NSInteger)errorCode {
    
    NSError *error = [NSError errorWithDomain:FLTRepositoryErrorDomain code:errorCode userInfo:nil];
    [self callCompletionHandler:completionHandler configuration:nil error:error];
}

- (void)callCompletionHandler:(FLTRepositoryCompletionHandler)completionHandler configuration:(FLTIntegratorConfiguration *)configuration error:(NSError *)error {
    
    if (completionHandler) {
        completionHandler(configuration, error);
    }
}

@end

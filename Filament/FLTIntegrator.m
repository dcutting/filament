//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegrator.h"

@interface FLTIntegrator ()

@property (nonatomic, copy) NSString *xctoolPath;
@property (nonatomic, strong) NSTaskFactory *taskFactory;

@end

@implementation FLTIntegrator

- (instancetype)initWithXctoolPath:(NSString *)xctoolPath taskFactory:(NSTaskFactory *)taskFactory {

    self = [super init];
    if (self) {
        _xctoolPath = xctoolPath;
        _taskFactory = taskFactory;
    }
    return self;
}

- (void)integrateConfiguration:(FLTIntegratorConfiguration *)configuration completionHandler:(FLTIntegratorCompletionHandler)completionHandler {

    if (!configuration) {
        [self callCompletionHandler:completionHandler];
        return;
    }
    
    NSTask *task = [self.taskFactory task];
    [task setCurrentDirectoryPath:configuration.rootPath];
    [task setLaunchPath:self.xctoolPath];
    [task setArguments:@[
                         @"-workspace", configuration.workspace,
                         @"-scheme", configuration.scheme,
                         @"-sdk", @"iphonesimulator",
                         @"-reporter", @"json-stream",
                         @"clean", @"analyze", @"test"
                         ]];
    [task launch];
}

- (void) callCompletionHandler:(FLTIntegratorCompletionHandler)completionHandler {
    
    if (completionHandler) {
        completionHandler(nil);
    }
}

@end

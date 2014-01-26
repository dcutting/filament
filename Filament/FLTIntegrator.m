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

    if (configuration) {
        [self launchBuildWithConfiguration:configuration completionHandler:completionHandler];
    } else {
        [self callCompletionHandler:completionHandler integrationReport:nil];
    }
}

- (void)launchBuildWithConfiguration:(FLTIntegratorConfiguration *)configuration completionHandler:(FLTIntegratorCompletionHandler)completionHandler {
    
    NSTask *task = [self.taskFactory task];
    [task setCurrentDirectoryPath:configuration.rootPath];
    [task setLaunchPath:self.xctoolPath];
    [task setArguments:@[
                         @"-workspace", configuration.workspace,
                         @"-scheme", configuration.scheme,
                         @"-sdk", @"iphonesimulator",
                         @"-reporter", [NSString stringWithFormat:@"json-stream:%@", configuration.resultsPath],
                         @"clean", @"analyze", @"test"
                         ]];
    task.terminationHandler = ^(NSTask *task) {

        FLTIntegrationReport *report = [FLTIntegrationReport new];
        report.status = FLTIntegrationReportStatusFailure;

        [self callCompletionHandler:completionHandler integrationReport:report];
    };
    [task launch];
}

- (void) callCompletionHandler:(FLTIntegratorCompletionHandler)completionHandler integrationReport:(FLTIntegrationReport *)report {
    
    if (completionHandler) {
        completionHandler(report);
    }
}

@end

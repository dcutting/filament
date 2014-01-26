//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegrator.h"

@interface FLTIntegrator ()

@property (nonatomic, copy) NSString *xctoolPath;
@property (nonatomic, strong) NSTaskFactory *taskFactory;
@property (nonatomic, strong) FLTIntegrationReportGenerator *integrationReportGenerator;

@end

@implementation FLTIntegrator

- (instancetype)initWithXctoolPath:(NSString *)xctoolPath taskFactory:(NSTaskFactory *)taskFactory integrationReportGenerator:(FLTIntegrationReportGenerator *)integrationReportGenerator {

    self = [super init];
    if (self) {
        _xctoolPath = xctoolPath;
        _taskFactory = taskFactory;
        _integrationReportGenerator = integrationReportGenerator;
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
                         @"clean", @"build", @"analyze", @"test"
                         ]];
    task.terminationHandler = ^(NSTask *task) {
        [self processBuildResultsAtPath:configuration.resultsPath completionHandler:completionHandler];
    };
    
    [task launch];
}

- (void)processBuildResultsAtPath:(NSString *)path completionHandler:(FLTIntegratorCompletionHandler)completionHandler {
    
    NSString *output = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    FLTIntegrationReport *report = [self.integrationReportGenerator reportWithBuildOutput:output];
    
    [self callCompletionHandler:completionHandler integrationReport:report];
}

- (void) callCompletionHandler:(FLTIntegratorCompletionHandler)completionHandler integrationReport:(FLTIntegrationReport *)report {
    
    if (completionHandler) {
        completionHandler(report);
    }
}

@end

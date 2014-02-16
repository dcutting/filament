//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <OCMock/OCMock.h>

#import "FLTAsyncXCTestCase.h"
#import "FLTIntegration.h"

static NSString *XctoolPath = @"/path/to/xctool";

static NSString *ResultsPath = @"/path/to/results";
static NSString *RootPath = @"/the/root/path";
static NSString *Workspace = @"MyWorkspace.xcworkspace";
static NSString *Scheme = @"MyScheme";

@interface FLTIntegratorTests : FLTAsyncXCTestCase

@property (nonatomic, strong) FLTIntegrator *integrator;
@property (nonatomic, strong) id mockTaskFactory;
@property (nonatomic, strong) id mockTask;
@property (nonatomic, strong) id mockIntegrationReportGenerator;
@property (nonatomic, strong) id mockFileReader;
@property (nonatomic, strong) FLTIntegratorConfiguration *dummyConfiguration;

@end

@implementation FLTIntegratorTests

- (void)setUp {
    
    [super setUp];
    
    self.mockTaskFactory = [OCMockObject niceMockForClass:[NSTaskFactory class]];
    self.mockTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[[self.mockTaskFactory stub] andReturn:self.mockTask] task];
    
    self.mockIntegrationReportGenerator = [OCMockObject niceMockForClass:[FLTIntegrationReportGenerator class]];
    
    self.mockFileReader = [OCMockObject niceMockForClass:[FLTFileReader class]];
    
    self.integrator = [[FLTIntegrator alloc] initWithXctoolPath:XctoolPath taskFactory:self.mockTaskFactory fileReader:self.mockFileReader integrationReportGenerator:self.mockIntegrationReportGenerator];
    
    self.dummyConfiguration = [FLTIntegratorConfiguration new];
    self.dummyConfiguration.resultsPath = ResultsPath;
    self.dummyConfiguration.rootPath = RootPath;
    self.dummyConfiguration.workspace = Workspace;
    self.dummyConfiguration.scheme = Scheme;
}

- (void)testIntegrateConfiguration_nilConfiguration_nilResult {
    
    [self.integrator integrateConfiguration:nil completionHandler:^(FLTIntegrationReport *report) {
        
        XCTAssertNil(report, @"Expected nil report.");

        [self signalCompletion];
    }];

    [self assertCompletion];
}

- (void)testIntegrateConfiguration_validConfiguration_launchesBuildTask {
    
    NSArray *arguments = @[
                           @"-workspace", Workspace,
                           @"-scheme", Scheme,
                           @"-sdk", @"iphonesimulator",
                           @"-reporter", [NSString stringWithFormat:@"json-stream:%@", ResultsPath],
                           @"clean", @"build"
                           ];
    
    [[self.mockTask expect] setCurrentDirectoryPath:RootPath];
    [[self.mockTask expect] setLaunchPath:XctoolPath];
    [[self.mockTask expect] setArguments:arguments];
    [[self.mockTask expect] launch];
    
    [self.integrator integrateConfiguration:self.dummyConfiguration completionHandler:nil];
    
    [self.mockTask verify];
}

- (void)testIntegrateConfiguration_launchesBuildTask_doesNotCallCompletionHandlerIfTaskDoesNotComplete {
    
    [self.integrator integrateConfiguration:self.dummyConfiguration completionHandler:^(FLTIntegrationReport *report) {
        
        [self signalCompletion];
    }];
    
    [self assertNoCompletion];
}

- (void)testIntegrateConfiguration_launchesBuildTask_callsCompletionHandlerWhenTaskCompletes {
    
    __block void (^terminationHandler)(NSTask *);
    [[[self.mockTask stub] andDo:^(NSInvocation *invocation) {
        void (^block)(NSTask *);
        [invocation getArgument:&block atIndex:2];
        terminationHandler = block;
    }] setTerminationHandler:[OCMArg any]];
    
    [self.integrator integrateConfiguration:self.dummyConfiguration completionHandler:^(FLTIntegrationReport *report) {
        
        [self signalCompletion];
    }];
    
    terminationHandler(self.mockTask);
    [self assertCompletion];
}

- (void)testIntegrateConfiguration_buildTaskCompletes_generatesReport {
    
    __block void (^terminationHandler)(NSTask *);
    [[[self.mockTask stub] andDo:^(NSInvocation *invocation) {
        void (^block)(NSTask *);
        [invocation getArgument:&block atIndex:2];
        terminationHandler = block;
    }] setTerminationHandler:[OCMArg any]];
    
    [self.integrator integrateConfiguration:self.dummyConfiguration completionHandler:nil];

    NSString *buildOutput = @"builded";
    
    [[[self.mockFileReader stub] andReturn:buildOutput] stringWithContentsOfFile:[OCMArg any]];

    [[self.mockIntegrationReportGenerator expect] reportWithBuildOutput:buildOutput];
    
    terminationHandler(self.mockTask);
    
    [self.mockIntegrationReportGenerator verify];
}

- (void)testIntegrateConfiguration_buildTaskCompletes_completionHandlerGivenGeneratedReport {
    
    __block void (^terminationHandler)(NSTask *);
    [[[self.mockTask stub] andDo:^(NSInvocation *invocation) {
        void (^block)(NSTask *);
        [invocation getArgument:&block atIndex:2];
        terminationHandler = block;
    }] setTerminationHandler:[OCMArg any]];
    
    FLTIntegrationReport *dummyReport = [FLTIntegrationReport new];

    [[[self.mockIntegrationReportGenerator stub] andReturn:dummyReport] reportWithBuildOutput:[OCMArg any]];
    
    [self.integrator integrateConfiguration:self.dummyConfiguration completionHandler:^(FLTIntegrationReport *report) {
        
        XCTAssertEqualObjects(dummyReport, report, @"Completion handler was not given generated report.");
        
        [self signalCompletion];
    }];
    
    terminationHandler(self.mockTask);
    
    [self.mockIntegrationReportGenerator verify];
}

@end

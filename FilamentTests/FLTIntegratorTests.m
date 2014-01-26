//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>
#import <TRVSMonitor/TRVSMonitor.h>

#import "FLTIntegration.h"

static NSTimeInterval AsyncTimeout = 1.0f;

static NSString *XctoolPath = @"/path/to/xctool";

static NSString *ResultsPath = @"/path/to/results";
static NSString *RootPath = @"/the/root/path";
static NSString *Workspace = @"MyWorkspace.xcworkspace";
static NSString *Scheme = @"MyScheme";

@interface FLTIntegratorTests : XCTestCase

@property (nonatomic, strong) FLTIntegrator *integrator;
@property (nonatomic, strong) id mockTaskFactory;
@property (nonatomic, strong) id mockTask;
@property (nonatomic, strong) id mockIntegrationReportGenerator;
@property (nonatomic, strong) FLTIntegratorConfiguration *dummyConfiguration;

@property (nonatomic, strong) TRVSMonitor *asyncMonitor;
@property (nonatomic, assign) BOOL didCompleteAsync;

@end

@implementation FLTIntegratorTests

- (void)setUp {
    
    self.mockTaskFactory = [OCMockObject niceMockForClass:[NSTaskFactory class]];
    self.mockTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[[self.mockTaskFactory stub] andReturn:self.mockTask] task];
    
    self.mockIntegrationReportGenerator = [OCMockObject niceMockForClass:[FLTIntegrationReportGenerator class]];
    
    self.integrator = [[FLTIntegrator alloc] initWithXctoolPath:XctoolPath taskFactory:self.mockTaskFactory integrationReportGenerator:self.mockIntegrationReportGenerator];
    
    self.dummyConfiguration = [FLTIntegratorConfiguration new];
    self.dummyConfiguration.resultsPath = ResultsPath;
    self.dummyConfiguration.rootPath = RootPath;
    self.dummyConfiguration.workspace = Workspace;
    self.dummyConfiguration.scheme = Scheme;
    
    self.asyncMonitor = [TRVSMonitor monitor];
    self.didCompleteAsync = NO;
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
                           @"clean", @"analyze", @"test"
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
    id mockString = [OCMockObject niceMockForClass:[NSString class]];
    [[[[mockString stub] andReturn:buildOutput] classMethod] stringWithContentsOfFile:ResultsPath encoding:NSUTF8StringEncoding error:(NSError __autoreleasing **)[OCMArg anyPointer]];

    [[self.mockIntegrationReportGenerator expect] reportWithBuildOutput:buildOutput];
    
    terminationHandler(self.mockTask);
    
    [self.mockIntegrationReportGenerator verify];
}

- (void)signalCompletion {
    
    self.didCompleteAsync = YES;
    [self.asyncMonitor signal];
}

- (void)assertCompletion {
    
    [self.asyncMonitor waitWithTimeout:AsyncTimeout];
    XCTAssertTrue(self.didCompleteAsync, @"");
}

- (void)assertNoCompletion {
    
    [self.asyncMonitor waitWithTimeout:AsyncTimeout];
    XCTAssertFalse(self.didCompleteAsync, @"");
}

@end

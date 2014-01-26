//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>
#import <TRVSMonitor/TRVSMonitor.h>

#import "FLTIntegration.h"

static NSTimeInterval AsyncTimeout = 1.0f;
static NSString *XctoolPath = @"/path/to/xctool";

@interface FLTIntegratorTests : XCTestCase

@property (nonatomic, strong) FLTIntegrator *integrator;
@property (nonatomic, strong) id mockTaskFactory;
@property (nonatomic, strong) id mockTask;

@property (nonatomic, strong) TRVSMonitor *asyncMonitor;
@property (nonatomic, assign) BOOL didCompleteAsync;

@end

@implementation FLTIntegratorTests

- (void)setUp {
    
    self.mockTaskFactory = [OCMockObject niceMockForClass:[NSTaskFactory class]];
    self.mockTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[[self.mockTaskFactory stub] andReturn:self.mockTask] task];
    
    self.integrator = [[FLTIntegrator alloc] initWithXctoolPath:XctoolPath taskFactory:self.mockTaskFactory];
    
    self.asyncMonitor = [TRVSMonitor monitor];
    self.didCompleteAsync = NO;
}

- (void)testIntegrateConfiguration_callsCompletionHandler {
    
    [self.integrator integrateConfiguration:nil completionHandler:^(FLTIntegrationReport *report) {
        
        [self signalCompletion];
    }];
    
    [self assertCompletion];
}

- (void)testIntegrateConfiguration_doesNotCallNilCompletionHandler {
   
    [self.integrator integrateConfiguration:nil completionHandler:nil];
}

- (void)testIntegrateConfiguration_nilConfiguration_nilResult {
    
    [self.integrator integrateConfiguration:nil completionHandler:^(FLTIntegrationReport *report) {
        
        XCTAssertNil(report, @"");

        [self signalCompletion];
    }];

    [self assertCompletion];
}

- (void)testIntegrateConfiguration_validConfiguration_launchesBuildTask {
    
    NSString *rootPath = @"/the/root/path";
    NSString *workspace = @"MyWorkspace.xcworkspace";
    NSString *scheme = @"MyScheme";
    
    NSArray *arguments = @[@"-workspace", workspace, @"-scheme", scheme, @"-sdk", @"iphonesimulator", @"-reporter", @"json-stream", @"clean", @"analyze", @"test"];
    
    FLTIntegratorConfiguration *configuration = [FLTIntegratorConfiguration new];
    configuration.rootPath = rootPath;
    configuration.workspace = workspace;
    configuration.scheme = scheme;
    
    [[self.mockTask expect] setCurrentDirectoryPath:rootPath];
    [[self.mockTask expect] setLaunchPath:XctoolPath];
    [[self.mockTask expect] setArguments:arguments];
    [[self.mockTask expect] launch];
    
    [self.integrator integrateConfiguration:configuration completionHandler:nil];
    
    [self.mockTask verify];
}

- (void)signalCompletion {
    
    self.didCompleteAsync = YES;
    [self.asyncMonitor signal];
}

- (void)assertCompletion {
    
    [self.asyncMonitor waitWithTimeout:AsyncTimeout];
    XCTAssertTrue(self.didCompleteAsync, @"");
}

@end

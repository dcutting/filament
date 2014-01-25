//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <TRVSMonitor/TRVSMonitor.h>

#import "FLTIntegration.h"

@interface FLTIntegratorTests : XCTestCase

@end

@implementation FLTIntegratorTests

- (void)testIntegrateConfiguration_callsCompletionHandler {
    
    FLTIntegrator *integrator = [FLTIntegrator new];
    
    __block BOOL didComplete = NO;
    TRVSMonitor *monitor = [TRVSMonitor monitor];

    [integrator integrateConfiguration:nil completionHandler:^(FLTIntegrationReport *report) {
        
        didComplete = YES;
        [monitor signal];
    }];
    
    [monitor waitWithTimeout:5.0f];
    
    XCTAssertTrue(didComplete, @"");
}

@end

//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <TRVSMonitor/TRVSMonitor.h>

@interface FLTAsyncXCTestCase : XCTestCase

- (void)signalCompletion;
- (void)assertCompletion;
- (void)assertNoCompletion;

@end

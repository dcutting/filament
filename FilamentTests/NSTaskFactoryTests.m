//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import "NSTaskFactory.h"

@interface NSTaskFactoryTests : XCTestCase

@end

@implementation NSTaskFactoryTests

- (void)testTask_returnsTask {
    
    NSTaskFactory *taskFactory = [NSTaskFactory new];
    id task = [taskFactory task];
    XCTAssertTrue([task isKindOfClass:[NSTask class]], @"");
}

@end

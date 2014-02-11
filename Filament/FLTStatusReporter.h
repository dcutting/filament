//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTJob.h"

@interface FLTStatusReporter : NSObject

- (NSUInteger)numberOfJobs;
- (FLTJob *)jobAtIndex:(NSUInteger)index;
- (void)addJob:(FLTJob *)job;

@end

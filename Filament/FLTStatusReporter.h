//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

@interface FLTStatusReporter : NSObject

- (NSUInteger)numberOfJobs;
- (id)jobAtIndex:(NSUInteger)index;

@end

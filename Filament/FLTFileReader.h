//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

@interface FLTFileReader : NSObject

- (NSData *)dataWithContentsOfFile:(NSString *)path;
- (NSString *)stringWithContentsOfFile:(NSString *)path;

@end

//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTFileReader.h"

@implementation FLTFileReader

- (NSData *)dataWithContentsOfFile:(NSString *)path {

    return [NSData dataWithContentsOfFile:path];
}

- (NSString *)stringWithContentsOfFile:(NSString *)path {
    
    return [NSString stringWithContentsOfFile:path usedEncoding:NULL error:NULL];
}

@end

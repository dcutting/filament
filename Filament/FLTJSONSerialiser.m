//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTJSONSerialiser.h"

@implementation FLTJSONSerialiser

- (id)JSONObjectWithData:(NSData *)data {
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}

@end

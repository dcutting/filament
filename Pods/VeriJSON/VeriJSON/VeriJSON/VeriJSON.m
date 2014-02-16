//  Copyright (c) 2012 Daniel Cutting. All rights reserved.

#import "VeriJSON.h"

NSString *VeriJSONErrorDomain = @"VeriJSONErrorDomain";

@implementation VeriJSON

- (BOOL)verifyJSON:(id)json pattern:(id)pattern {
    return [self verifyJSON:json pattern:pattern error:NULL];
}

- (BOOL)verifyJSON:(id)json pattern:(id)pattern error:(NSError **)error {
    if (!pattern) return YES;
    if (!json) return NO;
    
    NSMutableArray *patternStack = [NSMutableArray arrayWithObject:@""];    // Root element.
    BOOL valid = [self verifyValue:json pattern:pattern permitNull:NO patternStack:patternStack];
    if (!valid && error) {
        *error = [self buildErrorFromPatternStack:patternStack];
    }
    return valid;
}

- (BOOL)verifyValue:(id)value pattern:(id)pattern permitNull:(BOOL)permitNull patternStack:(NSMutableArray *)patternStack {
    if (permitNull && [value isKindOfClass:[NSNull class]]) return YES;

    if ([pattern isKindOfClass:[NSDictionary class]]) {
        return [self verifyObject:value pattern:pattern patternStack:patternStack];
    } else if ([pattern isKindOfClass:[NSArray class]]) {
        return [self verifyArray:value pattern:pattern patternStack:patternStack];
    }
    return [self verifyBaseValue:value pattern:pattern patternStack:patternStack];
}

- (BOOL)verifyObject:(NSDictionary *)object pattern:(NSDictionary *)objectPattern patternStack:(NSMutableArray *)patternStack {
    if (![object isKindOfClass:[NSDictionary class]]) return NO;
    __block BOOL valid = YES;
    [objectPattern enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, id attributePattern, BOOL *stop) {
        [patternStack addObject:attributeName];
        BOOL attributeValid = [self verifyObject:object attributeName:attributeName attributePattern:attributePattern patternStack:patternStack];
        if (attributeValid) {
            [patternStack removeLastObject];
        } else {
            valid = NO;
            *stop = YES;
        }
    }];
    return valid;
}
 
- (BOOL)verifyObject:(NSDictionary *)object attributeName:(NSString *)attributeName attributePattern:(id)attributePattern patternStack:(NSMutableArray *)patternStack {
    BOOL isOptional = [self isOptionalAttribute:attributeName];
    NSString *strippedAttributeName = [self strippedAttributeName:attributeName];
    id value = [object objectForKey:strippedAttributeName];
    if (value) {
        return [self verifyValue:value pattern:attributePattern permitNull:isOptional patternStack:patternStack];
    }
    return isOptional;
}

- (NSString *)strippedAttributeName:(NSString *)attributeName {
    if ([self isOptionalAttribute:attributeName]) {
        return [attributeName substringToIndex:[attributeName length] - 1];
    }
    return attributeName;
}

- (BOOL)isOptionalAttribute:(NSString *)attributeName {
    return [attributeName hasSuffix:@"?"];
}

- (BOOL)verifyArray:(NSArray *)array pattern:(NSArray *)arrayPattern patternStack:(NSMutableArray *)patternStack {
    if (![array isKindOfClass:[NSArray class]]) return NO;
    __block BOOL valid = YES;
    if ([arrayPattern count] == 0) {
        return [array count] == 0;
    }
    id valuePattern = [arrayPattern objectAtIndex:0];
    [array enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
        if (![self verifyValue:value pattern:valuePattern permitNull:NO patternStack:patternStack]) {
            valid = NO;
            *stop = YES;
        }
    }];
    return valid;
}

- (BOOL)verifyBaseValue:(id)value pattern:(id)pattern patternStack:(NSMutableArray *)patternStack {
    [patternStack addObject:pattern];
    
    BOOL valid = NO;

    if ([@"string" isEqualToString:pattern] || [pattern hasPrefix:@"string:"]) {
        valid = [self verifyString:value pattern:pattern];
    }
    if ([@"number" isEqualToString:pattern]) {
        valid = [value isKindOfClass:[NSNumber class]];
    }
    if ([@"bool" isEqualToString:pattern]) {
        valid = [value isKindOfClass:[NSNumber class]];
    }
    if ([@"url" isEqualToString:pattern]) {
        valid = [self verifyURL:value];
    }
    if ([@"url:http" isEqualToString:pattern]) {
        valid = [self verifyHTTPURL:value];
    }
    
    if (valid) {
        [patternStack removeLastObject];
    }
    return valid;
}

- (BOOL)verifyString:(NSString *)value pattern:(NSString *)pattern {
    if (![value isKindOfClass:[NSString class]]) return NO;
    NSArray *components = [pattern componentsSeparatedByString:@":"];
    if ([components count] > 1) {
        NSString *regexPattern = [components objectAtIndex:1];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:NULL];
        NSUInteger numMatches = [regex numberOfMatchesInString:value options:NSMatchingReportCompletion range:NSMakeRange(0, [value length])];
        return numMatches > 0;
    }
    return YES;
}

- (BOOL)verifyURL:(id)value {
    return nil != [self urlFromValue:value];
}

- (BOOL)verifyHTTPURL:(id)value {
    NSURL *url = [self urlFromValue:value];
    NSString *scheme = [[url scheme] lowercaseString];
    return [scheme isEqualToString:@"https"] || [scheme isEqualToString:@"http"];
}

- (NSURL *)urlFromValue:(id)value {
    if (![value isKindOfClass:[NSString class]]) return nil;
    NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (0 == [trimmedValue length]) return nil;
    return [NSURL URLWithString:value];
}

- (NSError *)buildErrorFromPatternStack:(NSArray *)patternStack {
    NSString *path = [self buildPathFromPatternStack:patternStack];
    NSString *localisedDescription = [NSString stringWithFormat:@"Invalid pattern %@", path];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:localisedDescription, NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:VeriJSONErrorDomain code:VeriJSONErrorCodeInvalidPattern userInfo:userInfo];
}

- (NSString *)buildPathFromPatternStack:(NSArray *)patternStack {
    return [patternStack componentsJoinedByString:@"."];
}

@end

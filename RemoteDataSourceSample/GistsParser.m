//
// Created by fbernardo on 27/08/14.
//
//

#import "GistsParser.h"
#import "Gist.h"


@implementation GistsParser

- (NSArray *)parseData:(NSData *)data error:(NSError **)error pageValue:(inout NSUInteger *)pageValue {
    NSError *err;

    id o = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];

    if (err) {
        if (error) *error = err;
        return nil;
    }

    if (![o isKindOfClass:[NSArray class]]) {
        if (error) *error = [NSError errorWithDomain:@"RemoveDataSourceParsingErrorDomain" code:0 userInfo:nil];
        return nil;
    }

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[o count]];

    for (id dict in o) {
        if (![dict isKindOfClass:[NSDictionary class]]) continue;
        id obj = [[Gist alloc] initWithInfo:dict];
        if (obj) [arr addObject:obj];
    }

    return [arr copy];
}



@end
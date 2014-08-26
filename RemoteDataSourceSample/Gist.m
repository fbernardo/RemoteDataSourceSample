//
// Created by fbernardo on 27/08/14.
//
//

#import "Gist.h"


@implementation Gist

#pragma mark - Public Methods

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        _urlString = [info[@"html_url"] copy];
        _description = [info[@"description"] isKindOfClass:[NSString class]] ? [info[@"description"] copy] : nil;
    }
    return self;
}

@end
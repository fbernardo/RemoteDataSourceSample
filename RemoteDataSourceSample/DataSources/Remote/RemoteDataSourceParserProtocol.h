//
// Created by fbernardo on 26/08/14.
//
//

#import <Foundation/Foundation.h>

@protocol RemoteDataSourceParserProtocol
- (NSArray *)parseData:(NSData *)data error:(NSError **)error pageValue:(inout NSUInteger *)pageValue;
@end
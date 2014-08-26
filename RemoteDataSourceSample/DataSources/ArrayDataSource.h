//
// Created by fbernardo on 26/08/14.
//
//

#import <Foundation/Foundation.h>
#import "AbstractDataSource.h"

@interface ArrayDataSource : AbstractDataSource

- (instancetype)initWithArray:(NSArray *)array;

+ (instancetype)dataSourceWithArray:(NSArray *)array;

@property (nonatomic, strong) NSArray *array;

@end
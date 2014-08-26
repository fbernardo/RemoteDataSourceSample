//
// Created by fbernardo on 26/08/14.
//
//

#import <Foundation/Foundation.h>
#import "AbstractDataSource.h"

@interface UIDataSource : NSObject <UICollectionViewDataSource, UITableViewDataSource>

@property(nonatomic, strong) AbstractDataSource *dataSource;
@property(nonatomic, copy, readonly) NSString *cellIdentifier;

+ (instancetype)UIDataSourceWithDataSource:(AbstractDataSource *)dataSource
                            cellIdentifier:(NSString *)cellIdentifier
                        configureCellBlock:(void (^)(id cell, id object, NSIndexPath *indexPath))block;

- (instancetype)initWithDataSource:(AbstractDataSource *)dataSource
                    cellIdentifier:(NSString *)cellIdentifier
                configureCellBlock:(void (^)(id cell, id object, NSIndexPath *indexPath))block;

//Utility methods, those are just passed down to dataSource
- (NSUInteger)count;
- (id)objectForKeyedSubscript:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

@end
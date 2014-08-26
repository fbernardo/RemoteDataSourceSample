//
// Created by fbernardo on 26/08/14.
//
//

#import <Foundation/Foundation.h>

@interface AbstractDataSource : NSObject <UICollectionViewDataSource, UITableViewDataSource>

- (id)objectForKeyedSubscript:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;
- (NSUInteger)count;

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)deleteItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
- (BOOL)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
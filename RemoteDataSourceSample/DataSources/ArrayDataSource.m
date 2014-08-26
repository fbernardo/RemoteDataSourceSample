//
// Created by fbernardo on 26/08/14.
//
//

#import "ArrayDataSource.h"

@implementation ArrayDataSource {
    NSMutableArray *_array;
}
@dynamic array;

#pragma mark - Properties

- (NSArray *)array {
    return [_array copy];
}

- (void)setArray:(NSArray *)array {
    _array = [array mutableCopy];
}

#pragma mark - Static Methods

+ (instancetype)dataSourceWithArray:(NSArray *)array {
    return [[ArrayDataSource alloc] initWithArray:array];
}

#pragma mark - Init/Dealloc

- (instancetype)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        [self setArray:array];
    }
    return self;
}

#pragma mark - AbstractDataSource

- (id)objectForKeyedSubscript:(NSIndexPath *)indexPath {
    return self.array[(NSUInteger) indexPath.row];
}

- (NSUInteger)count {
    return [self.array count];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    NSArray *array = self.array;
    NSUInteger row = [array indexOfObject:object];
    return row != NSNotFound ? [NSIndexPath indexPathForRow:row inSection:0] : nil;
}

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [_array insertObject:object atIndex:(NSUInteger) indexPath.row];
}

- (BOOL)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [indexSet addIndex:(NSUInteger) [obj row]];
    }];
    [_array removeObjectsAtIndexes:indexSet];

    return YES;
}

- (BOOL)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    id obj = self[fromIndexPath];

    [_array removeObjectAtIndex:(NSUInteger) fromIndexPath.row];
    [_array insertObject:obj atIndex:(NSUInteger) toIndexPath.row];

    return YES;
}

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object  {
    [self deleteItemAtIndexPath:indexPath];
    [self insertObject:object atIndexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.array count];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

@end
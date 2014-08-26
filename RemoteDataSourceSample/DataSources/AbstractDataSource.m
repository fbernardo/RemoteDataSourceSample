//
// Created by fbernardo on 26/08/14.
//
//

#import "AbstractDataSource.h"

@implementation AbstractDataSource

#pragma mark - Public Methods

- (id)objectForKeyedSubscript:(NSIndexPath *)indexPath {
    return nil;
}

- (NSUInteger)count {
    return 0;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    return nil;
}

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self deleteItemsAtIndexPaths:@[indexPath]];
}

- (BOOL)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    return NO;
}

- (BOOL)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    return NO;
}

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
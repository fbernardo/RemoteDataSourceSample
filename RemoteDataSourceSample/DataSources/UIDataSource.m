//
// Created by fbernardo on 26/08/14.
//
//

#import "UIDataSource.h"

@interface UIDataSource ()
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) void (^configureCellBlock)(id, id, NSIndexPath *);
@end

@implementation UIDataSource

#pragma mark - Static Methods

+ (instancetype)UIDataSourceWithDataSource:(AbstractDataSource *)dataSource
                            cellIdentifier:(NSString *)cellIdentifier
                        configureCellBlock:(void (^)(id cell, id object, NSIndexPath *indexPath))block {
    return [[self alloc] initWithDataSource:dataSource cellIdentifier:cellIdentifier configureCellBlock:block];
}

#pragma mark - Init/Dealloc

- (instancetype)initWithDataSource:(AbstractDataSource *)dataSource
                    cellIdentifier:(NSString *)cellIdentifier
                configureCellBlock:(void (^)(id cell, id object, NSIndexPath *indexPath))block {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _cellIdentifier = [cellIdentifier copy];
        _configureCellBlock = [block copy];
    }
    return self;
}

#pragma mark - Public Methods

-(NSUInteger)count {
    return [self.dataSource count];
}

- (id)objectForKeyedSubscript:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    return [self.dataSource indexPathForObject:object];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id object = self[indexPath];
    self.configureCellBlock(cell, object, indexPath);
    return cell;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id object = self[indexPath];
    self.configureCellBlock(cell, object, indexPath);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - DataSource Forwarder

- (BOOL)respondsToSelector:(SEL)s {
    return [super respondsToSelector:s] || [self.dataSource respondsToSelector:s];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)s {
    return [super methodSignatureForSelector:s] ?: [(id)self.dataSource methodSignatureForSelector:s];
}

- (id)forwardingTargetForSelector:(SEL)s {
    id delegate = self.dataSource;
    return [delegate respondsToSelector:s] ? delegate : [super forwardingTargetForSelector:s];
}

@end
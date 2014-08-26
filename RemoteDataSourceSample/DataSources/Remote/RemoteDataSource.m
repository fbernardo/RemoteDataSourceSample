//
// Created by fbernardo on 26/08/14.
//
//

#import "RemoteDataSource.h"
#import "RemoteDataSourceParserProtocol.h"

@interface RemoteDataSource ()
@property(nonatomic, strong) NSURLSessionDataTask *dataTask;
@property(nonatomic, strong) NSURL *serviceURL;
@property(nonatomic, copy) NSString *pageParameterName;
@property(nonatomic, readwrite) NSUInteger pageValue;
@end

@implementation RemoteDataSource

#pragma mark - Static Methods

+ (NSURLSession *)remoteDataSourceSession {
    static NSURLSession *remoteDataSourceSession;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        remoteDataSourceSession = [NSURLSession sessionWithConfiguration:configuration];
    });
    return remoteDataSourceSession;
}

#pragma mark - Init/Dealloc

- (void)dealloc {
    [self cancel];
}

- (instancetype)initWithServiceURL:(NSURL *)url
                 pageParameterName:(NSString *)pageParameterName
                            parser:(id<RemoteDataSourceParserProtocol>)parser {
    self = [super init];
    if (self) {
        _serviceURL = url;
        _pageParameterName = pageParameterName;
        _parser = parser;
        _pageValue = 1;
    }
    return self;
}

#pragma mark - AbstractDataSource

- (id)objectForKeyedSubscript:(NSIndexPath *)indexPath {
    return [self array][(NSUInteger) indexPath.row];
}

- (NSUInteger)count {
    return [[self array] count];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    NSUInteger i = [[self array] indexOfObject:object];
    return i != NSNotFound ? [NSIndexPath indexPathForRow:i inSection:0] : nil;
}

#pragma mark - Public Methods

- (void)fetchWithCompletionBlock:(void (^)(NSError *error))block {
    [self.dataTask cancel];

    __weak typeof(self) weakSelf = self;

    _pageValue = 1;

    NSURL *url = [self URLWithPage:_pageValue];

    self.dataTask = [[RemoteDataSource remoteDataSourceSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (!error) {
            if ([data length] == 0 || ((NSHTTPURLResponse *)response).statusCode != 200) {
                error = [NSError errorWithDomain:@"RemoveDataSourceParsingErrorDomain" code:0 userInfo:nil];
            } else {
                NSUInteger pageValue = 1;
                NSArray *array = [self.parser parseData:data error:&error pageValue:&pageValue];
                strongSelf.pageValue = pageValue;

                if (!array) {
                    NSAssert(error != nil, @"No array then there's an error, right?");
                } else {
                    if ([array count] == 0) {
                        error = [NSError errorWithDomain:@"RemoveDataSourceParsingErrorDomain" code:1 userInfo:nil];
                    } else {
                        strongSelf.array = array;
                    }
                }
            }
        }

        if (block) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(error);
            });
        }

        weakSelf.dataTask = nil;
    }];
    [self.dataTask resume];
}

- (BOOL)fetchMoreWithCompletionBlock:(void (^)(NSError *error, NSArray *indexPaths))block {
    [self.dataTask cancel];

    __weak typeof(self) weakSelf = self;
    NSURL *url = [self URLWithPage:self.pageValue];

    self.dataTask = [[RemoteDataSource remoteDataSourceSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *indexPaths = nil;

        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (!error) {
            if ([data length] == 0 || ((NSHTTPURLResponse *)response).statusCode != 200) {
                error = [NSError errorWithDomain:@"RemoveDataSourceParsingErrorDomain" code:0 userInfo:nil];
            } else {
                NSUInteger pageValue = strongSelf.pageValue;
                NSArray *array = [strongSelf.parser parseData:data error:&error pageValue:&pageValue];
                strongSelf.pageValue = pageValue;

                if (!array) {
                    NSAssert(error != nil, @"No array then there's an error, right?");
                } else {
                    if ([array count] == 0) {
                        error = [NSError errorWithDomain:@"RemoveDataSourceParsingErrorDomain" code:1 userInfo:nil];
                    } else {
                        NSArray *finalArray = [strongSelf->_array arrayByAddingObjectsFromArray:array];
                        NSUInteger initial = [finalArray count] - [array count];

                        indexPaths = [NSMutableArray arrayWithCapacity:[array count]];

                        for (NSUInteger i = initial; i < [finalArray count]; i++) {
                            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                        }

                        strongSelf.array = finalArray;
                    }
                }
            }
        }


        if (block) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(error, indexPaths);
            });
        }

        weakSelf.dataTask = nil;
    }];
    [self.dataTask resume];

    return YES;
}

- (void)cancel {
    [self.dataTask cancel];
    self.dataTask = nil;
}

#pragma mark - Private Methods

- (NSURL *)URLWithPage:(NSUInteger)page {
    if (!_pageParameterName) return self.serviceURL;

    NSURLComponents *components = [NSURLComponents componentsWithURL:self.serviceURL resolvingAgainstBaseURL:NO];
    if ([components.query length] > 0) {
        components.query = [[components query] stringByAppendingFormat:@"&%@=%lu", self.pageParameterName, (unsigned long) page];
    } else {
        components.query = [NSString stringWithFormat:@"%@=%lu", self.pageParameterName, (unsigned long) page];
    }

    return [components URL];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self array] count];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self array] count];
}

@end
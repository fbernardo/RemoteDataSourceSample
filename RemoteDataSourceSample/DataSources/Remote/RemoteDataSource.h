//
// Created by fbernardo on 26/08/14.
//
//

#import <Foundation/Foundation.h>
#import "AbstractDataSource.h"

@protocol RemoteDataSourceParserProtocol;

@interface RemoteDataSource : AbstractDataSource

- (instancetype)initWithServiceURL:(NSURL *)serviceURL
                 pageParameterName:(NSString *)pageParameterName
                            parser:(id<RemoteDataSourceParserProtocol>)parser;

- (void)fetchWithCompletionBlock:(void (^)(NSError *error))block;
- (BOOL)fetchMoreWithCompletionBlock:(void (^)(NSError *error, NSArray *indexPaths))block;
- (void)cancel;

@property(nonatomic,strong) id<RemoteDataSourceParserProtocol> parser;
@property(nonatomic,strong) NSArray *array;

@end
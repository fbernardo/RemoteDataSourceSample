//
// Created by fbernardo on 27/08/14.
//
//

#import <Foundation/Foundation.h>


@interface Gist : NSObject

@property (nonatomic, copy,readonly) NSString *urlString;
@property (nonatomic, copy,readonly) NSString *description;

- (instancetype)initWithInfo:(NSDictionary *)info;

@end
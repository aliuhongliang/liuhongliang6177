//
//  LLQueue.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLQueue.h"

@interface LLQueue ()
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSMutableArray <id> *dataArray;
@end

@implementation LLQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (int)flush {
    [self.lock lock];
    [self.dataArray removeAllObjects];
    [self.lock unlock];
    return 0;
}

- (int)popWithLength:(NSInteger)length {
    if (length <= 0) {
        return 0;
    }
    [self.lock lock];
    if (length >= self.dataArray.count) {
        [self.dataArray removeAllObjects];
        [self.lock unlock];
        return 0;
    }
    NSRange range = NSMakeRange(0, length);
    [self.dataArray removeObjectsInRange:range];
    [self.lock unlock];
    
    return 0;
}

- (int)push:(id)data {
    [self.lock lock];
    [self.dataArray addObject:data];
    [self.lock unlock];
    return 0;
}

- (id)pop {
    [self.lock lock];
    int size = [self size];
    if (size <= 0) {
        [self.lock unlock];
        return nil;
    }
    id data = self.dataArray.firstObject;
    [self.dataArray removeObjectAtIndex:0];
    [self.lock unlock];
    return data;
}

//- (int)pop:(id *)data {
//    [self.lock lock];
//    int size = [self size];
//    if (size <= 0) {
//        [self.lock unlock];
//        return -1;
//    }
//
//    *data = (self.dataArray.firstObject);
//    [self.dataArray removeObjectAtIndex:0];
//    [self.lock unlock];
//    return 0;
//}

- (int)size {
    return (int)self.dataArray.count;
}

- (void)setup {
    self.lock = [[NSRecursiveLock alloc] init];
    self.dataArray = [NSMutableArray array];
}

- (void)dealloc {
    [self.lock lock];
    while (self.size > 0) {
        [self.dataArray removeObjectAtIndex:0];
    }
    [self.lock unlock];
}
@end

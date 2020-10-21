//
//  LLThread.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLThread.h"

@interface LLThread ()
@property (nonatomic, strong) NSThread *thread;
@end

@implementation LLThread
- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.path = path;
        [self setup];
    }
    return self;
}

- (void)run {
    
}

- (void)start {
    if (self.thread == nil) {
        self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
        self.stopFlag = 0;
        [self.thread start];
    }
}

- (void)stop {
    if (self.thread) {
        self.stopFlag = 1;
        [self.thread cancel];
        self.thread = nil;
    }
}

- (void)setup {
    
}
@end

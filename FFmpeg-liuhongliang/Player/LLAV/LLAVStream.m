//
//  LLAVStream.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLAVStream.h"

@implementation LLAVStream
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.streamIndex = -1;
    _codecpar = avcodec_parameters_alloc();
}

- (void)dealloc {
    if (_codecpar) {
        avcodec_parameters_free(&_codecpar);
        _codecpar = nil;
    }
}
@end

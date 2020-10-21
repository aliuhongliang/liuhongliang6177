//
//  LLThread.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLThread : NSObject

@property (nonatomic, assign) NSInteger stopFlag;
@property (nonatomic, strong) NSString *path;

- (instancetype)initWithPath:(NSString *)path;

- (void)run;
- (void)start;
- (void)stop;
@end


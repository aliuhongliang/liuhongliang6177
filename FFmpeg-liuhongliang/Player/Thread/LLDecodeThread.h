//
//  LLDecodeThread.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLThread.h"
#import "LLPlayerControlThread.h"
@class LLAVStream, LLAVPacket;

@interface LLDecodeThread : LLThread
@property (nonatomic, strong) LLPlayerControlThread *controlThread;
@property (nonatomic, assign) NSInteger streamType; // 0视频 1音频 2字幕
- (int)initialDecoderWithStream:(LLAVStream *)stream;

- (int)putPacket:(LLAVPacket *)packet;

- (int)getPacketSize;
@end


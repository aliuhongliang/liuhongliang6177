//
//  LLPlayerControlThread.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/21.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLThread.h"
@class LLAVFrame;

@interface LLPlayerControlThread : LLThread
- (int)getVideoQueueSize;
- (int)getAudioQueueSize;
- (int)pushVideoFrame:(LLAVFrame *)frame;
- (int)pushAudioFrame:(LLAVFrame *)frame;
@end


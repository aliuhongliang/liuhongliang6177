//
//  LLAVFrame.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avformat.h"

@interface LLAVFrame : NSObject
@property (nonatomic) AVFrame *frame;

- (void)printVideoFrame;
- (void)printAudioFrame;

- (int)getYUV_Y:(char *)YUV_y;
- (int)getYUV_U:(char *)YUV_u;
- (int)getYUV_V:(char *)YUV_v;
- (int)getW;
- (int)getH;
@end


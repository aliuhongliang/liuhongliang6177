//
//  LLDecoder.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAVPacket.h"
#import "LLAVFrame.h"
#import "LLAVStream.h"

@interface LLDecoder : NSObject
@property (nonatomic, assign) NSInteger streamIndex;
- (int)initialDecoder:(LLAVStream *)stream;
- (int)sendPacket:(LLAVPacket *)packet;
- (int)receiveFrame:(LLAVFrame *)frame;
- (void)close;
@end


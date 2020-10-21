//
//  LLReaderThread.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLThread.h"
#import "LLPlayerControlThread.h"

@interface LLReaderThread : LLThread

@property (nonatomic, strong) LLPlayerControlThread *controlThread;
@end


//
//  LLQueue.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLQueue : NSObject
- (int)push:(id)data;
- (int)pop:(id)data;
- (int)popWithLength:(NSInteger)length;
- (int)flush;
- (int)size;
@end


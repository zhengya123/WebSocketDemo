//
//  SocketRocketUtility.h
//  WebSocketDemo
//
//  Created by 郑亚 on 2019/11/14.
//  Copyright © 2019 郑亚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SocketRocketUtility : NSObject

+(SocketRocketUtility *)instance;
- (void) SRWebSocketOpen;
@end

NS_ASSUME_NONNULL_END

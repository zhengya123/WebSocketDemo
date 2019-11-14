//
//  SocketRocketUtility.m
//  WebSocketDemo
//
//  Created by 郑亚 on 2019/11/14.
//  Copyright © 2019 郑亚. All rights reserved.
//

#import "SocketRocketUtility.h"
#import "SRWebSocket.h"
@interface SocketRocketUtility ()<SRWebSocketDelegate>

@property(nonatomic,strong) SRWebSocket *socket;

@end

@implementation SocketRocketUtility
{
    NSTimer * heartBeat;
}
+(SocketRocketUtility *)instance{
    
    static SocketRocketUtility *Instance =nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        Instance = [[SocketRocketUtility alloc]init];
        
    });
    return Instance;
}

- (void) SRWebSocketOpen{
    
    self.socket =[[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://172.16.16.28:8080/websocket?organId=6f0a7c720608409abf354d82aa61625f"]]];
    self.socket.delegate =self;
    [self.socket open];
    
}

#pragma mark - socket delegate

//如果连接建立成功

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
    //开启心跳
    
    [self initHeartBeat];
    
    if(webSocket ==self.socket) {
        
        NSLog(@"************************** socket 连接成功************************** ");
    }
}

//如果连接建立失败

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError*)error {
    
    if(webSocket ==self.socket) {
        
        NSLog(@"************************** socket 连接失败************************** ");
        _socket =nil;//连接失败就重连
        //[self reConnect];
        
    }
    
}
- (void) initHeartBeat{
    
    heartBeat = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(ping) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:heartBeat forMode:NSRunLoopCommonModes];
}
- (void) ping{
    if(self.socket.readyState == SR_OPEN){
        [self.socket sendPing:nil];
        
    }
}
- (void)sendData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        if(self.socket !=nil) {
    
    // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
    
    if(self.socket.readyState == SR_OPEN) {
        
        //[self.socket send:data];
        
        // 发送数据
        
    }else if(self.socket.readyState == SR_CONNECTING) {
        
        //[self reConnect];
        
    }else if(self.socket.readyState == SR_CLOSING || self.socket.readyState == SR_CLOSED) {
            
            // websocket 断开了，调用 reConnect 方法重连
        //[self reConnect];}
    }else{
        
        //如果在发送数据，但是socket已经关闭，可以在再次打开
        [self SRWebSocketOpen];
        
    }
    }
    });
    
}
#pragma mark - 收到的回调

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    if(webSocket ==self.socket) {
        
        NSLog(@"message:%@",message);
        
        if(!message){
            return;
        }
    }
}
-(void)SRWebSocketClose{
    
    if(self.socket){
        [self.socket close];
        
        self.socket =nil;
        
        //断开连接时销毁心跳
        
        //[self destoryHeartBeat];
        }
    
}
@end

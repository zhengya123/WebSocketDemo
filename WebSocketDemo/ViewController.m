//
//  ViewController.m
//  WebSocketDemo
//
//  Created by 郑亚 on 2019/11/14.
//  Copyright © 2019 郑亚. All rights reserved.
//

#import "ViewController.h"
#import "SocketRocketUtility.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SocketRocketUtility instance] SRWebSocketOpen];
}


@end

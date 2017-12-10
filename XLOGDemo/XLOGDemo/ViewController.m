//
//  ViewController.m
//  XLOGDemo
//
//  Created by 李金 on 2017/12/8.
//  Copyright © 2017年 Kingandyoga. All rights reserved.
//

#import "ViewController.h"
#import "XLogManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",NSHomeDirectory());
    [XLogManager setupWithLevel:XLoglevelAll path:@"/log" encryptCode:0x11 needCosoleLog:YES prefix:@"xx" logext:@"cc"];
}

- (IBAction)test:(id)sender {
//    [XLogManager logWithLevel:XLoglevelAll format:@"aaa"];
    XLog_General(XLoglevelAll,@"aaa");
}

- (IBAction)flush:(id)sender {
    [XLogManager flushLog:^(BOOL re) {
        if (re) {
            NSLog(@"flush finish");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

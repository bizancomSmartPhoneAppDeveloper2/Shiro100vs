//
//  Music.m
//  siro100BGM
//
//  Created by ビザンコムマック１１ on 2014/11/16.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "Music.h"

@implementation Music

-(void)koukaon{
    NSString* kpath = [[NSBundle mainBundle]
                      pathForResource:@"Furinuki" ofType:@"mp3"];
    NSURL* kurl = [NSURL fileURLWithPath:kpath];
    kouka = [[AVAudioPlayer alloc]
             initWithContentsOfURL:kurl error:nil];
    kouka.numberOfLoops = 0;
    [kouka play];
}


-(void)BGMStart1{
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:@"Kassen" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:path];
    audio = [[AVAudioPlayer alloc]
             initWithContentsOfURL:url error:nil];
    audio.numberOfLoops = -1;
    [audio play];
}

-(void)BGMStart2{
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:@"Tuisou" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:path];
    audio = [[AVAudioPlayer alloc]
             initWithContentsOfURL:url error:nil];
    audio.numberOfLoops = -1;
    [audio play];
}

-(void)BGMStop{
    [audio stop];
}
@end

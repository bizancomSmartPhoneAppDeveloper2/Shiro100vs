//
//  Music.h
//  siro100BGM
//
//  Created by ビザンコムマック１１ on 2014/11/16.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Music : NSObject{
    AVAudioPlayer *audio,*kouka;
}

-(void)koukaon;
-(void)BGMStart1;
-(void)BGMStart2;
-(void)BGMStop;
@end

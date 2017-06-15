//
//  LGHAudioEngineManager.h
//  音频混响音效处理-OC-Demo
//
//  Created by 高飞 on 2017/6/15.
//  Copyright © 2017年 Daniel Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface LGHAudioEngineManager : NSObject

//播放节点
@property (nonatomic,strong) AVAudioPlayerNode *player;
@property (nonatomic,strong) AVAudioPlayerNode *backPlayer;
//PCMBuffer
@property (nonatomic,strong) AVAudioPCMBuffer *playerLoopBuffer;
@property (nonatomic,strong) AVAudioPCMBuffer *buffer2;
@property (nonatomic,strong) AVAudioEngine *engine;
//混响
@property (nonatomic,strong) AVAudioUnitReverb *reverb;
//失真
@property (nonatomic,strong) AVAudioUnitDistortion *distortion;
//延迟音效
@property (nonatomic,strong) AVAudioUnitDelay *delay;
//均衡器
@property (nonatomic,strong) AVAudioUnitEQ *eq;
@property (nonatomic,strong) AVAudioUnitEQFilterParameters *eqFilter;
+ (LGHAudioEngineManager*)sharedManager;
- (void)initSessionWithSampleRate:(double)sampleRate duration:(NSTimeInterval)duration;
- (void)createAudioFileWithURL:(NSURL*)url;
- (void)createEngineAndAttachNodes;
- (void)makeEngineConnectionsWithAllEffects;
- (void)makeEngineConnectionsWithAudioEffect:(AVAudioUnitEffect*)effect;
- (void)startEngine;
- (void)playOrPauseAudio;
- (void)playBackAudioOnTheSameTimeWithFileURL:(NSURL*)url;
@end

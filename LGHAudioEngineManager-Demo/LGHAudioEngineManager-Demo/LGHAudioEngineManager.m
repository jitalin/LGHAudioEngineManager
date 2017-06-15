//
//  LGHAudioEngineManager.m
//  音频混响音效处理-OC-Demo
//
//  Created by 高飞 on 2017/6/15.
//  Copyright © 2017年 Daniel Lin. All rights reserved.
//

#import "LGHAudioEngineManager.h"

@implementation LGHAudioEngineManager
//MARK:创建AVAudioSession
- (void)initSessionWithSampleRate:(double)sampleRate duration:(NSTimeInterval)duration
{
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    NSError *error;
    // set the session category
    bool success = [sessionInstance setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
    //采样率
    success = [sessionInstance setPreferredSampleRate:sampleRate error:&error];
    if (!success) NSLog(@"Error setting preferred sample rate! %@\n", [error localizedDescription]);
    
    success = [sessionInstance setPreferredIOBufferDuration:duration error:&error];
    if (!success) NSLog(@"Error setting preferred io buffer duration! %@\n", [error localizedDescription]);
    [sessionInstance setActive:YES error:&error];
    
    
}
- (void)createAudioFileWithURL:(NSURL*)url{
    NSError *error;
    AVAudioFile *file = [[AVAudioFile alloc]initForReading:url error:&error];
    _playerLoopBuffer = [[AVAudioPCMBuffer alloc]initWithPCMFormat:[file processingFormat] frameCapacity:(AVAudioFrameCount)[file length]];
    [file readIntoBuffer:_playerLoopBuffer error:&error];
}
#pragma mark-------设置音效，创建engine安装节点
- (void)createEngineAndAttachNodes
{
    _player = [[AVAudioPlayerNode alloc]init];
    _reverb = [[AVAudioUnitReverb alloc] init];
    _distortion = [[AVAudioUnitDistortion alloc]init];
    _delay = [[AVAudioUnitDelay alloc]init];
    _eq = [[AVAudioUnitEQ alloc]initWithNumberOfBands:1];
    
    [_reverb loadFactoryPreset:AVAudioUnitReverbPresetMediumHall];
    _reverb.wetDryMix = 0;
   // self.reverbTypeLabel.text = @"AVAudioUnitReverbPresetMediumHall";
    
    [_distortion loadFactoryPreset:AVAudioUnitDistortionPresetDrumsLoFi];
    _distortion.wetDryMix = 0;
   // self.distortionTypeLabel.text = @"AVAudioUnitDistortionPresetDrumsLoFi";
    
    [_delay setLowPassCutoff:0];
    _delay.delayTime = 2;
    _delay.wetDryMix = 10;
    _delay.feedback = 2;
    
    _eqFilter = _eq.bands.firstObject;
    _eqFilter.filterType = AVAudioUnitEQFilterTypeLowPass;
    _eqFilter.bandwidth = 5;
    _eqFilter.bypass = NO;
    _eqFilter.gain = 15;
    _eqFilter.frequency = 1000;
    //信号的总增益
    _eq.globalGain = 2;
    
    _engine = [[AVAudioEngine alloc] init];
    [_engine attachNode:_reverb];
    [_engine attachNode:_distortion];
    [_engine attachNode:_delay];
    [_engine attachNode:_eq];
    [_engine attachNode:_player];
    //同时播放多个音频
    _backPlayer = [[AVAudioPlayerNode alloc]init];
    [_engine attachNode:_backPlayer];
    
}
#pragma mark---------混合四种音效混响、延迟、失真、均衡器
- (void)makeEngineConnectionsWithAllEffects{
    //混合各种音效的例子
    AVAudioMixerNode *mainMixer = [_engine mainMixerNode];
    AVAudioFormat *stereoFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100 channels:2];
    [_engine connect:_player to:_reverb format:stereoFormat];
    [_engine connect:_reverb to:_delay format:stereoFormat];
    [_engine connect:_delay to:_distortion format:stereoFormat];
    [_engine connect:_distortion to:_eq format:stereoFormat];
    [_engine connect:_eq to:mainMixer fromBus:0 toBus:0 format:stereoFormat];
}
#pragma mark------连接节点，混合单独音效。
- (void)makeEngineConnectionsWithAudioEffect:(AVAudioUnitEffect*)effect
{//注意：要先把player连接到某节点
    AVAudioMixerNode *mainMixer = [_engine mainMixerNode];
    AVAudioFormat *stereoFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100 channels:2];
    [_engine connect:_player to:effect format:stereoFormat];
    // connect the reverb effect to mixer input bus 0
    [_engine connect:effect to:mainMixer fromBus:0 toBus:0 format:stereoFormat];
    
    
}
#pragma mark-----开启engine
- (void)startEngine
{
    if (!_engine.isRunning) {
        NSError *error;
        BOOL success;
        success = [_engine startAndReturnError:&error];
        NSAssert(success, @"couldn't start engine, %@", [error localizedDescription]);
    }
}
//MARK:播放或暂停
- (void)playOrPauseAudio{

    if (![_player isPlaying])
    {
        [self startEngine];
        [_player scheduleBuffer:_playerLoopBuffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_player play];
    }
    else
    {
        [_player pause];
    }
    
}
#pragma mark-------播放背景乐
- (void)playBackAudioOnTheSameTimeWithFileURL:(NSURL*)url{
    NSError* error;
    _backPlayer = [[AVAudioPlayerNode alloc] init];
    AVAudioFile *file2 = [[AVAudioFile alloc] initForReading:url error:nil];
    _buffer2 = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[file2 processingFormat] frameCapacity:((AVAudioFrameCount )file2.length)];
    [file2 readIntoBuffer:_buffer2 error:&error];
    //channels双声道双份
    AVAudioFormat *stereoFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100 channels:2];
    
    [_engine attachNode:_backPlayer];
    //[_engine connect:_player to:[_engine mainMixerNode] fromBus:0 toBus:2 format:stereoFormat];
    [_engine connect:_backPlayer to:[_engine mainMixerNode] fromBus:0 toBus:1 format:stereoFormat];
    
}
//单例
+ (LGHAudioEngineManager *)sharedManager{
    static LGHAudioEngineManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LGHAudioEngineManager alloc]init];
        
    });
    return manager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }return self;
}
@end

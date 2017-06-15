//
//  ViewController.m
//  LGHAudioEngineManager-Demo
//
//  Created by 高飞 on 2017/6/15.
//  Copyright © 2017年 Daniel Lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LGHAudioEngineManager *manager;
@property (nonatomic,strong) NSURL *fileURL;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) UITableView *reverbTableView;
@property (nonatomic,strong) UITableView *distortionTableView;
@property (nonatomic,strong) NSArray *reverbTypeArr;
@property (nonatomic,strong) NSArray *distortionTypeArr;
@property (nonatomic,strong) MGFashionMenuView *reverbMenuView;
@property (nonatomic,strong) MGFashionMenuView *distortionMenuView;
//EQ
@property (nonatomic,strong) MGFashionMenuView *eqMenuView;
@property (nonatomic,strong) UITableView *eqTableView;
@property (nonatomic,strong) NSArray *eqArr;



@property (weak, nonatomic) IBOutlet UILabel *distortionPreGainLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *reverbWetDryMixLabel;
@property (weak, nonatomic) IBOutlet UILabel *distortionWetDryMixLabel;
@property (weak, nonatomic) IBOutlet UILabel *reverbTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distortionTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *delayWetDryMixLabel;
@property (weak, nonatomic) IBOutlet UILabel *delayFeedbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *delayLowPassCutoffLabel;
@property (weak, nonatomic) IBOutlet UILabel *delayTimeLabel;
//EQ
@property (weak, nonatomic) IBOutlet UIView *eqView;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bandwidthLabel;
@property (weak, nonatomic) IBOutlet UILabel *gainLabel;
@property (weak, nonatomic) IBOutlet UILabel *globalGainLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.reverbTypeArr = @[    @"AVAudioUnitReverbPresetSmallRoom",
                               @"AVAudioUnitReverbPresetMediumRoom",
                               @"AVAudioUnitReverbPresetLargeRoom" ,
                               @"AVAudioUnitReverbPresetMediumHall",
                               @"AVAudioUnitReverbPresetLargeHall",
                               @"AVAudioUnitReverbPresetPlate" ,
                               @"AVAudioUnitReverbPresetMediumChamber" ,
                               @"AVAudioUnitReverbPresetLargeChamber"   ,
                               @"AVAudioUnitReverbPresetCathedral" ,
                               @"AVAudioUnitReverbPresetLargeRoom2" ,
                               @"AVAudioUnitReverbPresetMediumHall2" ,
                               @"AVAudioUnitReverbPresetMediumHall3" ,
                               @"AVAudioUnitReverbPresetLargeHall2" ];
    self.distortionTypeArr = @[
                               @"AVAudioUnitDistortionPresetDrumsBitBrush",
                               @"AVAudioUnitDistortionPresetDrumsBufferBeats",
                               @"AVAudioUnitDistortionPresetDrumsLoFi",
                               @"AVAudioUnitDistortionPresetMultiBrokenSpeaker",
                               @"AVAudioUnitDistortionPresetMultiCellphoneConcert",
                               @"AVAudioUnitDistortionPresetMultiDecimated1"  ,
                               @"AVAudioUnitDistortionPresetMultiDecimated2"  ,
                               @"AVAudioUnitDistortionPresetMultiDecimated3"  ,
                               @"AVAudioUnitDistortionPresetMultiDecimated4" ,
                               @"AVAudioUnitDistortionPresetMultiDistortedFunk" ,
                               @"AVAudioUnitDistortionPresetMultiDistortedCubed"  ,
                               @"AVAudioUnitDistortionPresetMultiDistortedSquared"  ,
                               @"AVAudioUnitDistortionPresetMultiEcho1"   ,
                               @"AVAudioUnitDistortionPresetMultiEcho2"  ,
                               @"AVAudioUnitDistortionPresetMultiEchoTight1"  ,
                               @"AVAudioUnitDistortionPresetMultiEchoTight2"  ,
                               @"AVAudioUnitDistortionPresetMultiEverythingIsBroken" ,
                               @"AVAudioUnitDistortionPresetSpeechAlienChatter",
                               @"AVAudioUnitDistortionPresetSpeechCosmicInterference" ,
                               @"AVAudioUnitDistortionPresetSpeechGoldenPi"  ,
                               @"AVAudioUnitDistortionPresetSpeechRadioTower" ,
                               @"AVAudioUnitDistortionPresetSpeechWaves"];
    
    self.eqArr = @[  @"AVAudioUnitEQFilterTypeParametric" ,
                     @"AVAudioUnitEQFilterTypeLowPass"    ,
                     @"AVAudioUnitEQFilterTypeHighPass"   ,
                     @"AVAudioUnitEQFilterTypeResonantLowPass" ,
                     @"AVAudioUnitEQFilterTypeResonantHighPass",
                     @"AVAudioUnitEQFilterTypeBandPass"   ,
                     @"AVAudioUnitEQFilterTypeBandStop"  ,
                     @"AVAudioUnitEQFilterTypeLowShelf" ,
                     @"AVAudioUnitEQFilterTypeHighShelf"  ,
                     @"AVAudioUnitEQFilterTypeResonantLowShelf",
                     @"AVAudioUnitEQFilterTypeResonantHighShelf" ];

    [self setUpManager];
    
}
- (void)setUpManager{
    
    LGHAudioEngineManager* manager = [LGHAudioEngineManager sharedManager];
    self.manager = manager;
    [manager initSessionWithSampleRate:44100.0 duration:0.0029];
    [manager createAudioFileWithURL:self.fileURL];
    [manager createEngineAndAttachNodes];
    [manager makeEngineConnectionsWithAllEffects];
    [manager playBackAudioOnTheSameTimeWithFileURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio1" ofType:@"caf"]]];
    [manager startEngine];
}


#pragma mark-------UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.reverbTableView) {
        return self.reverbTypeArr.count;
    }else if (tableView == self.distortionTableView){
        return self.distortionTypeArr.count;
    }
    else{
        return self.eqArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reverbCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reverbCell"];
        
    }
    if (tableView == self.reverbTableView) {
        cell.textLabel.text = self.reverbTypeArr[indexPath.row];
    }else if (tableView == self.distortionTableView){
        cell.textLabel.text = self.distortionTypeArr[indexPath.row];
    }else{
        cell.textLabel.text = self.eqArr[indexPath.row];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //重置engine中的所有节点不是断开所有节点，用于清除音效尾音的。
    //[_engine reset];
#warning 切换不同音效的时候，会自动停止播放？
    if (tableView == self.reverbTableView) {
        [self.manager.reverb loadFactoryPreset:indexPath.row];
        //[self makeEngineConnectionsWithAudioEffect:_reverb];
        self.reverbTypeLabel.text = self.reverbTypeArr[indexPath.row];
        [self.reverbMenuView hide];
        
    }else if (tableView == self.distortionTableView){
        [self.manager.distortion loadFactoryPreset:indexPath.row];
        //[self makeEngineConnectionsWithAudioEffect:_distortion];
        self.distortionTypeLabel.text = self.distortionTypeArr[indexPath.row];
        [self.distortionMenuView hide];
    }
    else{
        self.manager.eqFilter.filterType = indexPath.row;
        [self.eqMenuView hide];
    }
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.reverbMenuView hide];
    [self.distortionMenuView hide];
    [UIView animateWithDuration:0.3 animations:^{
        self.eqView.hidden = YES;
    }];
}
//MARK:按钮操作
- (IBAction)changeReverbWetDryMixValue:(UISlider *)sender {
    self.reverbWetDryMixLabel.text = [NSString stringWithFormat:@"reverb.wetDryMix:%.2f",sender.value];
    self.manager.reverb.wetDryMix = sender.value;
}
- (IBAction)changeDistortionWetDryMixValue:(UISlider *)sender {
    self.distortionWetDryMixLabel.text = [NSString stringWithFormat:@"distortion.wetDryMix:%.2f",sender.value];
    self.self.manager.distortion.wetDryMix = sender.value;
}
- (IBAction)changeDistortionPreGainValue:(UISlider *)sender {
    self.distortionPreGainLabel.text = [NSString stringWithFormat:@"distortion.preGain:%.2f",sender.value];
    self.self.manager.distortion.preGain = sender.value;
}
- (IBAction)changeDelayWetDryMixValue:(UISlider *)sender {
    self.delayWetDryMixLabel.text = [NSString stringWithFormat:@"delay.wetDryMix:%f",sender.value];
    self.manager.delay.wetDryMix = sender.value;
    
}
- (IBAction)changeDelayFeedbackValue:(UISlider *)sender {
    self.delayFeedbackLabel.text = [NSString stringWithFormat:@"delay.feedback::%f",sender.value];
    self.manager.delay.feedback = sender.value;
    
}
- (IBAction)changeDelayLowPassCutoffValue:(UISlider *)sender {
    self.delayLowPassCutoffLabel.text = [NSString stringWithFormat:@"delay.lowPassCutoff::%f",sender.value];
    self.manager.delay.lowPassCutoff = sender.value;
}
- (IBAction)changeDelayTimeValue:(UISlider *)sender {
    self.delayTimeLabel.text = [NSString stringWithFormat:@"delay.delayTime:%f",sender.value];
    self.manager.delay.delayTime = sender.value;
}
//MARK:播放或暂停
- (IBAction)playOrPauseAudio:(UIButton *)sender {
    [sender setTitle:@"PAUSE" forState:UIControlStateSelected];
    [self.manager playOrPauseAudio];
    sender.selected = !sender.selected;
    
}
- (IBAction)changeReverbType:(UIButton *)sender {
    if (self.reverbMenuView.isShown) {
        [self.reverbMenuView hide];
    }else{
        [self.reverbMenuView show];
        [self.distortionMenuView hide];
    }
    
}

- (IBAction)changeDistortionType:(UIButton *)sender {
    if (self.distortionMenuView.isShown) {
        [self.distortionMenuView hide];
    }else{
        [self.distortionMenuView show];
        [self.reverbMenuView hide];
        
    }
}
#pragma mark-------均衡器按钮

- (IBAction)changeFrequencyValue:(UISlider *)sender {
    self.frequencyLabel.text = [NSString stringWithFormat:@"frequency:%.2f",sender.value];
    self.self.manager.eqFilter.frequency = sender.value;
    
}
- (IBAction)changeBandwidthValue:(UISlider *)sender {
    self.bandwidthLabel.text = [NSString stringWithFormat:@"bandwidth:%.2f",sender.value];
    self.self.manager.eqFilter.bandwidth = sender.value;
    
}
- (IBAction)changeGainValue:(UISlider *)sender {
    self.gainLabel.text = [NSString stringWithFormat:@"gain:%.2f",sender.value];
    self.self.manager.eqFilter.gain = sender.value;
    
}
- (IBAction)changeGlobalGainValue:(UISlider *)sender {
    self.globalGainLabel.text = [NSString stringWithFormat:@"globalGain:%.2f",sender.value];
    self.manager.eq.globalGain = sender.value;
}
- (IBAction)selectEQType:(UIButton *)sender {
    if (self.eqMenuView.isShown) {
        [self.eqMenuView hide];
        
    }else{
        [self.eqMenuView show];
    }
    
    
}

- (IBAction)showEQ:(UIBarButtonItem *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.eqView.hidden = !self.eqView.hidden;
    }];
    
}
#pragma mark-----播放背景乐
- (IBAction)playOrPauseBackAudio:(UISwitch *)sender {
    if (sender.isOn) {
        [self.manager.backPlayer scheduleBuffer:self.manager.buffer2 atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [self.manager.backPlayer play];
        self.manager.backPlayer.volume = 1.0;
    }else{
        [self.manager.backPlayer stop];
        
    }
}

#pragma mark------get methode
- (NSString *)filePath{
    if (!_filePath) {
        _filePath = [[NSBundle mainBundle] pathForResource:@"林俊杰 - 她说" ofType:@"mp3"];
        
    }return _filePath;
}
- (NSURL *)fileURL{
    if (!_fileURL) {
        _fileURL = [NSURL fileURLWithPath:self.filePath];
    }return _fileURL;
}

- (UITableView *)reverbTableView{
    if (!_reverbTableView) {
        _reverbTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/3*2)];
        _reverbTableView.delegate = self;
        _reverbTableView.dataSource = self;
        _reverbTableView.tableFooterView = [[UIView alloc]init];
    }   return _reverbTableView;
    
    
}
- (UITableView *)distortionTableView{
    if (!_distortionTableView) {
        _distortionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/3*2)];
        _distortionTableView.delegate = self;
        _distortionTableView.dataSource = self;
        _distortionTableView.tableFooterView = [[UIView alloc]init];
    }   return _distortionTableView;
}
- (MGFashionMenuView *)reverbMenuView{
    if (!_reverbMenuView) {
        _reverbMenuView = [[MGFashionMenuView alloc] initWithMenuView:self.reverbTableView];
        [self.view addSubview:_reverbMenuView];
    }return _reverbMenuView;
}
- (MGFashionMenuView *)distortionMenuView{
    if (!_distortionMenuView) {
        _distortionMenuView = [[MGFashionMenuView alloc] initWithMenuView:self.distortionTableView];
        [self.view addSubview:_distortionMenuView];
    }return _distortionMenuView;
    
}
- (MGFashionMenuView *)eqMenuView{
    if (!_eqMenuView) {
        _eqMenuView = [[MGFashionMenuView alloc]initWithMenuView:self.eqTableView animationType:MGAnimationTypeWave];
        [self.view addSubview:_eqMenuView];
    }return _eqMenuView;
}
- (UITableView *)eqTableView{
    if (!_eqTableView) {
        _eqTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/3*2)];
        _eqTableView.delegate = self;
        _eqTableView.dataSource = self;
        _eqTableView.tableFooterView = [[UIView alloc]init];
    }return _eqTableView;
}

@end

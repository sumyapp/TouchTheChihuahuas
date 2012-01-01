//
//  TTDGameViewController.m
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TTDGameViewController.h"

@interface TTDGameViewController()
- (void)startCountDown:(NSTimer*)timer;
- (void)startGame;
- (void)startGameCountStart;
- (void)gameTimeControlTask:(NSTimer*)timer;
- (void)destroyDroid:(TTDDroidView*)droidView;
- (void)droidDestroySuccess:(TTDDroidView*)droidView;
- (void)droidDestroyMiss:(TTDDroidView*)droidView;
- (void)droidDestroyAnimationDidEnd;
- (void)addDroid;
- (void)saveHighScore;
@end

@implementation TTDGameViewController
@synthesize colorType = _colorType;
@synthesize destroyNormDroidCount = _destroyNormDroidCount;
@synthesize missDroidDestroyPenalty = _missDroidDestroyPenalty;

- (void)saveHighScore {
    LOG_METHOD
    NSMutableDictionary *highScoreDataSet = [[[NSMutableDictionary alloc] init] autorelease];
    [highScoreDataSet setObject:[NSNumber numberWithBool:NO]
                         forKey:@"HIGH_SCORE_ALREADY_SEND"];
    [highScoreDataSet setObject:[NSNumber numberWithFloat:_gamePlayingTimeCount]
                         forKey:@"HIGH_SCORE"];
    [highScoreDataSet setObject:[NSDate date] forKey:@"HIGH_SCORE_GOT_DATE"];
    
    // ファイルに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:highScoreDataSet forKey:@"HIGH_SCORE_DATA_world_ranking_25robots"];
    [defaults synchronize];
}

- (void)startCountDown:(NSTimer*)timer {
    LOG_METHOD
    int count = [_textLabel.text intValue];
    if(count > 1) {
        count--;
        [_textLabel setText:[NSString stringWithFormat:@"%d", count]];
    }
    else if(count == 1) {
        [_textLabel setText:@"Start!"];
    }
    else {
        [_textLabel setText:@""];
        [timer invalidate];
        [self startGame];
    }
}

- (void)startGame {
    LOG_METHOD
    // 各変数の初期化
    _apperdDroidCount = 0;
    _droidControlCount = 0;
    _destroyedDroidCount = 0;
    _gamePlayingTimeCount = 0;
    
    // ラベルの初期化
    [_scoreLabel setText:[NSString stringWithFormat:@"%d", _destroyedDroidCount]];
    [_timeCountTextLabel setText:[NSString stringWithFormat:@"%.2f", _gamePlayingTimeCount]];
    [_textLabel setText:@""];
    
    // ゲームの開始
    srand(time(NULL)); //内部のロジックで使ってるrandを初期化
    _gamePlayingTimeCountTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(gameTimeControlTask:) userInfo:nil repeats:YES];
}

- (void)startGameCountStart {
    LOG_METHOD
    // 各変数の初期化
    _apperdDroidCount = 0;
    _droidControlCount = 0;
    _destroyedDroidCount = 0;
    _gamePlayingTimeCount = 0;
    
    // ラベルの初期化
    [_scoreLabel setText:@""];
    [_timeCountTextLabel setText:@""];
    [_textLabel setText:@"3"];

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown:) userInfo:nil repeats:YES];
}


- (void)gameTimeControlTask:(NSTimer*)timer {
    _gamePlayingTimeCount = _gamePlayingTimeCount + 0.01;
    [_timeCountTextLabel setText:[NSString stringWithFormat:@"%.2f", _gamePlayingTimeCount]];
    
    _nextDroidApperCount = _nextDroidApperCount - 0.01;
    if(_nextDroidApperCount <= 0) {
        [self addDroid];
        _nextDroidApperCount = 0;
    }
    
    if(_nextDroidApperCount == 0) {
        switch (rand() % 6) {
            case 0:
                _nextDroidApperCount = 0.25;
                break;
            case 1:
                _nextDroidApperCount = 0.5;
                break;
            case 2:
                _nextDroidApperCount = 1.25;
                break;
            case 3:
                _nextDroidApperCount = 1.5;
            case 4:
                _nextDroidApperCount = 1.75;
                break;
            case 5:
                _nextDroidApperCount = 2.0;
                break;
            default:
                LOG(@"WARNING: this swich section not use");
                _nextDroidApperCount = 1.0;
                break;
        }
    }
}

- (void)destroyDroid:(TTDDroidView*)droidView {
    LOG_METHOD
    LOG(@"DESTROY %d DROID:destroy droid[%d] = %@", _destroyedDroidCount, droidView.number, [droidView description]);    
    
    // 最大サイズのドロイドかを検索
    float maxDroidWidth = 0;
    for (NSNumber *droidViewKey in _droidViewsDic) {
        TTDDroidView *droidView = [_droidViewsDic objectForKey:droidViewKey];
        if(maxDroidWidth < droidView.frame.size.width) {
            maxDroidWidth = droidView.frame.size.width;
        }
    }
    
    // 最大サイズのドロイドだったので、成功
    if(droidView.frame.size.width >= maxDroidWidth) {
        [self droidDestroySuccess:droidView];
    }
    else {
        [self droidDestroyMiss:droidView];
    }    
}

- (void)droidDestroySuccess:(TTDDroidView*)droidView {
    LOG_METHOD    
    if(!_animatingDroidViews) {
        _animatingDroidViews = [[NSMutableArray alloc] init];
    }
    [_animatingDroidViews addObject:droidView];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(droidDestroyAnimationDidEnd)];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(180.f * (M_PI / 180.0f));
    CGAffineTransform scale = CGAffineTransformMakeScale(0.001, 0.001);
    CGAffineTransform concat = CGAffineTransformConcat(rotate, scale);
    [droidView setTransform:concat];
    [UIView commitAnimations];
    
    // Droidの消去。画面からの消去はアニメーション後に行われる
    [_droidViewsDic removeObjectForKey:[NSNumber numberWithInt:droidView.number]];
    
    // スコアの加算
    _destroyedDroidCount = _destroyedDroidCount + 1;
    [_scoreLabel setText:[NSString stringWithFormat:@"%d", _destroyedDroidCount]];
    
    // 何匹目かチェック
    if(_destroyedDroidCount >= _destroyNormDroidCount) {
        [_gamePlayingTimeCountTimer invalidate];
        _gamePlayingTimeCountTimer = nil;
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *savedHighScore = [defaults objectForKey:@"HIGH_SCORE_DATA_world_ranking_25robots"];
        // ハイスコアが更新されてたら保存する
        if(savedHighScore == nil || [[savedHighScore objectForKey:@"HIGH_SCORE"] floatValue] >= _gamePlayingTimeCount) {
            // ハイスコアを保存
            [self saveHighScore];
            // ハイスコアおめでとうメッセージ
            UIAlertView *alert =[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Highscore!", nil) message:NSLocalizedString(@"Successful. You destroyed all the robots!\nAnd, You got a new record!", nil) delegate:self
                                                  cancelButtonTitle:@"Close" otherButtonTitles:@"Retry", nil] autorelease];
            [alert show];
        }
        else {
            // クリアおめでとうメッセージ
            UIAlertView *alert =[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Finish!", nil) message:NSLocalizedString(@"Successful. You destroyed all the robots!", nil) delegate:self
                                                  cancelButtonTitle:@"Close" otherButtonTitles:@"Retry", nil] autorelease];
            [alert show];
        }
        
        for (NSNumber *droidViewKey in _droidViewsDic) {
            [[_droidViewsDic objectForKey:droidViewKey] removeFromSuperview];
        }
        [_droidViewsDic release], _droidViewsDic = nil;
    }
    else {
        // ドロイド追加
        [self addDroid];
    }
}

- (void)droidDestroyMiss:(TTDDroidView*)droidView {
    LOG_METHOD
    if(!_animatingDroidViews) {
        _animatingDroidViews = [[NSMutableArray alloc] init];
    }
    [_animatingDroidViews addObject:droidView];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(droidDestroyAnimationDidEnd)];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(45.f * (M_PI / 180.0f));
    CGAffineTransform scale = CGAffineTransformMakeScale(0.5, 0.5);
    CGAffineTransform concat = CGAffineTransformConcat(rotate, scale);
    [droidView setTransform:concat];
    [UIView commitAnimations];
    
    // Droidの消去。画面からの消去はアニメーション後に行われる
    [_droidViewsDic removeObjectForKey:[NSNumber numberWithInt:droidView.number]];

    // ペナルティとして、ゲームの経過時間をちょっと＋
    _gamePlayingTimeCount+=_missDroidDestroyPenalty;
    // ペナルティとして、ドロイド追加を遅延
    [NSTimer scheduledTimerWithTimeInterval:_missDroidDestroyPenalty target:self selector:@selector(addDroid) userInfo:nil repeats:NO];
}

- (void)droidDestroyAnimationDidEnd {
    LOG_METHOD
    if(_animatingDroidViews && [_animatingDroidViews count] > 1) {
        TTDDroidView *droidView = [_animatingDroidViews objectAtIndex:0];
        [droidView setHidden:YES];
        [droidView removeFromSuperview];
        [_animatingDroidViews removeObject:droidView];
    }
}

- (void)addDroid {
    LOG_METHOD
    if(_droidViewsDic.count + _destroyedDroidCount >= _destroyNormDroidCount || !_gamePlayingTimeCountTimer) {
        return;
    }
    
    // Droidのサイズを決定
    float droidWidth, droidHeight;
    do {
        droidWidth = rand() % 150;
    } while (droidWidth < 35 && droidWidth > 3);
    droidHeight = droidWidth * DROID_ASPECT_RATIO;
    
    // Droidの始点を8点のうちどこかを決定, それに合わせて目的地店とdroidの回転角度も設定
    float droidPosX, droidPosY;
    do {
        droidPosX = rand() % 320;
    } while (droidPosX + droidWidth > 320);
    do {
        droidPosY = rand() % 460;
    } while (droidPosY + droidHeight > 460);
    
    // Droidのインスタンス化、設定設定
    TTDDroidView *droidView = [[TTDDroidView alloc] initWithFrame:CGRectMake(droidPosX, droidPosY, droidWidth, droidHeight)];
    [droidView setColorType:_colorType];
    [droidView setNumber:_apperdDroidCount];
    [droidView setDelegate:self];
    [droidView setAlpha:0.0];
    
    // Droidを表示
    if(!_droidViewsDic) {
        _droidViewsDic = [[NSMutableDictionary alloc] init];
    }
    [_droidViewsDic setObject:droidView forKey:[NSNumber numberWithInt:_apperdDroidCount]];
    [self.view addSubview:droidView];
    [droidView release];
    
    // Droidを追加したことを変数に保存
    _apperdDroidCount = _apperdDroidCount + 1;
    
    //アニメーションの対象となるコンテキスト
   CGContextRef context = UIGraphicsGetCurrentContext();
   [UIView beginAnimations:nil context:context];
    //アニメーションを実行する時間
    [UIView setAnimationDuration:0.25];
    //アニメーションイベントを受け取るview
    [UIView setAnimationDelegate:self];
    //アニメーション終了後に実行される
    //[UIView setAnimationDidStopSelector:@selector(endAnimation)];
    [droidView setAlpha:1.0];
    // アニメーション開始
    [UIView commitAnimations];
    LOG(@"APPER NEW DROID: %@", [droidView description]);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    LOG_METHOD
    switch (buttonIndex) {
        case 1:
            [self startGameCountStart];
            break;
        default:
            [self dismissModalViewControllerAnimated:YES];
            break;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // 背景色を黒に
        self.view.backgroundColor = [UIColor blackColor];
        
        // 始まりまでのカウントダウンを表示
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [_textLabel setText:@"3"];
        [_textLabel setFont:[UIFont systemFontOfSize:120.0]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:_textLabel];
        
        // 開始後に経過時間を表示
        _timeCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320-50-100, 20)];
        [_timeCountTextLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_timeCountTextLabel setTextColor:[UIColor whiteColor]];
        [_timeCountTextLabel setBackgroundColor:[UIColor clearColor]];
        [_timeCountTextLabel setTextAlignment:UITextAlignmentRight];
        [self.view addSubview:_timeCountTextLabel];
        
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        [_scoreLabel setFont:[UIFont systemFontOfSize:24.0]];
        [_scoreLabel setTextColor:[UIColor whiteColor]];
        [_scoreLabel setBackgroundColor:[UIColor clearColor]];
        [_scoreLabel setTextAlignment:UITextAlignmentLeft];
        [self.view addSubview:_scoreLabel];        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startGameCountStart];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    LOG_METHOD
    [super dealloc];
    
    [_scoreLabel release];
    [_textLabel release];
    [_timeCountTextLabel release];
    [_droidViewsDic release];
}

@end

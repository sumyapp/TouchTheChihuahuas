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
- (void)gameTimeControlTask:(NSTimer*)timer;
- (void)gameScoreControlTask:(id)sender;
- (void)moveDroids;
- (void)addDroid;
@end

@implementation TTDGameViewController
@synthesize destroyNormDroidCount = _destroyNormDroidCount;

- (void)droidViewTouched:(TTDDroidView*)droidView {
    LOG_METHOD
    LOG(@"Droid[%d] is touched", droidView.number);
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
    _apperdDroidCount = 0;
    _droidControlCount = 0;
    _gamePlayingTimeCountTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(gameTimeControlTask:) userInfo:nil repeats:YES];
}

- (void)gameTimeControlTask:(NSTimer*)timer {
    _gamePlayingTimeCount += 0.01;
    [_timeCountTextLabel setText:[NSString stringWithFormat:@"%.2f", _gamePlayingTimeCount]];
    
    // テストのためコメントアウト
    _nextDroidApperCount -= 0.01;
    if(_nextDroidApperCount <= 0) {
        [self addDroid];
        _nextDroidApperCount = 0;
    }
    
    if(_nextDroidApperCount == 0) {
        srand(time(NULL));//被らない数値を渡して初期化
        switch (rand() % 6) {
            case 0:
                _nextDroidApperCount = 0.5;
                break;
            case 1:
                _nextDroidApperCount = 1.0;
                break;
            case 2:
                _nextDroidApperCount = 1.5;
                break;
            case 3:
                _nextDroidApperCount = 2.0;
            case 4:
                _nextDroidApperCount = 2.5;
                break;
            case 5:
                _nextDroidApperCount = 3.0;
                break;
            default:
                LOG(@"WARNING: this swich section not use");
                _nextDroidApperCount = 1.0;
                break;
        }
    }
    
    _droidControlCount += 1;
    if(_droidControlCount % 10 == 0) {
        [self moveDroids];
        _droidControlCount = 0;
    }
}

- (void)gameScoreControlTask:(id)sender {
    LOG_METHOD
}

- (void)moveDroids {
    if(!_droidViewsDic) {
        return;
    }
    
    for (NSNumber *droidViewKey in _droidViewsDic) {
        TTDDroidView *droidView = [_droidViewsDic objectForKey:droidViewKey];
        
        // droidViewを目的地の方向にxy共にvelocity分進める
        float distance = sqrt( (droidView.targetPosX - droidView.frame.origin.x) * (droidView.targetPosX- droidView.frame.origin.x) +
                              (droidView.targetPosY - droidView.frame.origin.y) * (droidView.targetPosY - droidView.frame.origin.y) );
        float movedDistance = distance - droidView.velocity;
        float moveUnit = movedDistance / distance;
        CGRect movedFrame;
        //LOG(@"distance = %f, this droid is %@", distance, [droidView description]);
        if(isnan(distance) || isinf(distance)) {
            LOG(@"WARNING: a value is NaN or Inf");
            break;
        }        
        
        // 進行方向が右向き
        if(droidView.targetPosX > [droidView orgFrame].origin.x) {
            // 進行方向が下向き
            if(droidView.targetPosY > [droidView orgFrame].origin.y) {
                LOG(@"DROIDS[%d] is MOVE[%.1f]:→↓, moveUnit = %f, dist(%f=>%f)", droidView.number, distance - movedDistance, moveUnit, distance, movedDistance);
                movedFrame = CGRectMake(droidView.frame.origin.x + droidView.velocity, droidView.frame.origin.y + droidView.velocity, droidView.frame.size.width, droidView.frame.size.height);
            }
            //進行方向が上向き
            else {
                LOG(@"MOVE:→↑");
            }
        }
        // 進行方向が左向き
        else {
            // 進行方向が下向き
            if(droidView.targetPosY > [droidView orgFrame].origin.y) {
                LOG(@"MOVE:←↓");
            }
            //進行方向が上向き
            else {
                LOG(@"MOVE:←↑");
            }
        }
        [droidView setFrame:movedFrame];                
        
        BOOL isDroidViewInvisible = NO;
        // xがプラス方向に範囲外
        if(droidView.frame.origin.x + droidView.frame.size.width > 320) {
            // yがプラス方向に範囲外
            if(droidView.frame.origin.y + droidView.frame.size.height > 460){
                isDroidViewInvisible = YES;
            }
            // yがマイナス方向に範囲外
            else if(droidView.frame.origin.y - droidView.frame.size.height < 0) {
                isDroidViewInvisible = YES;
            }
        }
        // xがマイナス方向に範囲外
        else if(droidView.frame.origin.x - droidView.frame.size.width < 0) {
            // yがプラス方向に範囲外
            if(droidView.frame.origin.y + droidView.frame.size.height > 460){
                isDroidViewInvisible = YES;
            }
            // yがマイナス方向に範囲外
            else if(droidView.frame.origin.y - droidView.frame.size.height < 0) {
                isDroidViewInvisible = YES;
            }                
        }
        if(isDroidViewInvisible && distance < 300) {
            LOG(@"RELEASE DROID[%d]", droidView.number);
            [droidView removeFromSuperview];
            [_droidViewsDic removeObjectForKey:droidViewKey];
        }
    }
    
}


- (void)addDroid {
    LOG_METHOD
    // Droidのサイズを決定
    srand(time(NULL));//被らない数値を渡して初期化
    float droidWidth, droidHeight;
    do {
        droidWidth = rand() % 100;
    } while (droidWidth < 30);
    droidHeight = droidWidth * 1.80;
    
    // Droidの始点を8点のうちどこかを決定, それに合わせて目的地店とdroidの回転角度も設定
    float droidPosX, droidPosY;
    float droidTargetPosX, droidTargetPosY, droidAngle;
    // TODO:テスト用
//    switch (rand() % 8) {
    switch (0) {
        case 0:
            droidPosX = 0 - droidWidth;
            droidPosY = 0 - droidHeight;
            droidTargetPosX = 320 + droidWidth;
            droidTargetPosY = 460 + droidHeight;
            droidAngle = 180 - 45;
            break;
        case 1:
            droidPosX = 160 - droidWidth/2;
            droidPosY = 0 - droidHeight;
            droidTargetPosX = 160 - droidWidth/2;
            droidTargetPosY = 460 + droidHeight;
            droidAngle = 180;
            break;
        case 2:
            droidPosX = 320;
            droidPosY = 0 - droidHeight;
            droidTargetPosX = 0 - droidWidth;
            droidTargetPosY = 460 + droidHeight;
            droidAngle = 180 + 45;
            break;
        case 3:
            droidPosX = 320;
            droidPosY = 230 - droidWidth/2;
            droidTargetPosX = 0 - droidHeight;
            droidTargetPosY = 230 - droidWidth/2;
            droidAngle = (-90);
            break;
        case 4:
            droidPosX = 320;
            droidPosY = 460 + droidHeight;
            droidTargetPosX = 0 - droidWidth;
            droidTargetPosY = 0 - droidHeight;
            droidAngle = (-45);
            break;
        case 5:
            droidPosX = 160 - droidWidth/2;
            droidPosY = 460;
            droidTargetPosX = 160 - droidWidth/2;
            droidTargetPosY = 0 - droidHeight;
            droidAngle = 0;
            break;
        case 6:
            droidPosX = 0 - droidWidth;
            droidPosY = 460;
            droidTargetPosX = 320 + droidWidth;
            droidTargetPosY = 0 - droidHeight;
            droidAngle = 45;
            break;
        case 7:
            droidPosX = 0 - droidHeight;
            droidPosY = 230 - droidWidth/2;
            droidTargetPosX = 320 + droidHeight;
            droidTargetPosY = 230 - droidWidth/2;
            droidAngle = 90;
            break;
        default:
            LOG(@"WARNING: this swich section not use");
            break;
    }    
    // Droidの進行速度を設定
    float droidVelocity = 1.0;
    
    
    // Droidのインスタンス化、設定設定
    TTDDroidView *droidView = [[TTDDroidView alloc] initWithFrame:CGRectMake(droidPosX, droidPosY, droidWidth, droidHeight)];
    [droidView setTargetPosX:droidTargetPosX];
    [droidView setTargetPosY:droidTargetPosY];
    [droidView setAngle:droidAngle];
    [droidView setVelocity:droidVelocity];
    [droidView setNumber:_apperdDroidCount];
    [droidView setDelegate:self];

    
    // Droidを表示
    if(!_droidViewsDic) {
        _droidViewsDic = [[NSMutableDictionary alloc] init];
    }
    [_droidViewsDic setObject:droidView forKey:[NSNumber numberWithInt:_apperdDroidCount]];
    [self.view addSubview:droidView];
    
    LOG(@"APPER NEW DROID: %@", [droidView description]);
    
    _apperdDroidCount += 1;
    
//    // TODO:
//    // テストのため、UIViewのAnimationを使ってみる
//    //アニメーションの対象となるコンテキスト
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [UIView beginAnimations:nil context:context];
//    //アニメーションを実行する時間
//    [UIView setAnimationDuration:5.0];
//    //アニメーションイベントを受け取るview
//    //[UIView setAnimationDelegate:self];
//    //アニメーション終了後に実行される
//    //[UIView setAnimationDidStopSelector:@selector(endAnimation)];
//    
//    //TODO:
//    [droidView setFrame:CGRectMake(droidTargetPosX, droidTargetPosY, droidWidth, droidHeight)];
//    // アニメーション開始
//    [UIView commitAnimations];
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
        _timeCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320-50, 32)];
        [_timeCountTextLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeCountTextLabel setTextColor:[UIColor whiteColor]];
        [_timeCountTextLabel setBackgroundColor:[UIColor clearColor]];
        [_timeCountTextLabel setTextAlignment:UITextAlignmentRight];
        [self.view addSubview:_timeCountTextLabel];
        
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
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown:) userInfo:nil repeats:YES];
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
}

@end

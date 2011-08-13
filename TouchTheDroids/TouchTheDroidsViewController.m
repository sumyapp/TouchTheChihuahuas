//
//  TouchTheDroidsViewController.m
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TouchTheDroidsViewController.h"

@implementation TouchTheDroidsViewController

- (void)reportScore:(float)score forCategory:(NSString*)category
{ 
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            //報告エラーの処理
            LOG(@"ERROR MESSAGE");
        } else {
            LOG(@"MAYBE OK");//console に"多分OK"を出力
            NSMutableDictionary *highScoreDataSet = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HIGH_SCORE_DATA_%@", category]]];
            if(highScoreDataSet != nil) {
                // 未送信の最高スコアがあれば、それを送信する。
                if(![highScoreDataSet objectForKey:@"HIGH_SCORE_ALREADY_SEND"]) {
                    [highScoreDataSet setObject:[NSNumber numberWithBool:YES] forKey:@"HIGH_SCORE_ALREADY_SEND"];
                    [highScoreDataSet setObject:[NSDate date] forKey:@"HIGH_SCORE_SEND_DATE"];
                }
            }
        }
    }];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [self dismissModalViewControllerAnimated: YES];
    [viewController release];
}

- (BOOL)isGameCenterAPIAvailable {
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported); 
}

- (void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            // 認証済みプレーヤーの追加タスクを実行する
        }
    }];
}

- (IBAction)changeDroidColorButtonDown:(id)sender {
    LOG_METHOD
    
    switch (_colorType) {
        case droid_Green:
            _colorType = droid_GColor;
            break;
        case droid_GColor:
            _colorType = droid_Green;
            break;
        default:
            _colorType = droid_Green;
            break;
    }
    
    switch (_colorType) {
        case droid_Green:
            [droidCenterImageView setImage:[UIImage imageNamed:@"droid_green.png"]];
            [droidLeftBottomImageView setImage:[UIImage imageNamed:@"droid_green_rotate.png"]];
            break;
        case droid_GColor:
            [droidCenterImageView setImage:[UIImage imageNamed:@"droid_gcolor.png"]];
            [droidLeftBottomImageView setImage:[UIImage imageNamed:@"droid_gcolor_rotate.png"]];
            break;
        default:
            break;
    }
}

- (IBAction)startGameButtonTouchUpInside:(id)sender {
    LOG_METHOD
    TTDGameViewController *ttdGameViewController = [[[TTDGameViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [ttdGameViewController setDestroyNormDroidCount:25];
    [ttdGameViewController setMissDroidDestroyPenalty:2.25];
    [ttdGameViewController setColorType:_colorType];
    if ([ttdGameViewController respondsToSelector:@selector(setModalPresentationStyle:)]) {
        [ttdGameViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    }
        [self presentModalViewController:ttdGameViewController animated:YES];
}

- (IBAction)showLeaderboardButtonTouchUpInside:(id)sender {
    LOG_METHOD
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL) 
    {
        //leaderboardController.category = self.currentLeaderBoard;
        //leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self; 
        [self presentModalViewController:leaderboardController animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    LOG_METHOD
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *highScoreData = [defaults objectForKey:@"HIGH_SCORE_DATA_world_ranking_25droids"];
    if(highScoreData != nil) {
        // 未送信の最高スコアがあれば、それを送信する。
        if(![[highScoreData objectForKey:@"HIGH_SCORE_ALREADY_SEND"] boolValue]) {
            [self reportScore:[[highScoreData objectForKey:@"HIGH_SCORE"] floatValue] * 100
                  forCategory:@"world_ranking_25droids"];            
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self isGameCenterAPIAvailable]){        
        // ユーザのGameCenter認証
        [self authenticateLocalPlayer];
    }
    else {
        // ボタンを隠す
        [showLeaderboardButton setHidden:YES];
    }

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

@end

//
//  TouchTheDroidsViewController.m
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TouchTheDroidsViewController.h"

@implementation TouchTheDroidsViewController

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

- (void) showLeaderboard;
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL) 
    {
        //leaderboardController.category = self.currentLeaderBoard;
        //leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self; 
        [self presentModalViewController: leaderboardController animated: YES];
    }
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
    [self setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:ttdGameViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self isGameCenterAPIAvailable]){
        [self authenticateLocalPlayer];
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

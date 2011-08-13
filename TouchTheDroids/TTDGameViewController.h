//
//  TTDGameViewController.h
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TTDDroidView.h"
#define DROID_COUNT_MARGIN 5
#define DROID_ASPECT_RATIO 1.20

@interface TTDGameViewController : UIViewController<UIAlertViewDelegate, TTDDroidViewDelegate> {
    UILabel *_scoreLabel;
    UILabel *_textLabel;
    UILabel *_timeCountTextLabel;

    int _apperdDroidCount;
    int _destroyedDroidCount;
    int _droidControlCount;
    float _nextDroidApperCount;
    float _gamePlayingTimeCount;
    NSTimer *_gamePlayingTimeCountTimer;
    NSMutableDictionary *_droidViewsDic;
    NSMutableArray *_animatingDroidViews;
    
    int _colorType;
    int _destroyNormDroidCount;
    float _missDroidDestroyPenalty;
}
@property int colorType;
@property int destroyNormDroidCount;
@property float missDroidDestroyPenalty;
@end

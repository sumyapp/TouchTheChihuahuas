//
//  TTDGameViewController.h
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TTDDroidView.h"

@interface TTDGameViewController : UIViewController<TTDDroidViewDelegate> {
    UILabel *_textLabel;
    UILabel *_timeCountTextLabel;
    int _destroyNormDroidCount;
    int _apperdDroidCount;
    int _destroyedDroidCount;
    float _nextDroidApperCount;
    float _gamePlayingTimeCount;
    NSTimer *_gamePlayingTimeCountTimer;
    
    NSMutableDictionary *_droidViewsDic;
}
@property int destroyNormDroidCount;
@end

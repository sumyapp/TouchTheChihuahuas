//
//  TouchTheDroidsViewController.h
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "TTDGameViewController.h"

@interface TouchTheDroidsViewController : UIViewController {
    IBOutlet UIImageView *droidCenterImageView;
    IBOutlet UIImageView *droidLeftBottomImageView;
    int _colorType;
}
- (IBAction)startGameButtonTouchUpInside:(id)sender;
- (IBAction)changeDroidColorButtonDown:(id)sender;
@end

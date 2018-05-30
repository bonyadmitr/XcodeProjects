//
//  VirPilot.h
//  VPilot
//
//  Created by Kokorin Konstantin on 31.10.13.
//
//

#import <Foundation/Foundation.h>
#import "RWPilot.h"

@interface VirPilot : NSObject <RWPilot>

@property (assign, nonatomic) CGRect robotRect;
@property (assign, nonatomic) CGSize fieldSize;

@end

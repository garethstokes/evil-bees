//
//  HelloWorldLayer.h
//  evil-bees
//
//  Created by gareth stokes on 3/11/10.
//  Copyright digital five 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) move;

@end
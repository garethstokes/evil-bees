//
//  HelloWorldLayer.m
//  evil-bees
//
//  Created by gareth stokes on 3/11/10.
//  Copyright digital five 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "CCTouchDispatcher.h"
#import "Bee.h"

CCLabel* status;


// HelloWorld implementation
@implementation HelloWorld

@synthesize bee=_bee;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
    // register to receive targeted touch events
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0
                                              swallowsTouches:YES];
    self.bee = [[Bee alloc] init];

    
		// Add the sprite as a child of the sheet, so that it knows where to get its image data.
    [self addChild:[_bee sheet]];
    
    // create and initialize a Label
		status = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:16];
    
		// position the label on the center of the screen
		status.position = ccp(350, 20);
		
		// add the label as a child to this Layer
		[self addChild: status];
  }
	return self;
}

-(void) draw
{
//  [status setString:[_bee status]];
//
//  for (int i = 0; i < [_path count]; i++) {
//    NSValue* val = [_path objectAtIndex:i];
//    CGPoint p = [val CGPointValue];
//    ccDrawPoint(p);
//  }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {  
  CGPoint point = [touch locationInView:[touch view]];
  NSLog(@"ccTouchBegan %d, %d", point.y, point.x);
  [_bee startPoint:CGPointMake(point.y, point.x)];
  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {

  CGPoint point = [touch locationInView:[touch view]];
  NSLog(@"ccTouchMoved %d, %d", point.y, point.x);
  [_bee addPoint:CGPointMake(point.y, point.x)];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  NSLog(@"ccTouchEnded");
  [_bee move];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end

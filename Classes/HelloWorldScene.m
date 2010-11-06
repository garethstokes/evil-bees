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
#import "Flower.h"
#import "SimpleAudioEngine.h"

CCLabel* status;


// HelloWorld implementation
@implementation HelloWorld

@synthesize currentBee=_currentBee;

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
    // create a TMX map
    CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:@"grass.tmx"];
    [self addChild:map z:-10];
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.05];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"118_loop1_grandpa-is-scheming-again_0017.wav"];
    
    // register to receive targeted touch events
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0
                                              swallowsTouches:YES];
    _bees = [[NSMutableArray alloc] init];
    _flowers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 2; i++) {
      Bee *bee = [[[Bee alloc] init] autorelease];
      [_bees addObject:bee];
      // Add the sprite as a child of the sheet, so that it knows where to get its image data.
      [self addChild:[bee sheet]];
    }

    // create and initialize a Label
		status = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:16];
    
		// position the label on the center of the screen
		status.position = ccp(350, 20);
		
    // add the label as a child to this Layer
	 	[self addChild:status];
    
    [self schedule: @selector(tick:) interval:0.5];
  }
	return self;
}

- (void) tick: (ccTime) dt
{
  // removed flowers marked for removal
  NSMutableArray *removeIndexes = [[NSMutableArray alloc] init];
  for (int i = 0; i < [_flowers count]; i++) {
    Flower *flowerForRemoval = [_flowers objectAtIndex:i];
    if ([flowerForRemoval toBeRemoved]) {
      [removeIndexes addObject:[NSNumber numberWithInt:i]];
    }
    //[flowerForRemoval release];
  }
  
  for (NSNumber *i in removeIndexes) {
    [_flowers removeObjectAtIndex:[i intValue]];
  }
  
  [removeIndexes release];
  
  // check if bee is above a flower.
  for (Bee* bee in _bees)
  {
    for (Flower *flower in _flowers)
    {
      if ([flower hasBee]) {
        
        if ([flower removeBeeIfHasFinished])
        {
          [self removeChild:flower cleanup:YES];
          [flower markForRemoval];
        }
      }
      else if([bee isAbove:flower]) 
      {
        [bee attachTo:flower]; 
      }
      
    }
  }
  
  // set a flower if we need to. 
  if (rand() % 15 == 1) {
    
    // calculate a position on the grid to set flower
    // between x[1-15] and y[1-10]
    
    int x = rand() % 15;
    int y = rand() % 10;
    
    Flower *f = [[Flower alloc] initBleh];
    f.position = ccp((x * 32) + 16, (y * 32) + 16);
    [_flowers addObject:f];
    [self addChild:f z:-1];
    
    return;
  }
}

-(void) draw
{
  for (Bee *bee in _bees) {
    NSArray *path = [bee path];
    if ([path count] == 0) continue;

    //for (int i = 0; i < [path count]; i++) {
//      NSValue* val = [path objectAtIndex:i];
//      CGPoint p = [val CGPointValue];
//      ccDrawPoint(p);
//    }
    
    CGPoint last = ccp(0, 0);
    for (int i = 0; i < [path count]; i++) {
      NSValue* val = [path objectAtIndex:i];
      CGPoint p = [val CGPointValue];
      if (last.y == 0 && last.x == 0) {
        last = p;
      }
      ccDrawLine(ccp(last.x, last.y), ccp(p.x, p.y));
      last = p;
    }
  }
  
  int total = 0;
  for (Bee *bee in _bees)
  {
    total = total + [bee points];
  }
  [status setString:[NSString stringWithFormat:@"points: %d", total]];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {  
  CGPoint point = [touch locationInView:[touch view]];
//  NSLog(@"ccTouchBegan %f, %f", point.y, point.x);
    for (Bee *bee in _bees) {

    CCSprite *sprite = [bee sprite];

    CGPoint beePoint = [sprite convertTouchToNodeSpace:touch];

//    NSLog(@"convertTouchToNodeSpace %f, %f", beePoint.x, beePoint.y);
    CGSize size = [sprite contentSize];
    
    if (beePoint.x > 0 && beePoint.x < size.width && beePoint.y > 0 && beePoint.y < size.height) {
      [bee startPoint:CGPointMake(point.y, point.x)];
      _currentBee = bee;
      break;
    }
  }

  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  if (_currentBee == nil) {
    return;
  }
  
  CGPoint point = [touch locationInView:[touch view]];
  //NSLog(@"ccTouchMoved %f, %f", point.y, point.x);
  
  [_currentBee addPoint:CGPointMake(point.y, point.x)];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
//  NSLog(@"ccTouchEnded");
  [_currentBee move];
  _currentBee = nil;
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

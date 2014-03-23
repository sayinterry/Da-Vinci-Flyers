 /*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim, Andreas Loew 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

//  Updated by Andreas Loew on 20.06.11:
//  * retina display
//  * framerate independency
//  * using TexturePacker http://www.texturepacker.com

#import "GameLayer.h"
#import "Bullet.h"
#import "BulletCache.h"
#import "PlayerEntity.h"
#import "GenericMenuLayer.h"
#import "InputLayer.h"
#import "EnemyCache.h"
#import "MainLayer.h"

@interface GameLayer (PrivateMethods)
-(void) preloadParticleEffects:(NSString*)particleFile;
@end

@implementation GameLayer


static CGRect screenRect;


static GameLayer* instanceOfGameLayer;

@synthesize score, distanceTraveled, intDistance, inBossFight, totaltime, battleHasBegun, bombType;


//this allows other classes in your project to query the GameLayer for the screenRect
+(CGRect) screenRect
{
	return screenRect;
}


//If another class wants to get a reference to this layer, they can by calling this method
+(GameLayer*) sharedGameLayer
{
	NSAssert(instanceOfGameLayer != nil, @"GameLayer instance not yet initialized!");
	return instanceOfGameLayer;
}

-(id) init
{
	if ((self = [super init]))
	{
        //this line initializes the instanceOfGameLayer variable such that it can be accessed by the sharedGameLayer method
		instanceOfGameLayer = self;
		self.inBossFight = NO;
		bossesKilled = 0;
		bombType = nil;
		playerBombParticleBatch = [CCParticleBatchNode batchNodeWithFile:@"fx-playerBombParticle.png"];
		eBulletParticleBatch = [CCParticleBatchNode batchNodeWithFile:@"fx-eBulletDie.png"];
		
		self.intDistance = 0;
		
		[self preloadParticleEffects:@"fx-explosion.plist"];
		[self preloadParticleEffects:@"fx-playerBomb.plist"];
		[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
		
		CCParticleSystemQuad *system = [CCParticleSystemQuad particleWithFile:@"fx-playerBomb.plist"];
        system.positionType = kCCPositionTypeFree;
        system.position = ccp(MAX_INT, MAX_INT);
		system.autoRemoveOnFinish = YES;
		[playerBombParticleBatch addChild:system];
		
		[self addChild:playerBombParticleBatch];

        //get the rectangle that describes the edges of the screen
        CGSize screenSize = [MainLayer screenRect].size;
		CGSize gameScreenSize = CGSizeMake(screenSize.width,screenSize.height-[[[MainLayer sharedLayer] getChildByTag:151] contentSize].height);
        [self setPosition:ccp(0,0)];
        [self setContentSize:gameScreenSize];
		screenRect = CGRectMake(0, 0, gameScreenSize.width, gameScreenSize.height);
		PlayerEntity* player = [PlayerEntity createEntity];
		[player setPosition: ccp(screenSize.width*0.15f, screenSize.height/2)];
		[self addChild:player z:2 tag:1];
		[player setShipType:[[MainLayer sharedLayer] getShipType]];
		[[MainLayer sharedLayer] setHealth:[player checkHitpoints]];
        
        EnemyCache* enemyCache = [EnemyCache node];
		[self addChild:enemyCache z:2 tag:3];
        
        BulletCache* bulletCache = [BulletCache node];
		[self addChild:bulletCache z:1 tag:2];
        
        InputLayer* inputLayer = [InputLayer node];
		[self addChild:inputLayer z:1 tag:4];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamePaused) name:@"GamePaused" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameResumed) name:@"GameResumed" object:nil];
		
		[self scheduleUpdate];
    }
	return self;
}

-(void) playerHitBomb {
	bombType = nil;
	self.isBombed = YES;
	CCParticleSystem* system = [CCParticleSystemQuad particleWithFile:@"fx-playerBomb.plist"];
	system.positionType = kCCPositionTypeFree;
	system.position = [CCDirector sharedDirector].screenCenter;
	system.autoRemoveOnFinish = YES;
	
	[playerBombParticleBatch addChild:system];
	[self performSelector:@selector(setIsBombed:) withObject:NO afterDelay:2];
}

-(void) gamePaused {
	[self pauseSchedulerAndActions];
	[[MainLayer sharedLayer] pauseButtonPressed];
}

-(void) gameResumed {
	[self resumeSchedulerAndActions];
}

-(void) resetGame {
	self.gameIsOver = false;
	bossesKilled = 0;
	totaltime = 0;
	distanceTraveled = 0;
	intDistance = 0;
	battleHasBegun = false;
	inBossFight = false;
	self.isBombed = false;
	bombType = nil;
	[[self getChildByTag:1] removeFromParentAndCleanup:YES];
	[[self getChildByTag:2] removeFromParentAndCleanup:YES];
	[[self getChildByTag:3] removeFromParentAndCleanup:YES];
	[[self getChildByTag:4] removeFromParentAndCleanup:YES];
	[self removeChild:gameOverLabel cleanup:YES];
	[self removeChild:tapToContLabel cleanup:YES];
	PlayerEntity* player = [PlayerEntity createEntity];
	[player setPosition: ccp(screenRect.size.width*0.15f, screenRect.size.height/2)];
	[self addChild:player z:0 tag:1];
	[[MainLayer sharedLayer] setHealth:[player checkHitpoints]];
	
	EnemyCache* enemyCache = [EnemyCache node];
	[self addChild:enemyCache z:2 tag:3];
	
	BulletCache* bulletCache = [BulletCache node];
	[self addChild:bulletCache z:1 tag:2];
	
	InputLayer* inputLayer = [InputLayer node];
	[self addChild:inputLayer z:1 tag:4];
	
	for (NSInteger i=2; i<4; i++) {
		[[NSNotificationCenter defaultCenter] addObserver:[self getChildByTag:i] selector:@selector(gamePaused) name:@"GamePaused" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:[self getChildByTag:i] selector:@selector(gameResumed) name:@"GameResumed" object:nil];
	}
	
	[self unscheduleUpdate];
}

-(void) gameOver {
	self.gameIsOver = true;
	tapToContLabel = [CCLabelTTF labelWithString:@"Tap anywhere to continue." fontName:@"arial" fontSize:10];
	gameOverLabel = [CCLabelTTF labelWithString:@"Game Over." fontName:@"arial" fontSize:40];
	CCFadeIn *fadeAction = [CCFadeIn actionWithDuration:2.2f];
	CCFadeIn *fadeAction2 = [CCFadeIn actionWithDuration:2.2f];
	gameOverLabel.position = ccp(screenRect.size.width*0.5f, screenRect.size.height*0.5f);
	tapToContLabel.position = ccpSub(ccp(screenRect.size.width*0.5f, screenRect.size.height*0.5f), ccp(0,30));
	[gameOverLabel setOpacity:0.0];
	[tapToContLabel setOpacity:0.0];
	[self addChild:tapToContLabel z:3 tag:99];
	[self addChild:gameOverLabel z:3 tag:100];
	[gameOverLabel runAction:fadeAction2];
	[tapToContLabel runAction:fadeAction];
//	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
//	NSMutableArray *scoreArray = [[pref arrayForKey:@"highscores"] copy];
//	[scoreArray addObject:[NSNumber numberWithInt:score]];
//	NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
//	[scoreArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
//	[pref setObject:scoreArray forKey:@"highscores"];
//	[pref synchronize];
}

-(void) bossIsSpawned:(EnemyTypes)bossType {
	self.inBossFight = true;
	if (bossType == EnemyTypeBoss1) {
		bossNameLabel = [CCLabelBMFont labelWithString:@"WARNING: CORNDOG CARL" fntFile:@"avenir24.fnt"];
	} else if (bossType == EnemyTypeBoss2) {
		bossNameLabel = [CCLabelBMFont labelWithString:@"WARNING: BILLY BURGER" fntFile:@"avenir24.fnt"];
	} else if (bossType == EnemyTypeBoss3) {
		bossNameLabel = [CCLabelBMFont labelWithString:@"WARNING: FREDDY FRENCHFRY" fntFile:@"avenir24.fnt"];
	}
	[bossNameLabel setOpacity:0.0];
	bossNameLabel.position = ccp(screenRect.size.width*0.5f, screenRect.size.height*0.5f);
	bossNameLabel.scale = 2.2f;
	[self addChild:bossNameLabel z:3];
	id fadeAction = [CCFadeIn actionWithDuration:4.0];
	id moveAction = [CCMoveTo actionWithDuration:1.2f position:ccp(screenRect.size.width*0.5f, screenRect.size.height-bossNameLabel.contentSize.height*2.f)];
	id fadeOutAction = [CCFadeOut actionWithDuration:3.4];
	[bossNameLabel runAction:[CCSequence actions:fadeAction, moveAction, fadeOutAction,[CCCallBlock actionWithBlock:^{
		self.battleHasBegun = true;
	}], nil]];
}

-(int) getBossesKilled {
	return bossesKilled;
}

-(void) update:(ccTime)delta {
	if (!self.inBossFight && [self defaultShip].checkHitpoints >= 0 && !self.gameIsOver) {
		intDistance++;
		float floatDistance = intDistance;
		distanceTraveled = floatDistance*(2.f/15.f);
		[[MainLayer sharedLayer] setDistance:distanceTraveled];
	} else if (self.inBossFight && self.battleHasBegun) {
		
	}
}

-(void) bossKilled {
	intDistance += 22;
	battleHasBegun = false;
	inBossFight = false;
	bossesKilled++;
	[self update:0];
	[[self bulletCache] deleteAllEnemyBullets];
}

-(void) preloadParticleEffects:(NSString*)particleFile
{
	[CCParticleSystem particleWithFile:particleFile];
}

-(PlayerEntity*) defaultShip {
	CCNode* node = [self getChildByTag:1];
	NSAssert([node isKindOfClass:[PlayerEntity class]], @"node is not a ShipEntity!");
	return (PlayerEntity*)node;
}

-(BulletCache*) bulletCache
{
	CCNode* node = [self getChildByTag:2];
	NSAssert([node isKindOfClass:[BulletCache class]], @"not a BulletCache");
	return (BulletCache*)node;
}

-(EnemyCache*) enemyCache
{
	CCNode* node = [self getChildByTag:3];
	NSAssert([node isKindOfClass:[EnemyCache class]], @"not a BulletCache");
	return (EnemyCache*)node;
}

-(void) dealloc {
	instanceOfGameLayer = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
#ifndef KK_ARC_ENABLED
	// don't forget to call "super dealloc"
	[super dealloc];
#endif // KK_ARC_ENABLED
}

@end

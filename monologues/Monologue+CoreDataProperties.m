//
//  Monologue+CoreDataProperties.m
//  Yorick
//
//  Created by TerryTorres on 2/8/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "Monologue+CoreDataProperties.h"

@implementation Monologue (CoreDataProperties)

+ (NSFetchRequest<Monologue *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Monologue"];
}

@dynamic age;
@dynamic author;
@dynamic favorite;
@dynamic gender;
@dynamic length;
@dynamic notes;
@dynamic period;
@dynamic tags;
@dynamic text;
@dynamic title;
@dynamic tone;

@end

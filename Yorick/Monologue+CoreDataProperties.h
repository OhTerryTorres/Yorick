//
//  Monologue+CoreDataProperties.h
//  Yorick
//
//  Created by TerryTorres on 2/8/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "Monologue+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Monologue (CoreDataProperties)

+ (NSFetchRequest<Monologue *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *age;
@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSNumber *favorite;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *length;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *period;
@property (nullable, nonatomic, copy) NSString *tags;
@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *tone;

@end

NS_ASSUME_NONNULL_END

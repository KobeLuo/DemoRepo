//
//  SimpleCVLayoutAttr.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/19/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "SimpleCVLayoutAttr.h"

@implementation SimpleCVLayoutAttr

- (instancetype)init {
	
	if (!(self = [super init])) { return nil; }
	
	self.minimumInteritemSpacing = 10;
//	self.minimumLineSpacing = 20;
	self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
	self.itemSize = CGSizeMake(10, 100);
	self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
	
	NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
	
	NSMutableArray *newAttrs = [NSMutableArray array];
	
	for (UICollectionViewLayoutAttributes * attr in attrs) {
		
		UICollectionViewLayoutAttributes *newAttr = [attr copy];
		if (newAttr.representedElementKind == nil) {
			
//			newAttr.transform = CGAffineTransformMakeRotation(45);
		}
		
		[newAttrs addObject:newAttr];
	}
	
	return newAttrs;
}

@end

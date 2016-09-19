//
//  StyleVerticalCollectionTableViewCell.m
//  EVYbook
//
//  Created by roomlinksaas_dev on 8/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "StyleVerticalCollectionTableViewCell.h"
#import "StyleVerticalCollectionViewCell.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "DetailBookViewController.h"

@implementation StyleVerticalCollectionTableViewCell{
    double CellHeight;
    double CellWidth;
}
@synthesize arrBook,CollectionStyleVertical,indexRow;

- (void)awakeFromNib {
    [super awakeFromNib];
    CellWidth = 110;
    CellHeight = 140;
    
    self.CollectionStyleVertical.dataSource = self;
    self.CollectionStyleVertical.delegate = self;
    self.CollectionStyleVertical.backgroundColor = [UIColor clearColor];
    static NSString *identifier1 = @"identifierStyleCollectionVerticalCell";
    
    UINib *nib1 = [UINib nibWithNibName:@"StyleVerticalCollectionViewCell" bundle:nil];
    [self.CollectionStyleVertical registerNib:nib1 forCellWithReuseIdentifier:identifier1];
    [self.CollectionStyleVertical reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arrBook count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier1 = @"identifierStyleCollectionVerticalCell";
    StyleVerticalCollectionViewCell *cell = (StyleVerticalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
    [cell.imgCover setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrBook objectAtIndex:indexPath.row] objectForKey:@"coverfilename"]]]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CellWidth, CellHeight);
}

#pragma mark - When Selected Collection View Cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate showSelected:indexPath indexRows:indexRow];
}


@end

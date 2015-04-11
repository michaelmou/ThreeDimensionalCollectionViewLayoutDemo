//
//  ThreeDimensionalCollectionViewLayout.swift
//
//  Created by MichaelMou on 15/4/9.
//  Copyright (c) 2015年 MichaelMou.GuangZhou.China
//  to connect me sanding e-mail to michaelmou@sina.cn, i will look up your message soon and upgrate the version
//  You can use , copy , modify this source code you anyway want
//

import UIKit

@objc class ThreeDimensionalCollectionViewLayout: UICollectionViewLayout {
    
    var images:Array<UIImage>!
    private var spacingOfInteritem:CGFloat = 50
    private let defaultWidthOfItem:CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds)/3.2
    private let zoom_factor:CGFloat = 0.3
    private let inset:UIEdgeInsets = UIEdgeInsetsMake(-30, CGRectGetWidth(UIScreen.mainScreen().bounds)/4 as CGFloat, 0, CGRectGetWidth(UIScreen.mainScreen().bounds)/4 as CGFloat)
    private let distanceLimitted:CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds)/2.7826

    override func collectionViewContentSize() -> CGSize {
        
        if let numberOfItem = self.collectionView?.numberOfItemsInSection(0){
            
            var size = CGSizeZero
            for index in 0...numberOfItem-1 {
                var attributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
                size.width += spacingOfInteritem
                size.width += attributes.size.width
            }
            size.width += spacingOfInteritem + inset.left + inset.right
            size.height = CGRectGetHeight(self.collectionView!.bounds)
            
            return size;
        }else{
            return CGSizeZero
        }
        
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
//        build a normal horizontal cell
        var imageOfCurrent = self.images[indexPath.row]
        if imageOfCurrent.size.height > defaultWidthOfItem {
            
            var sizeOfImage = imageOfCurrent.size
            var size = CGSizeMake(defaultWidthOfItem, defaultWidthOfItem * sizeOfImage.width/sizeOfImage.height)
            attributes.size = size
        }else{
            attributes.size = imageOfCurrent.size;
        }
        
        var positionX:CGFloat = spacingOfInteritem + inset.left
        if indexPath.row > 0 {
            for index in 1...indexPath.row{
                var sizeOfItem = attributes.size
                positionX += sizeOfItem.width
                positionX += spacingOfInteritem
            }
        }
        attributes.frame.origin.x = positionX
        attributes.center.y = CGRectGetHeight(self.collectionView!.bounds)/2
        attributes.frame.origin.y += inset.top
        
//          zoom by off-center distance
        var visibleRect:CGRect? = CGRectZero
        visibleRect?.origin = self.collectionView!.contentOffset
        visibleRect?.size = self.collectionView!.bounds.size
        let activeDistance:CGFloat = 100
        
//        calculated the value of distance from the attribute to visibleRect center
        var distance = CGRectGetMidX(visibleRect!) - attributes.center.x
        var normalizedDistance = distance / activeDistance
        var zoom:CGFloat = 1 + self.zoom_factor * (1 - abs(normalizedDistance))
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
        
//        tranfsorm to display 3d effect
        var transformY:CGFloat = 1
        let scaleOfTransformY:CGFloat = 2.8
        if distance > distanceLimitted{
            transformY = distance - distanceLimitted
            transformY *= scaleOfTransformY
            if var cell = self.collectionView?.cellForItemAtIndexPath(indexPath){
                if var view = self.collectionView!.viewWithTag(indexPath.row) {
                    self.collectionView!.sendSubviewToBack(cell)
                }
            }
        }else if distance < -distanceLimitted{
            transformY = distance + distanceLimitted
            transformY *= scaleOfTransformY
            
            if var cell = self.collectionView?.cellForItemAtIndexPath(indexPath){
                if var view = self.collectionView!.viewWithTag(indexPath.row) {
                    self.collectionView!.sendSubviewToBack(cell)
                }
            }
        }
        
//        Gradually transparent; change the alpha that feels distance changing
        let alphaLimitted:CGFloat = 250
        if abs(distance) <= alphaLimitted{
            let alpha:CGFloat = abs(alphaLimitted - abs(distance))/alphaLimitted
            attributes.alpha = alpha
        }else if abs(distance) > alphaLimitted{
            attributes.alpha = 0
        }
        
        attributes.transform3D = CATransform3DTranslate(attributes.transform3D, transformY ,(0 - (1 * (abs(distance) - activeDistance)))/3, 1)
        attributes.zIndex = 1
        
        return attributes
    }
    
//    normal setting
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributesArray = NSMutableArray()
        var numberOfSections = self.collectionView!.numberOfSections()
        for i in 0...numberOfSections-1{
            var numberOfCellsInSection:Int = self.collectionView!.numberOfItemsInSection(i)
            for j in 0...numberOfCellsInSection-1{
                var indexPath = NSIndexPath(forItem: j, inSection: i)
                var attributes = self.layoutAttributesForItemAtIndexPath(indexPath)
                if (CGRectIntersectsRect(rect, attributes.frame)) {
                    attributesArray.addObject(attributes)
                }
            }
        }
        return  attributesArray as [AnyObject]
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat(MAXFLOAT)
        var horizontalCenter:CGFloat = proposedContentOffset.x + (CGRectGetWidth(self.collectionView!.bounds) / 2.0)
        
        var targetRect:CGRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
        var array:Array = self.layoutAttributesForElementsInRect(targetRect)!
        
        for layoutAttributes in array{
            
            var itemHorizontalCenter:CGFloat = layoutAttributes.center.x;
            let a = abs(itemHorizontalCenter - horizontalCenter)
            let b = abs(offsetAdjustment)
            if a < b {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        
        }
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    }
}

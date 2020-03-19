//
//  WaterFlowLayout.swift
//  Banner
//
//  Created by ATH on 2020/3/18.
//  Copyright © 2020 sco. All rights reserved.
//

import UIKit
protocol WaterFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets;
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterFlowLayout, itemHeightAtIndex: IndexPath) -> CGFloat;
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterFlowLayout, columnCountForSectionAt section: Int) -> Int;
    func collectionView(_ collectionView: UICollectionView, layout maxCountColumn: WaterFlowLayout) -> Int;
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterFlowLayout, interitemSpacingForSection section: Int) -> CGFloat;
}
class WaterFlowLayout: UICollectionViewFlowLayout {
    var attributes:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes] ()
    var columnHeights:[[CGFloat]]?
    var contentHeight:CGFloat = 0
    var delegate:WaterFlowLayoutDelegate?
  
    override func prepare() {
        super.prepare()
        contentHeight = 0
        attributes.removeAll()
//        columnHeights.removeAll()
        
        let maxCountColumn = self.delegate!.collectionView(self.collectionView!, layout:self)
        let sectionCount = self.collectionView!.numberOfSections;
        columnHeights = [[CGFloat]](repeating: [CGFloat](repeating: 0, count: maxCountColumn), count:sectionCount)
        for section in 0..<sectionCount{
            print("section:\(section)")
            let edgeInset:UIEdgeInsets! = self.delegate?.collectionView(self.collectionView!, layout: self, insetForSectionAt:section) ?? UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
            
            let supplementaryViewIndexPath = IndexPath(item: 0, section: section)
            let headAtttri:UICollectionViewLayoutAttributes? = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at:supplementaryViewIndexPath)
            let columnCount:Int = (self.delegate?.collectionView(self.collectionView!, layout: self, columnCountForSectionAt:section))!
            
            var y:CGFloat = 0
            if section>0{
                y = maxYInSection(section: section-1)
              
            }else{
                y = edgeInset.top
            }
            if headAtttri != nil{
                var headFrame = headAtttri!.frame
               
                headFrame.origin.y = y
                headAtttri?.frame = headFrame
                for index in 0..<columnCount{
                    self.columnHeights![section][index] = headFrame.maxY
                }
                self.attributes.append(headAtttri!)
            }else{
                
                for index in 0..<columnCount{
                    self.columnHeights![section][index] = y
                }
            }
            
            let numberOfItem = self.collectionView!.numberOfItems(inSection: section)
            for index in 0..<numberOfItem{
                let indexPath = IndexPath(item:index, section: section)
                let attris = self.layoutAttributesForItem(at: indexPath)
                self.attributes.append(attris!)
            }
            
            let footerAtttri:UICollectionViewLayoutAttributes? = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at:supplementaryViewIndexPath)
            if footerAtttri != nil{
                var footerFrame = footerAtttri!.frame
                footerFrame.origin.y = maxYInSection(section: section) + self.minimumLineSpacing
                footerAtttri?.frame = footerFrame
                for index in 0..<columnCount{
                    self.columnHeights![section][index] = footerFrame.maxY + self.minimumLineSpacing
                }
                self.attributes.append(footerAtttri!)
                self.contentHeight = footerFrame.maxY + edgeInset.bottom
            }else {
                let maxY:CGFloat = maxYInSection(section: section) + self.minimumLineSpacing
                for index in 0..<columnCount{
                    self.columnHeights![section][index] = maxY
                }
                self.contentHeight = maxY + edgeInset.bottom
            }
        }
        
        
    }
    func maxYInSection(section:Int) -> CGFloat {
        if(section<0){
            return 0;
        }
        var maxY:CGFloat = 0
        let columnCount:Int = self.delegate!.collectionView(self.collectionView!, layout: self, columnCountForSectionAt:0)
        for index in 0..<columnCount{
            let y = self.columnHeights![section][index]
            if(y>maxY){
                maxY = y
            }
        }
        return maxY
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attris = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let edgeInset:UIEdgeInsets! = self.delegate?.collectionView(self.collectionView!, layout: self, insetForSectionAt:0) ?? UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        let columnCount:Int = self.delegate!.collectionView(self.collectionView!, layout: self, columnCountForSectionAt:indexPath.section)
        let interitemSpacing:CGFloat = self.delegate?.collectionView(self.collectionView!, layout:self, interitemSpacingForSection: indexPath.section) ?? self.minimumInteritemSpacing
        
        var contentW = self.collectionView!.frame.width - edgeInset.left-edgeInset.right
        contentW = contentW - CGFloat((columnCount - 1)) * interitemSpacing
        let itemW:CGFloat =  contentW/CGFloat(columnCount)
        
        let itemH:CGFloat = self.delegate!.collectionView(self.collectionView!, layout:self, itemHeightAtIndex:indexPath)
        
        var column = 0
        var minMaxY:CGFloat = CGFloat.greatestFiniteMagnitude
        for index in 0..<columnCount{
            let maxY:CGFloat = self.columnHeights![indexPath.section][index]
            if(minMaxY > maxY){
                minMaxY = maxY
                column = index
            }
        }
        let itemX = edgeInset.left + CGFloat(column) * (itemW + interitemSpacing)
        var itemY = minMaxY
        if itemY != edgeInset.top{
            itemY += self.minimumLineSpacing
        }
        attris.frame = CGRect(x:itemX,y:itemY,width:itemW,height: itemH)
    
        columnHeights![indexPath.section][column] = attris.frame.maxY
        return attris
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributes 
    }
    
    override open var collectionViewContentSize: CGSize {
        get{
            return CGSize(width:self.collectionView!.frame.width,height: self.contentHeight)
        }
        
        
    }
    
}

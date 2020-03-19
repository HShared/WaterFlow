//
//  WaterFlowSimpleView.swift
//  Banner
//
//  Created by ATH on 2020/3/19.
//  Copyright © 2020 sco. All rights reserved.
//

import UIKit
class CollectionHeaderView: UICollectionReusableView {
    var label:UILabel?
    
    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame:frame)
        label?.textColor = UIColor.black
        label?.font = UIFont.systemFont(ofSize: 18)
        label?.textAlignment = NSTextAlignment.center
        addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = self.bounds
    }
}
class CollectionFooterView: UICollectionReusableView {
    var label:UILabel?
    
    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame:frame)
        label?.textColor = UIColor.black
        label?.font = UIFont.systemFont(ofSize: 18)
        label?.textAlignment = NSTextAlignment.center
        addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = self.bounds
    }
    
    
    
}

class CollectionViewCell: UICollectionViewCell {
    var label:UILabel?
    
    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame:frame)
        label?.textColor = UIColor.black
        label?.font = UIFont.systemFont(ofSize: 14)
        label?.textAlignment = NSTextAlignment.center
        addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = self.bounds
    }
    
    
    
}

class WaterFlowSimpleView:  UIView,UICollectionViewDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate,UICollectionViewDelegateFlowLayout{
    let reuseIdentifier = "UICollectionViewCellId"
    let headerReuseIdentifier = "CollectionHeaderViewId"
    let footerReuseIdentifier = "CollectionFooterViewId"
    var layout:WaterFlowLayout = {
        var layout = WaterFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        //          layout.headerReferenceSize = CGSize.init(width: 300, height: 80)
        return layout
    }()
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        collectionView = UICollectionView(frame:frame, collectionViewLayout: layout)
        super.init(frame: frame)
        layout.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier:reuseIdentifier)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.register(CollectionFooterView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        
    }
    
    // MARK: -
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:reuseIdentifier, for: indexPath) as! CollectionViewCell
        let randomR:CGFloat = CGFloat(arc4random()%10)/10.0
        let randomG:CGFloat = CGFloat(arc4random()%10)/10.0
        let randomB:CGFloat = CGFloat(arc4random()%10)/10.0
        cell.backgroundColor = UIColor(red:randomR, green: randomG, blue: randomB, alpha: 1)
         cell.label?.text = String.init(format: "section:%d row:%d",indexPath.section,indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return  CGSize.init(width: collectionView.frame.width, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return  CGSize.init(width:collectionView.frame.size.width, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView:CollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! CollectionHeaderView
            headerView.backgroundColor = UIColor.red
            headerView.label?.text = String.init(format: "Header Section:%d ",indexPath.section)
            return headerView
        }else{
            let footerView:CollectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! CollectionFooterView
            footerView.backgroundColor = UIColor.orange
            footerView.label?.text = String.init(format: "Footer Section:%d ",indexPath.section)
            return footerView
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterFlowLayout, itemHeightAtIndex: IndexPath) -> CGFloat {
        let randomH:CGFloat = CGFloat(arc4random()%100 + 70)
        return randomH
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterFlowLayout, columnCountForSectionAt section: Int) -> Int {
        if section == 0{
            return 2
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterFlowLayout, interitemSpacingForSection section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout maxCountColumn: WaterFlowLayout) -> Int {
        return 3
    }
    
}

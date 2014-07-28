//
//  EmpathyListCell.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 28..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class EmpathyListCell: SBTableViewCell {
    var thumbnailView: UIImageView
    var titleLabel: UILabel
    var rankLabel: UILabel
    var titleQuery:String = ".tit_empathy"
    var thumbnailQuery:String = ""
    
    init() {
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, 80, 43))
        
        titleLabel = UILabel.boldFontLabel("", fontSize: 11)
        titleLabel.textAlignment = .Left
        
        rankLabel = UILabel.boldFontLabel("", fontSize: 11)
        
        super.init(style: .Default, reuseIdentifier: EpisodeListCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        self.addSubview(rankLabel)
    }
    
    override func update(data: TFHppleElement) {
        super.update(data)
        
        if let imageUrl = thumbnailUrl() {
            thumbnailView.setImageWithURL(NSURL(string: imageUrl))
        }
        
        if let title = titleString() {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Top, offset: CGPointMake(5, 8))
        }
        
        if let sympathy_count = sympathyCount() {
            var heartLabel = UILabel.boldFontLabel("♥", fontSize: 11)
            heartLabel.sizeToFit()
            heartLabel.layoutBottomFromSibling(titleLabel, horizontalAlign: .Left, offset: CGPointMake(0, 3))
            heartLabel.textColor = UIColor.redColor()
            self.addSubview(heartLabel)
            
            rankLabel.text = sympathy_count as NSString
            rankLabel.sizeToFit()
            rankLabel.layoutRightFromSibling(heartLabel, verticalAlign: .Center, offset: CGPointMake(3, 0))
        }
    }
    
    override func titleString() -> NSString? {
        return data?.itemWithQuery(".tit_empathy")?.text().trim()
    }
    
    override func thumbnailUrl() -> NSString? {
        var imageElement:TFHppleElement = data?.itemWithQuery(".thumb_img") as TFHppleElement
        return imageElement.imageUrlFromHppleElement()
    }
    
    func sympathyCount() -> NSString? {
        return data?.itemWithQuery(".ico_sympathy")?.text().trim()
    }
}
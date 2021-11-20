//
//  SongsCollectionViewCell.swift
//  API Project
//
//  Created by Roman on 09.10.2021.
//
import UIKit
import EasyPeasy

class SongsCollectionViewCell: UICollectionViewCell {
    
    let nameSongLabel =  UILabel(text: "Name song label")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        self.addSubview(nameSongLabel)
        nameSongLabel.easy.layout(Top(),Left(5),Right(5),Bottom())
    }
}

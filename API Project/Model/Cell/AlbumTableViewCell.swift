//
//  AlbumTableViewCell.swift
//  API Project
//
//  Created by Roman on 09.10.2021.
//


import UIKit
import EasyPeasy

class AlbumTableViewCell: UITableViewCell {
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let albumLabel =  UILabel(text: "Name album label")
    let artistNameLabel =  UILabel(text: "Name artist name")
    let trackCountLabel =  UILabel(text: "0 tracks", alignment: .center)
    
    var stackView = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.width/2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        albumLabel.font = UIFont.systemFont(ofSize: 20)
        artistNameLabel.font  = UIFont.systemFont(ofSize: 16)
        trackCountLabel.font  = UIFont.systemFont(ofSize: 16)
        backgroundColor = .clear
        selectionStyle = .none
        
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(iconImageView)
        addSubview(albumLabel)
        stackView = UIStackView(arrangedSubviews: [artistNameLabel,trackCountLabel], axis: .horizontal, spacing: 10, distribution: .equalCentering)
        addSubview(stackView)
        
        iconImageView.easy.layout(CenterY(),Left(15), Height(60),Width(60))
        albumLabel.easy.layout(Top(10), Left(10).to(iconImageView, .right), Right(10))
        stackView.easy.layout(Top(10).to(albumLabel, .bottom),Left(10).to(iconImageView, .right), Right(10))
    }
    
    func configureAlbumCell(album: Album) {
        //MARK: - request to take image from URL
        if let urlString = album.artworkUrl100 {
            NetworkRequest.shared.requestData(urlString: urlString) { result in
                switch result {
                case.success(let data):
                    let image = UIImage(data: data)
                    self.iconImageView.image = image
                case.failure(let error):
                    self.iconImageView.image = nil
                    print("no album icon" + error.localizedDescription)
                }
            }
        } else {
            iconImageView.image = nil
        }
        
        albumLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) tracks"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

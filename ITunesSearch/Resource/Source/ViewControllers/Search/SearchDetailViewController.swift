//
//  SearchDetailViewController.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/8/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class SearchDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private let appNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
    }
    
    private let appIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .systemMint
        $0.layer.cornerRadius = 8
    }
    
    private let downloadButton = UIButton().then {
        $0.setTitle("받기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = 16
    }
    
    private let data: ItunesItem
    
    init(data: ItunesItem) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setData()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        [appIconImageView, appNameLabel, downloadButton].forEach {
            scrollView.addSubview($0)
        }
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        appIconImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.size.equalTo(100)
            make.bottom.equalTo(scrollView.contentLayoutGuide).inset(20)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(appNameLabel)
            make.bottom.equalTo(appIconImageView)
            make.width.equalTo(72)
            make.height.equalTo(32)
        }
    }
    
    private func setData() {
        let url = URL(string: data.artworkUrl60)
        appIconImageView.kf.setImage(with: url)
        appNameLabel.text = data.trackName
    }
}

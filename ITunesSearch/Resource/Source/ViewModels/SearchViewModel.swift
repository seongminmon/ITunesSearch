//
//  SearchViewModel.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private var itunesList = [ItunesItem]()
    
    struct Input {
        let searchText: ControlProperty<String?>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let itunesList: PublishSubject<[ItunesItem]>
        let startNetworking: PublishSubject<Void>
        let endNetworking: PublishSubject<Void>
        let failureNetworking: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let itunesList = PublishSubject<[ItunesItem]>()
        let startNetworking = PublishSubject<Void>()
        let endNetworking = PublishSubject<Void>()
        let failureNetworking = PublishSubject<String>()
        
        let query = input.searchButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
        
        query
            .subscribe(with: self, onNext: { owner, text in
                startNetworking.onNext(())
            })
            .disposed(by: disposeBag)
        
//        query
//            .flatMap { NetworkManager.shared.callRequest($0) }
//            .subscribe(with: self) { owner, result in
//                endNetworking.onNext(())
//                switch result {
//                case .success(let value):
//                    owner.itunesList = value.results
//                    itunesList.onNext(owner.itunesList)
//                case .failure(let error):
//                    if let description = error.errorDescription {
//                        failureNetworking.onNext(description)
//                    } else {
//                        failureNetworking.onNext("알 수 없는 에러")
//                    }
//                }
//            }
//            .disposed(by: disposeBag)
        
        query
            .flatMap { NetworkManager.shared.callRequestWithObservable($0) }
            .subscribe(with: self) { owner, result in
                endNetworking.onNext(())
                switch result {
                case .success(let value):
                    owner.itunesList = value.results
                    itunesList.onNext(owner.itunesList)
                case .failure(let error):
                    if let description = error.errorDescription {
                        failureNetworking.onNext(description)
                    } else {
                        failureNetworking.onNext("알 수 없는 에러")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            itunesList: itunesList,
            startNetworking: startNetworking,
            endNetworking: endNetworking,
            failureNetworking: failureNetworking
        )
    }
}

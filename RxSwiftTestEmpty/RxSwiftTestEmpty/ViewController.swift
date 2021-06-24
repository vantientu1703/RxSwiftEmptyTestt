//
//  ViewController.swift
//  RxSwiftTestEmpty
//
//  Created by Văn Tiến Tú on 24/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.button.rx.tap
            .asObservable()
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .empty() }
                return self.random()
                    .asObservable()
                    .catch { _ in
                        return .empty()
                    }
            }
            .flatMap { [weak self] _  -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.request()
                    .asObservable()
            }
            .subscribe(onNext: { _ in
                print("")
            })
            .disposed(by: self.disposeBag)
    }
    
    func random() -> Single<Bool> {
        return Single.create { observer in
            let value = Bool.random()
            if value {
                observer(.success(value))
            } else {
                observer(.failure(GError()))
            }
            return Disposables.create()
        }
    }
    
    func request() -> Single<Void> {
        return Single.create { observer in
            observer(.success(()))
            return Disposables.create()
        }
    }
}

struct GError: Error {
    init() {
        
    }
}


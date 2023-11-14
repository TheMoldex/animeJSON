//
//  ViewController.swift
//  json+collections
//
//  Created by Денис Сташков on 12.11.2023.
//

import UIKit
// MARK: - Enums
enum Alert {
    case success
    case failed
    
    var title: String {
        
        switch self {
        case .success:
            "success"
        case .failed:
            "failed"
        }
    }
    
    var message: String {
        
        switch self {
        case .success:
            "u can see RESULTS in the debug area"
        case .failed:
            " u can see ERROR in the debug area"
        }
    }
}
enum actionListWithCollectionView : CaseIterable{
    case first
    case second
    case third
    
    var animeList: String {
        switch self {
        case .first:
            "Anime"
        case .second:
            "Persona"
        case .third:
            "Say"
        }
        
    }
}

// MARK: - VC
final class CheckJsonViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var connectIMage: UIImageView!
    @IBOutlet weak var fromAnimeAPI: UICollectionView!
    
    // MARK: - Private properties
    private let collectionsLabels = actionListWithCollectionView.allCases
    private let networkManager = NetworkManager.shared
    private var animeTitles:[String] = ["", "", ""]
    // MARK: - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        connectIMage.isHidden = true
        fromAnimeAPI.isHidden = true
    }
    
    // MARK: - IBActions
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        fetchImage()
    }
    
    @IBAction func getWisdomButtonPressed(_ sender: UIButton) {
        fetchRandomAnimeQuote()
        fromAnimeAPI.isHidden = false
    }
    
    // MARK: - Private func's
    private func showAlert(with status: Alert) {
    let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true)
    }
    
}
// MARK: - UICollectionViewDataSource
extension CheckJsonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionsLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        
        cell.UserCell.text = animeTitles[indexPath.item]
        collectionView.reloadData()
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension CheckJsonViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 5, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isEditing = false
    }
}

// MARK: - Networking
extension CheckJsonViewController {
    private func fetchImage() {
        networkManager.fetchImage(from: networkManager.imageURL) {[unowned self] result in
            switch result {
            case .success(let data):
                connectIMage.image = UIImage(data: data)
                connectIMage.isHidden = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchRandomAnimeQuote() {
        networkManager.fetchRandomAnimeQuote(from: networkManager.animeLink) {[unowned self] result in
            switch result {
            case .success(let anime):
                animeTitles = [anime.anime, anime.character, anime.quote]
                print(anime)
                showAlert(with: .success)
            case .failure(let error):
                showAlert(with: .failed)
                print(error)
            }
        }
    }
}

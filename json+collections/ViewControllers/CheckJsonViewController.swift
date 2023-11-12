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
enum actionListWithCollectionView : String, CaseIterable{
    case first = "Get anime"
    case second = "пустое поле"
    case third = "в разработке"
}

// MARK: - VC
final class CheckJsonViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var connectIMage: UIImageView!
    
    // MARK: - Private properties
    private let collectionsLabels = actionListWithCollectionView.allCases
    private let imageURL = URL(string: "https://cdn.pixabay.com/photo/2012/03/01/01/42/hands-20333_960_720.jpg")!
    private let animeLink = URL(string: "https://animechan.xyz/api/random")!
    
    // MARK: - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        connectIMage.isHidden = true
    }
    
    // MARK: - IBActions
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        fetchImage()
    }
    
    // MARK: - Private func's
    private func showAlert(with status: Alert) {
    let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default)
    alert.addAction(okAction)
    present(alert,animated: true)
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
        cell.UserCell.text = collectionsLabels[indexPath.item].rawValue
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
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tapToItem = collectionsLabels[indexPath.item]
        
        switch tapToItem {
        case .first:
          fetchRandomAnimeQuote()
        case .second:
        print("кнопка в разработке")
        case .third:
        print("кнопка в разработке")
        }
    }
}

// MARK: - Networking
extension CheckJsonViewController {
    private func fetchImage() {
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard  let data = data else {
                print(error?.localizedDescription ?? "Non error")
                return
            }
            guard let imageConnect = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.connectIMage.image = imageConnect
                self.connectIMage.isHidden = false
            }
        }.resume()
    }
    
    private func fetchRandomAnimeQuote() {
        URLSession.shared.dataTask(with: animeLink) { data, _, error in
            guard  let data = data else {
                print(error?.localizedDescription ?? " Oh no!")
                return
            }
            do {
                let randomAnime = try JSONDecoder().decode(Anime.self, from: data)
                print(randomAnime)
                DispatchQueue.main.async {
                    self.showAlert(with: .success)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.showAlert(with: .failed)
                }
                print(error.localizedDescription)
            }
        }.resume()
    }
}

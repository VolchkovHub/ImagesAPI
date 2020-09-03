//
//  ViewController.swift
//  ImagesAPI
//
//  Created by Fedya on 01.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import UIKit
import ReactiveSwift

class ImagesVC: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let cellIdentifier = "ImageTVC"
    private let viewModel = ImagesVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupTable()
        setupObservers()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        view.addSubview(searchBar)
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupTable() {
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupObservers() {
        viewModel.localPhotos.producer.observe(on: UIScheduler()).startWithValues { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.errorsOutput.observe(on: UIScheduler()).observeValues { [weak self] error in
            let title = "Error"
            let message = error.localizedDescription
            let okButtonTitle = "Ok"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: nil)
            alert.addAction(okAction)
            self?.present(alert, animated: true)
        }
    }
}

extension ImagesVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.searchPhoto(with: searchText)
    }
}

extension ImagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.localPhotos.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let cell = tableCell as? ImageTVC else { return UITableViewCell() }
        cell.configure(with: viewModel.localPhotos.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

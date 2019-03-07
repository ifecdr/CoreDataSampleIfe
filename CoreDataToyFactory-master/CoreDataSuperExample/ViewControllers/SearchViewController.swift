//
//  SearchViewController.swift
//  CoreDataSuperExample
//
//  Created by MAC Consultant on 3/6/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var unfilteredToys = [Toy]()
    var unfilteredGames = [Games]()
    
    var filteredToys = [Toy]()
    var filteredGames = [Games]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar

    }

}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filteredToys.count
        } else if section == 1 {
            return filteredGames.count
        } else {
            return 0
        }
        //return (toys.count + games.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = filteredToys[indexPath.row].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = filteredGames[indexPath.row].name
            return cell
        }
        
    }
}

extension SearchViewController: UITableViewDelegate {
    }

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredToys = unfilteredToys.filter { i in
                return i.name!.contains(searchText.lowercased())
            }
            filteredGames = unfilteredGames.filter { i in
                return i.name!.contains(searchText.lowercased())
            }
            tableView.reloadData()
        }
    }
}

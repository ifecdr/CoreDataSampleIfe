//
//  ToyTableViewController.swift
//  CoreDataSuperExample
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class ToyTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var toys = [Toy]()
    var games = [Games]()
    var service = CoreDataService()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadToys()
        loadGames()
    }
    
    func loadToys() {
        toys = service.loadAllToys()
        tableView.reloadData()
    }
    
    // games
    func loadGames() {
        games = service.loadAllGames()
        tableView.reloadData()
    }
    
    @IBAction func searchBarButtonAction(_ sender: UIBarButtonItem) {
        //toys = service.findAll("Armando")
        //games = service.findAllGames("Ill come back to this")
        self.performSegue(withIdentifier: "search", sender: (toys, games))
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toyDetails" {
            let vc = segue.destination as! ToyViewController
            vc.myToy = sender as? Toy
            vc.service = service
        } else if segue.identifier == "createToy" {
            let vc = segue.destination as! ToyViewController
            vc.service = service
        } else if segue.identifier == "gameDetails" {
            let vc = segue.destination as! GameViewController
            vc.myGame = sender as? Games
            vc.service = service
        } else if segue.identifier == "createGame" {
            let vc = segue.destination as! GameViewController
            vc.service = service
        } else if segue.identifier == "search" {
            let vc = segue.destination as! SearchViewController
            vc.unfilteredToys = toys
            vc.unfilteredGames = games
        }
    }
    

}

extension ToyTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return toys.count
        } else if section == 1 {
            return games.count
        } else {
            return 0
        }
        //return (toys.count + games.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = toys[indexPath.row].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = games[indexPath.row].name
            return cell
        }
        
    }
}

extension ToyTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "toyDetails", sender: toys[indexPath.row])
        } else {
            self.performSegue(withIdentifier: "gameDetails", sender: games[indexPath.row])
        }

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                service.deleteToy(toys[indexPath.row])
                loadToys()
            } else {
                service.deleteGame(games[indexPath.row])
                loadGames()
            }
            
        }
    }
}


//
//  SongsTableViewController.swift
//  SongsApp
//
//  Created by Marc Jackson on 02/12/2017.
//  Copyright © 2017 Marc Jackson. All rights reserved.
//

import UIKit

class SongsTableViewController: UITableViewController {
    
    var songs = [Song]()
    private var cache = NSCache<NSString, UIImage>()

    private func fetchData() {
        let url = URL(string: "http://itunes.apple.com/search?term=beatles&country=us")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {data,response,error in
            if let taskError = error {
                //handle error
                print(taskError.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                switch httpResponse.statusCode {
                    case 200:
                        print("got 200")
                        print("Data: " + String(describing: data))
                        do {
                            try self.parseJsonSerialize(fromUrl: data) //Old style from Swift 3.0
                            //try self.parseJsonObject(fromUrl: data) //New style from Swift 4.0
                        }
                            catch { print ("Cannot parseJson function failed") }
                    default:
                        print("Request Failed: \(httpResponse.statusCode)")
                }
            }
        })
        task.resume()
    }
    /*
    //Using the JSONDecoder object to create an object of Struct Song.
    private func parseJsonObject(fromUrl:Data?) throws {
        songs = []
        
        let decoder = JSONDecoder()
        
        //Method TWO - Using the Decoder - And the Struct DataType
        guard let json = fromUrl,
            let albums = try? decoder.decode(AlbumResponse.self,from:json)
            else {
                print("Could not decode from the AlbumReponse Object")
                //if let error = error { print("ERROR:" + String(describing:error))}
                return
            }
        //Set the song array of struct to the JSON struct
        songs = albums.results
        

            //Not using guard - not using try?
            /*
            do {
                let albums = try decoder.decode(AlbumResponse.self,from:json)
                //print(result)
            } catch {
                print("Could not decode from the data to the AlbumResponse Object")
                throw SerializationError.missing("Decode to Struct AlbumResponse")
                return
            }
            //End of using old style do-catch statement
            */
        

        // NONE OF THIS IS NECESSARY AS THE ARRAY IS BUILT AUTOMATICALLY BY THE OBJECT
            //for case let album in albums.results {
                
                //Build the Song inside the object extension
                //if let song = Song(json: album) { //This extra open bracket is for the nil return from the object
                
                //Build a song object from the array object (album)
                //let song = Song(title:album.title,artist:album.artist,albumName:album.albumName,artworkUrl:album.artworkUrl)
                //songs.append(song)
                //} //This extra close bracket is for the safety nil return from object
            //}
        
        /*
         let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
         for case let result in json["results"] {
         if let restaurant = Restaurant(json: result) {
         restaurants.append(restaurant)
         }
         */
        
        DispatchQueue.main.async {
            // Update the UI
            self.tableView.reloadData()
        }
    
    }
    */
    
    //Using Serialize to create an object from the JSON
    private func parseJsonSerialize(fromUrl:Data?) throws {
        songs = []
        
        
        //METHOD ONE.
        //1a
        guard let data = fromUrl,
            //We are not downcasting here we do it later
            let json:Any = try? JSONSerialization.jsonObject(with: data, options: [])
            else {
                print("ERROR: Cannot Serialise")
                return
            }
        //print (json)
        
        //This is a dictionary [Result:value]
        guard let jsonDict = json as? [String:Any],
            //This is an array of dictionaries [[albumTitle:"Beatles"]]
            let resultsArray = jsonDict["results"] as? [[String:Any]]
            else {
                print("Could not get the resultsArray")
                return
            }
        //Being explicit about the variable type. A dictionary. Swift can infer.
        ////let albums:Dictionary<String,Any> = resultsArray[0] //Not necessary Can use below
        //let firstAlbum = resultsArray[0]
        
        //let artistName = firstAlbum["artistName"] as! String
        //print(artistName)
        //End of Method 1a
        
        
        //1b: After the serialization downcast to the Dictionary
        /*guard let data = fromUrl,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            else {
                print("ERROR. Cannot Serialise")
                return
        }
        //Create the Array of dictionary of Albums
        let resultsArray = json!["results"] as? [[String:AnyObject]]
        let firstAlbum = resultsArray![0]
        //let artistName = firstAlbum["artistName"] as! String
        //print(artistName)
        //End of Method 1b
        */
        
        /*
        //METHOD A
        //NO CLEAR ERROR CHECKING- Just fails in the iteration and goes to next album.
        //Go through the Dictionary Array to build the song array
        for album in resultsArray {
            if let title = album["trackName"] as? String {
                if let artist = album["artistName"] as? String {
                    if let albumName = album["collectionName"] as? String {
                        if let artworkUrl = album["artworkUrl100"] as? String {
                            //Build song object to add to the array.
                            let song = Song(title:title,artist:artist,albumName:albumName,artworkUrl:artworkUrl)
                            songs.append(song)
                        }
                    }
                }
            }
        }
         //END OF METHOD A
        */
        
        
        //METHOD B
        //Go through the object inside the Song Struct Extension
        //If the song cannot be created fails. Passes the message and returns.
        for album in resultsArray {
            do {
                //Use the error THROWS inside the struct to send error to the caller.
                let song = try Song(json:album) //This extra open bracket is for the nil return from the object
                songs.append(song)
            } catch  SongError.recordMissing(let recordName) {
                print("SongError is missing a record: \(recordName)")
                return
            }
        } //This extra close bracket is for the safety nil return from object
        //END OF METHOD B
        
        
        DispatchQueue.main.async {
            // Update the UI
            self.tableView.reloadData()
        }
        
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return airports.count
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //return 1
        
        /*
        //Get an array of all keys( All the section names ) , then make it into an array
        let cityAirport = [String](airports.keys.sorted())
        
        //Using optional get the array of Airport Names for this section(from the function)
        if let arr_AirportNames = airports[cityAirport[section]] {
            return arr_AirportNames.count // Return how many rows for this section
        } else {
            return 0
        }
        */
        return songs.count
        
        
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.title
        cell.detailTextLabel?.text = song.albumName
        
        if let url = URL(string: song.artworkUrl) {

            if let image = cache.object(forKey: url.absoluteString as NSString) {
                cell.imageView?.image = image
            } else {
                DispatchQueue.global(qos: .userInitiated).async {

                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }

                        let image = UIImage(data:data)

                        self.cache.setObject(image!, forKey: url.absoluteString as NSString)

                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [indexPath],with: .automatic)
                        }
                    }.resume()
                }
            }
        }
        
        
        
/*
//https://medium.com/journey-of-one-thousand-apps/caching-images-in-swift-e909a8e5db17
         
let imageCache = NSCache<NSString, UIImage>()
         
 static func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
 if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
 completion(cachedImage, nil)
 } else {
 MTAPIClient.downloadData(url: url) { data, response, error in
 if let error = error {
 completion(nil, error)
 
 } else if let data = data, let image = UIImage(data: data) {
 imageCache.setObject(image, forKey: url.absoluteString as NSString)
 completion(image, nil)
 } else {
 completion(nil, NSError.generalParsingError(domain: url.absoluteString))
 }
 }
 }
 }
 
 */
        
        
        
        /*
        // Configure the cell...
        cell.textLabel?.text = "Row \(indexPath.row)"
        */
 
        //cell.detailTextLabel?.text = "Nothing Done"
        
        //print("The Row is \(indexPath.row)")
        //print("The Section is \(indexPath.section)")
        
        //let detail = self.setSections(titleForHeaderInSection: indexPath.section) ?? ""
        
        //nil coalescing operator
        //let detail = self.tableView(tableView, titleForHeaderInSection: indexPath.section) ?? ""
        //cell.detailTextLabel?.text = "In \(detail)"
        
        //Testing Remove Section function
      
        /*var theCode : String
        let cityAirportCodes = [String](airports.values)
        if indexPath.section < cityAirportCodes.count {
            theCode = cityAirportCodes[indexPath.section]
        } else {
            theCode = "None"
        }*/
        
        /*
        //The airport code
        var theCode : String
        //Get an array of all keys( All the section names ) , then make it into an array
        let cityAirport = [String](airports.keys.sorted())
        
        //Using optional get the array of Airport Names for this section(from the function)
        if let arr_AirportNames = airports[cityAirport[indexPath.section]] {
            theCode = arr_AirportNames[indexPath.row] // What is the value for this row number
        } else {
            theCode = ""
        }
        
        
        cell.detailTextLabel?.text = theCode
        */
 
        return cell

    }
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        //for (airportCode, airportName) in airports {
        //    print("\(airportCode): \(airportName)")
        //}
        
        /*
        //Get the section for this
        let cityAirports = [String](airports.keys.sorted())
        if section < cityAirports.count {
            return cityAirports[section]
        } else {
            return "None"
        }
         */
        return "Beatle Songs"
        
        //if let sectionValue = cityAirports[section] {
            //return sectionValue
        //} else
        
        
//        switch section {
//        case 0:
//            return "Section A"
//        case 1:
//            return "Section B"
//        case 2:
//            return "Section C"
//        default:
//            return nil
//        }
        //return ["Section A","Section B","Section C","Section D","Section E"]
    }

    /*
     override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
       
    }
 */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //let theObject = sender as? UITableViewCell
        
        
        let detailViewController = segue.destination as! SongDetailViewController
        //detailViewController.song = Song(title: "Trippin' on a hole in a paper heart", artist: "Stone Temple Pilots", rating: 4.0, chartPosition: 2)
        //detailViewController.song //This compiles as song is type Song? so if there isn't anything it is nil and acceptable
   
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let song = songs[indexPath.row]
        detailViewController.song = song
        
    }

}

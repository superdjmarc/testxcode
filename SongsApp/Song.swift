//
//  Song.swift
//  SongsApp
//
//  Created by Marc Jackson on 28/12/2017.
//  Copyright © 2017 Marc Jackson. All rights reserved.
//

struct AlbumResponse : Codable {
    let results:[Song]
}
struct Song : Codable {
    enum CodingKeys:String,CodingKey {
        case title = "trackName"
        case artist = "artistName"
        case albumName = "collectionName"
        case artworkUrl = "artworkUrl100"
    }
    var title:String
    var artist:String
    var albumName:String
    var artworkUrl:String
}

enum SongError: Error {
    case recordMissing(recordName:String)
    //case invalid(String, Any)
}

extension Song {
    init(json: [String:Any]) throws {
        
        //Extract the Information into the object
        guard let title = json["trackName"] as? String else {
            throw SongError.recordMissing(recordName:"trackName")
        }
        guard let artist = json["artistName"] as? String else {
            throw SongError.recordMissing(recordName:"artistName")
        }
        guard let albumName = json["collectionName"] as? String else {
            throw SongError.recordMissing(recordName:"collectionName")
        }
        guard let artworkUrl = json["artworkUrl100"] as? String else {
            throw SongError.recordMissing(recordName:"artworkUrl100")
        }
        
        // Initialize properties
        self.title = title
        self.artist = artist
        self.albumName = albumName
        self.artworkUrl = artworkUrl
    }
}
 
/*
    func toJSON() ->[String:Any] {
return["trackName":title,"artistName":artist,"collectionName":albumName,"artworkUrl100":artworkUrl]
    }
 
 DataManager.getJSONFromURL("user") { (data, error) in
 guard let data = data else {
 return
 }
}
 
 enum SerializationError: Error {
 case missing(String)
 case invalid(String, Any)
 }
 
 extension Restaurant {
 init(json: [String: Any]) throws {
 // Extract name
 guard let name = json["name"] as? String else {
 throw SerializationError.missing("name")
 }
 
 // Extract and validate coordinates
 guard let coordinatesJSON = json["coordinates"] as? [String: Double],
 let latitude = coordinatesJSON["lat"],
 let longitude = coordinatesJSON["lng"]
 else {
 throw SerializationError.missing("coordinates")
 }
 
 let coordinates = (latitude, longitude)
 guard case (-90...90, -180...180) = coordinates else {
 throw SerializationError.invalid("coordinates", coordinates)
 }
 
 // Extract and validate meals
 guard let mealsJSON = json["meals"] as? [String] else {
 throw SerializationError.missing("meals")
 }
 
 var meals: Set<Meal> = []
 for string in mealsJSON {
 guard let meal = Meal(rawValue: string) else {
 throw SerializationError.invalid("meals", string)
 }
 
 meals.insert(meal)
 }
 
 // Initialize properties
 self.name = name
 self.coordinates = coordinates
 self.meals = meals
 }
 }
 */

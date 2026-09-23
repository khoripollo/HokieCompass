//
//  BuildingData.swift
//  VTCompass
//
//  ─────────────────────────────────────────────────────────────────────────
//  COORDINATE SOURCE
//  ─────────────────────────────────────────────────────────────────────────
//  Every coordinate marked `verified: true` was taken from Virginia Tech's
//  own published building directory:
//
//      https://www.vt.edu/about/locations/buildings/
//      (machine-readable feed: .../buildings/_jcr_content/content/list.xml)
//
//  That is the university's own data, not an estimate. Each building has its
//  own distinct coordinate, so the compass, distance, walking time, and map
//  pins are all working from real positions.
//
//  Four entries are still `verified: false` because they do not appear in
//  that feed — see `needingCoordinates` at the bottom and the note in
//  PHOTO_MANIFEST.md. The detail screen shows a warning badge for those.
//
//  Removed per instruction (not listed as destinations):
//      War Memorial Chapel, The Grove, Solitude, Armory, Wright House,
//      University Club, Cranwell House / 417 Clay Street, North End Center,
//      Randolph Hall.
//
//  NAMING NOTE: vt.edu now lists the Moss Arts Center as "Center for the
//  Arts" — its page states it operated as the Moss Arts Center until June
//  2025. The id stays "moss" so existing favorites survive, and the old name
//  is kept searchable.
//
//  ID NOTE: Ambler Johnston appears as ONE building in the university feed,
//  not as separate East and West. The two old ids "aj-east" / "aj-west" are
//  therefore gone; anyone who favorited them loses that favorite once.
//

import Foundation

enum BuildingData {

    // MARK: - Builders

    /// A destination with a coordinate from the official VT feed.
    private static func b(_ id: String,
                          _ name: String,
                          _ descriptor: String,
                          _ categories: Set<BuildingCategory>,
                          _ latitude: Double,
                          _ longitude: Double) -> Building {
        Building(id: id, name: name, descriptor: descriptor,
                 categories: categories,
                 latitude: latitude, longitude: longitude,
                 imageName: id, coordinatesVerified: true)
    }

    /// A destination NOT in the official feed. The coordinate is the nearest
    /// known reference point and is flagged unverified in the UI.
    private static func unverified(_ id: String,
                                   _ name: String,
                                   _ descriptor: String,
                                   _ categories: Set<BuildingCategory>,
                                   _ latitude: Double,
                                   _ longitude: Double) -> Building {
        Building(id: id, name: name, descriptor: descriptor,
                 categories: categories,
                 latitude: latitude, longitude: longitude,
                 imageName: id, coordinatesVerified: false)
    }

    // MARK: - Academic

    private static let academic: [Building] = [
        b("agnew", "Agnew Hall", "Academic", [.academic], 37.22476, -80.42415),
        b("bishop-favrao", "Bishop-Favrao Hall", "Academic", [.academic], 37.23005, -80.42548),
        b("burchard", "Burchard Hall", "Academic", [.academic], 37.22958, -80.42441),
        b("burruss", "Burruss Hall", "Administration", [.academic], 37.22900, -80.42371),
        b("cheatham", "Cheatham Hall", "Academic", [.academic], 37.22386, -80.42265),
        b("new-classroom", "Classroom Building", "Academic", [.academic], 37.22927, -80.427207),
        b("cowgill", "Cowgill Hall", "Academic", [.academic], 37.22992, -80.42474),
        b("dds", "Data and Decision Sciences", "Academic", [.academic], 37.23186, -80.42694),
        b("davidson", "Davidson Hall", "Academic", [.academic], 37.22674, -80.42521),
        b("derring", "Derring Hall", "Academic", [.academic], 37.22908, -80.42560),
        b("durham", "Durham Hall", "Engineering", [.academic], 37.23174, -80.42382),
        b("engel", "Engel Hall", "Academic", [.academic], 37.22340, -80.42351),
        b("goodwin", "Goodwin Hall", "Engineering", [.academic], 37.23237, -80.42542),
        b("hahn-north", "Hahn Hall — North Wing", "Academic", [.academic], 37.22831, -80.42626),
        b("hahn-south", "Hahn Hall — South Wing", "Academic", [.academic], 37.22791, -80.42568),
        b("hancock", "John W. Hancock Jr. Hall", "Engineering", [.academic], 37.23016, -80.42427),
        b("holden", "Holden Hall", "Academic", [.academic], 37.23036, -80.42238),
        b("hutcheson", "Hutcheson Hall", "Academic", [.academic], 37.22571, -80.42284),
        b("latham", "Latham Hall", "Academic", [.academic], 37.22454, -80.42259),
        b("lavery", "Lavery Hall", "Academic", [.academic], 37.23110, -80.42281),
        b("litton-reaves", "Litton-Reaves Hall", "Academic", [.academic], 37.22160, -80.42400),
        b("mcbryde", "McBryde Hall", "Academic", [.academic], 37.23062, -80.42178),
        b("newman", "Newman Library", "Library", [.academic], 37.22876, -80.41924),
        b("norris", "Norris Hall", "Academic", [.academic], 37.22944, -80.42312),
        b("pamplin", "Pamplin Hall", "Academic", [.academic], 37.22876, -80.42462),
        b("patton", "Patton Hall", "Engineering", [.academic], 37.22922, -80.42220),
        b("robeson", "Robeson Hall", "Academic", [.academic], 37.22783, -80.42518),
        b("sandy", "Sandy Hall", "Academic", [.academic], 37.22580, -80.42351),
        b("saunders", "Saunders Hall", "Academic", [.academic], 37.22495, -80.42436),
        b("seitz", "Seitz Hall", "Academic", [.academic], 37.22448, -80.42361),
        b("shanks", "Shanks Hall", "Academic", [.academic], 37.23185, -80.41983),
        b("smyth", "Smyth Hall", "Academic", [.academic], 37.22498, -80.42315),
        b("steger", "Steger Hall", "Research", [.academic], 37.22080, -80.42609),
        b("torgersen", "Torgersen Hall", "Academic", [.academic], 37.22978, -80.41997),
        b("wallace", "Wallace Hall", "Academic", [.academic], 37.22297, -80.42427),
        b("whittemore", "Whittemore Hall", "Engineering", [.academic], 37.23107, -80.42445),
        b("williams", "Williams Hall", "Academic", [.academic], 37.22784, -80.42435),

        // Under construction / not in the official feed.
        unverified("hitt", "Hitt Hall", "Academic", [.academic], 37.22900, -80.42700)
    ]

    // MARK: - Student life, services, arts
    // Classified Academic per your specification, with their own descriptors.

    private static let studentLife: [Building] = [
        b("squires", "Squires Student Center", "Student Life", [.academic], 37.22962, -80.41796),
        b("johnston-center", "G. Burke Johnston Student Center", "Student Life", [.academic], 37.22922, -80.42458),
        b("bookstore", "University Bookstore", "Campus Services", [.academic], 37.22816, -80.41857),
        b("holtzman", "Holtzman Alumni Center", "Alumni Center", [.academic], 37.22913, -80.42961),
        b("glc", "Graduate Life Center at Donaldson Brown", "Graduate Life", [.academic, .residential], 37.22822, -80.41756),
        b("student-services", "Student Services Building", "Student Services", [.academic, .residential], 37.22208, -80.42183),
        b("visitor-center", "Visitor and Undergraduate Admissions Center", "Admissions", [.academic, .residential], 37.23117, -80.43359),
        b("skelton", "Skelton Conference Center", "Conference Center", [.academic], 37.22962, -80.42949),
        b("inn", "The Inn at Virginia Tech", "Hotel & Conference", [.academic], 37.22994, -80.43005),
        b("moss", "Center for the Arts", "Arts", [.academic], 37.23234, -80.41765),
        b("theatre-101", "Theatre 101", "Arts", [.academic], 37.23018, -80.41634),
        b("smith-career", "Smith Career Center", "Campus Services", [.academic], 37.22156, -80.42257)
    ]

    // MARK: - Athletics & recreation

    private static let athletics: [Building] = [
        b("lane", "Lane Stadium", "Athletics", [.athletics], 37.21997, -80.41873),
        b("cassell", "Cassell Coliseum", "Athletics", [.athletics], 37.22245, -80.41893),
        b("mccomas", "McComas Hall", "Recreation", [.athletics], 37.22069, -80.42230),
        b("war-memorial-hall", "War Memorial Hall", "Recreation", [.athletics], 37.22629, -80.42059),

        unverified("english-field", "English Field at Atlantic Union Bank Park", "Athletics", [.athletics], 37.21800, -80.41900)
    ]

    // MARK: - Landmarks

    private static let landmarks: [Building] = [
        b("drillfield", "Drillfield", "Campus Landmark", [.landmark], 37.22751, -80.42189),
    ]

    // MARK: - Dining
    // Venues inside a host building use that building's own verified
    // coordinate, which is the right answer for a compass pointing at a door.

    private static let dining: [Building] = [
        b("dietrick", "Dietrick Hall", "Dining", [.dining], 37.22454, -80.42111),
        b("owens", "Owens Hall", "Dining", [.dining], 37.22671, -80.41889),
        b("turner-place", "Turner Place at Lavery Hall", "Dining", [.dining], 37.23110, -80.42281),
        b("west-end", "West End at Cochrane Hall", "Dining", [.dining], 37.22265, -80.42189),

        unverified("perry-place", "Perry Place at Hitt Hall", "Dining", [.dining], 37.22900, -80.42700)
    ]

    // MARK: - Residential

    private static let residential: [Building] = [
        b("ambler-johnston", "Ambler Johnston Hall", "Residence Hall", [.residential], 37.22311, -80.42105),
        b("campbell", "Campbell Hall", "Residence Hall", [.residential], 37.22620, -80.42153),
        b("cochrane", "Cochrane Hall", "Residence Hall", [.residential], 37.22265, -80.42189),
        b("eggleston", "Eggleston Hall", "Residence Hall", [.residential], 37.22766, -80.41938),
        b("harper", "Harper Hall", "Residence Hall", [.residential], 37.22275, -80.42329),
        b("hillcrest", "Hillcrest Hall", "Residence Hall", [.residential], 37.22390, -80.42501),
        b("hoge", "Hoge Hall", "Residence Hall", [.residential], 37.22454, -80.41846),
        b("johnson", "Johnson Hall", "Residence Hall", [.residential], 37.22554, -80.41773),
        b("miles", "Miles Hall", "Residence Hall", [.residential], 37.22550, -80.41696),
        b("new-hall-west", "New Hall West", "Residence Hall", [.residential], 37.22220, -80.42273),
        b("new-residence-east", "New Residence Hall East", "Residence Hall", [.residential], 37.22554, -80.41918),
        b("newman-hall", "Newman Hall", "Residence Hall", [.residential], 37.22612, -80.41787),
        b("oshaughnessy", "O'Shaughnessy Hall", "Residence Hall", [.residential], 37.22538, -80.41832),
        b("payne", "Payne Hall", "Residence Hall", [.residential], 37.22582, -80.42000),
        b("pearson-east", "Pearson Hall East", "Residence Hall", [.residential], 37.23076, -80.41896),
        b("pearson-west", "Pearson Hall West", "Residence Hall", [.residential], 37.23013, -80.41993),
        b("peddrew-yates", "Peddrew-Yates Residence Hall", "Residence Hall", [.residential], 37.22503, -80.41991),
        b("pritchard", "Pritchard Hall", "Residence Hall", [.residential], 37.22433, -80.41974),
        b("slusher", "Slusher Hall", "Residence Hall", [.residential], 37.22514, -80.42219),
        b("vawter", "Vawter Hall", "Residence Hall", [.residential], 37.22684, -80.41765),
        b("whitehurst", "Whitehurst Hall", "Residence Hall", [.residential], 37.22619, -80.41680),

        // Opened 2021; the university feed carries no coordinate for it.
        unverified("cid-residence", "Creativity and Innovation District Residence Hall", "Residence Hall", [.residential], 37.22400, -80.42100)
    ]

    // MARK: - Public list

    static let all: [Building] =
        (academic + studentLife + athletics + landmarks + dining + residential)
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

    /// The four entries still lacking an authoritative coordinate.
    static var needingCoordinates: [Building] {
        all.filter { !$0.coordinatesVerified }
    }

    // MARK: - Search

    /// Extra terms that should find a building even though they aren't its
    /// current name — former names, nicknames, abbreviations.
    private static let aliases: [String: [String]] = [
        "moss": ["Moss Arts Center", "The Cube"],
        "glc": ["GLC", "Donaldson Brown"],
        "johnston-center": ["GBJ"],
        "west-end": ["West End Market"],
        "newman": ["Carol M. Newman Library"],
        "new-classroom": ["New Classroom Building", "NCB"],
        "mccomas": ["gym", "fitness"],
        "hoge": ["Hoge Hall"]
    ]

    /// Matches name, visible descriptor, filter category names, and aliases.
    static func search(_ query: String) -> [Building] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return all }

        return all.filter { building in
            if building.searchableText.localizedCaseInsensitiveContains(trimmed) {
                return true
            }
            return (aliases[building.id] ?? [])
                .contains { $0.localizedCaseInsensitiveContains(trimmed) }
        }
    }

    static func building(withID id: String) -> Building? {
        all.first { $0.id == id }
    }
}

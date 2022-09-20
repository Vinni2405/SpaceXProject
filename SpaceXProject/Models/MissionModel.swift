//
//  MissionModel.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import Foundation

// MARK: - SPACEX V3 API MODELS (Deprecated)

struct Mission: Codable, PropertyLoopable {
    let flightNumber: Int?
    let missionName: String?
    let missionId: [String]?
    let launchYear: String?
    let launchDateUnix: Int?
    let launchDateUtc: String?
    let launchDateLocal: String?
    let isTentative: Bool?
    let tentativeMaxPrecision: String?
    let tbd: Bool?
    let launchWindow: Int?
    let rocket: Rocket?
    let ships: [String]?
    let telemetry: Telemetry?
    let launchSite: LaunchSite?
    let launchSuccess: Bool?
    let launchFailureDetails: LaunchFailureDetails?
    let links: Links?
    let details: String?
    let upcoming: Bool?
    let staticFireDateUtc: String?
    let staticFireDateUnix: Int?
    let timeline: [String:Int?]?
    let crew: [String]?
}

struct Rocket: Codable, PropertyLoopable {
    let rocketId: String?
    let rocketName: String?
    let rocketType: String?
    let firstStage: FirstStage?
    let secondStage: SecondStage?
    let fairings: Fairings?
}

struct FirstStage: Codable, PropertyLoopable {
    let cores: [Core]?
}

struct SecondStage: Codable, PropertyLoopable {
    let block: Int?
    let payloads: [Payload]?
}

struct Core: Codable, PropertyLoopable {
    let coreSerial: String?
    let flight: Int?
    let block: Int?
    let gridfins: Bool?
    let legs: Bool?
    let reused: Bool?
    let landSuccess: Bool?
    let landingIntent: Bool?
    let landingType: String?
    let landingVehicle: String?
}

struct Payload: Codable, PropertyLoopable {
    let payloadId: String?
    let noradId: [Int]?
    let reused: Bool?
    let customers: [String]?
    let nationality: String?
    let manufacturer: String?
    let payloadType: String?
    let payloadMassKg: Double?
    let payloadMassLbs: Double?
    let orbit: String?
    let orbitParams: OrbitParameters?
}

struct OrbitParameters: Codable, PropertyLoopable {
    let referenceSystem: String?
    let regime: String?
    let longitude: Double?
    let semiMajorAxisKm: Double?
    let eccentricity: Double?
    let periapsisKm: Double?
    let apoapsisKm: Double?
    let inclinationDeg: Double?
    let periodMin: Double?
    let lifespanYears: Double?
    let epoch: String?
    let meanMotion: Double?
    let raan: Double?
    let argOfPericenter: Double?
    let meanAnomaly: Double?
}

struct Fairings: Codable, PropertyLoopable {
    let reused: Bool?
    let recoveryAttempt: Bool?
    let recovered: Bool?
    let ship: String?
}

struct Telemetry: Codable, PropertyLoopable {
    let flightClub: String?
}

struct LaunchSite: Codable, PropertyLoopable {
    let siteId: String?
    let siteName: String?
    let siteNameLong: String?
}

struct LaunchFailureDetails: Codable, PropertyLoopable {
    let time: Int?
    let altitude: Int?
    let reason: String?
}

struct Links: Codable, PropertyLoopable {
    let missionPatch: String?
    let missionPatchSmall: String?
    let redditCampaign: String?
    let redditLaunch: String?
    let redditMedia: String?
    let presskit: String?
    let articleLink: String?
    let wikipedia: String?
    let videoLink: String?
    let youtubeId: String?
    let flickrImages: [String]?
}

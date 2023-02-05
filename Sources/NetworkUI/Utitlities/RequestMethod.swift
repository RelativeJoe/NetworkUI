//
//  RequestMethod.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

public enum RequestMethod: Equatable, Sendable {
    case GET
    case PUT
    case ACL
    case HEAD
    case POST
    case COPY
    case LOCK
    case MOVE
    case BIND
    case LINK
    case PATCH
    case TRACE
    case MKCOL
    case MERGE
    case PURGE
    case NOTIFY
    case SEARCH
    case UNLOCK
    case REBIND
    case UNBIND
    case REPORT
    case DELETE
    case UNLINK
    case CONNECT
    case MSEARCH
    case OPTIONS
    case PROPFIND
    case CHECKOUT
    case PROPPATCH
    case SUBSCRIBE
    case MKCALENDAR
    case MKACTIVITY
    case UNSUBSCRIBE
    case SOURCE
}

//MARK: - RawRepresentable
extension RequestMethod: RawRepresentable {
    public var rawValue: String {
        switch self {
            case .GET:
                return "GET"
            case .PUT:
                return "PUT"
            case .ACL:
                return "ACL"
            case .HEAD:
                return "HEAD"
            case .POST:
                return "POST"
            case .COPY:
                return "COPY"
            case .LOCK:
                return "LOCK"
            case .MOVE:
                return "MOVE"
            case .BIND:
                return "BIND"
            case .LINK:
                return "LINK"
            case .PATCH:
                return "PATCH"
            case .TRACE:
                return "TRACE"
            case .MKCOL:
                return "MKCOL"
            case .MERGE:
                return "MERGE"
            case .PURGE:
                return "PURGE"
            case .NOTIFY:
                return "NOTIFY"
            case .SEARCH:
                return "SEARCH"
            case .UNLOCK:
                return "UNLOCK"
            case .REBIND:
                return "REBIND"
            case .UNBIND:
                return "UNBIND"
            case .REPORT:
                return "REPORT"
            case .DELETE:
                return "DELETE"
            case .UNLINK:
                return "UNLINK"
            case .CONNECT:
                return "CONNECT"
            case .MSEARCH:
                return "MSEARCH"
            case .OPTIONS:
                return "OPTIONS"
            case .PROPFIND:
                return "PROPFIND"
            case .CHECKOUT:
                return "CHECKOUT"
            case .PROPPATCH:
                return "PROPPATCH"
            case .SUBSCRIBE:
                return "SUBSCRIBE"
            case .MKCALENDAR:
                return "MKCALENDAR"
            case .MKACTIVITY:
                return "MKACTIVITY"
            case .UNSUBSCRIBE:
                return "UNSUBSCRIBE"
            case .SOURCE:
                return "SOURCE"
        }
    }
    public init(rawValue: String) {
        switch rawValue {
            case "GET":
                self = .GET
            case "PUT":
                self = .PUT
            case "ACL":
                self = .ACL
            case "HEAD":
                self = .HEAD
            case "POST":
                self = .POST
            case "COPY":
                self = .COPY
            case "LOCK":
                self = .LOCK
            case "MOVE":
                self = .MOVE
            case "BIND":
                self = .BIND
            case "LINK":
                self = .LINK
            case "PATCH":
                self = .PATCH
            case "TRACE":
                self = .TRACE
            case "MKCOL":
                self = .MKCOL
            case "MERGE":
                self = .MERGE
            case "PURGE":
                self = .PURGE
            case "NOTIFY":
                self = .NOTIFY
            case "SEARCH":
                self = .SEARCH
            case "UNLOCK":
                self = .UNLOCK
            case "REBIND":
                self = .REBIND
            case "UNBIND":
                self = .UNBIND
            case "REPORT":
                self = .REPORT
            case "DELETE":
                self = .DELETE
            case "UNLINK":
                self = .UNLINK
            case "CONNECT":
                self = .CONNECT
            case "MSEARCH":
                self = .MSEARCH
            case "OPTIONS":
                self = .OPTIONS
            case "PROPFIND":
                self = .PROPFIND
            case "CHECKOUT":
                self = .CHECKOUT
            case "PROPPATCH":
                self = .PROPPATCH
            case "SUBSCRIBE":
                self = .SUBSCRIBE
            case "MKCALENDAR":
                self = .MKCALENDAR
            case "MKACTIVITY":
                self = .MKACTIVITY
            case "UNSUBSCRIBE":
                self = .UNSUBSCRIBE
            case "SOURCE":
                self = .SOURCE
            default:
                self = .GET
        }
    }
}

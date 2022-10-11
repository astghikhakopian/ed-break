//
//  Images.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI

extension Image {
    
    public struct Background {
        
        public static var backgroundEcliipse1: Image {
            return Image("background_ecliipse_1")
        }
        public static var backgroundEcliipse2: Image {
            return Image("background_ecliipse_2")
        }
        public static var backgroundEcliipse3: Image {
            return Image("background_ecliipse_3")
        }
        public static var back: Image {
            return Image("back")
        }
    }
    
    public struct FamilySharing {
        public static var settings: Image {
            return Image("familySharing.settings")
        }
        public static var returnBack: Image {
            return Image("familySharing.returnBack")
        }
        public static var familySharing: Image {
            return Image("familySharing.familySharing")
        }
        public static var appleId: Image {
            return Image("familySharing.appleId")
        }
        public static var addChild: Image {
            return Image("familySharing.addChild")
        }
        public static var info: Image {
            return Image("familySharing.info")
        }
    }
    
    public struct QRCode {
        public static var qrCode: Image {
            return Image("qrCode.qrCode")
        }
    }
    
    public struct ChildDetails {
        public static var uploadPlaceholder: Image {
            return Image("childDetails.upload.placeholder")
        }
    }
    
    public struct TabView {
        public struct Dashboard {
            public static var selected: Image {
                return Image("tab.dashboard.selected")
            }
            public static var unselected: Image {
                return Image("tab.dashboard.unselected")
            }
        }
       
        public struct Coaching {
            public static var selected: Image {
                return Image("tab.coaching.selected")
            }
            public static var unselected: Image {
                return Image("tab.coaching.unselected")
            }
        }
        
        public struct Settings {
            public static var selected: Image {
                return Image("tab.settings.selected")
            }
            public static var unselected: Image {
                return Image("tab.settings.unselected")
            }
        }
    }
    
    public struct Common {
        public static var dropdownArrow: Image {
            return Image("common.dropdownArrow")
        }
        public static var checkmark: Image {
            return Image("common.checkmark")
        }
        public static var back: Image {
            return Image("common.back")
        }
        public static var more: Image {
            return Image("common.more")
        }
        public static var upArrow: Image {
            return Image("common.upArrow")
        }
    }
}

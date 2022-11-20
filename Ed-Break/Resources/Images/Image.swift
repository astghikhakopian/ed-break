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
        public static var calender: Image {
            return Image("childdDetails.calender")
        }
    }
    
    public struct Parent {
        public struct Dashboard {
            public static var restrictions: Image {
                return Image("parent.dashboard.restrictions")
            }
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
        
        public struct Home {
            public static var selected: Image {
                return Image("tab.home.selected")
            }
            public static var unselected: Image {
                return Image("tab.home.unselected")
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
    
    public struct Settings {
        public static var asterisk: Image {
            return Image("settings.asterisk")
        }
        public static var star: Image {
            return Image("settings.star")
        }
        public static var more: Image {
            return Image("settings.more")
        }
        public static var delete: Image {
            return Image("settings.delete")
        }
        public static var mobile: Image {
            return Image("settings.mobile")
        }
    }
    
    public struct Common {
        public static var dropdownArrow: Image {
            return Image("common.dropdownArrow")
        }
        public static var checkmark: Image {
            return Image("common.checkmark")
        }
        public struct Answer {
            public static var failure: Image {
                return Image("answer.failure")
            }
            public static var success: Image {
                return Image("answer.success")
            }
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

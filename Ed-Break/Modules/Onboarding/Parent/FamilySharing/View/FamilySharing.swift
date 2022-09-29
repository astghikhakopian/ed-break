//
//  FamilySharing.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.09.22.
//

import SwiftUI

struct FamilySharing: View {
    var body: some View {
        MainBackground(title: "onboarding.familySharing.title", withNavbar: true) {
            VStack(spacing: 15) {
                Color.appWhite
                    .cornerRadius(12)
                    .shadow(color: .shadow, radius: 40, x: 0, y: 20)
                    .frame(height: 345)
                Color.appWhite
                    .cornerRadius(12)
                    .shadow(color: .shadow, radius: 40, x: 0, y: 20)
                    .frame(height: 108)
                Color.primary
                    .cornerRadius(12)
                    .frame(height: 54)
                Color.appWhite
                    .cornerRadius(12)
                    .frame(height: 54)
            }
        }
    }
}

struct FamilySharing_Previews: PreviewProvider {
    static var previews: some View {
        FamilySharing()
    }
}

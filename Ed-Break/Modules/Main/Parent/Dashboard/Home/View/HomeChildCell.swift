//
//  HomeChildCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 10.10.22.
//

import SwiftUI

struct HomeChildCell: View {
    
    let child: ChildModel
    
    private let imageHeight = 52.0
    private let cornerRadius = 12.0
    private let padding = 20.0
    private let spacing = 20.0
    private let progressHeight = 7.0
    private let progressCornerRadius = 4.0
    
    
    var body: some View {
        VStack(spacing: spacing) {
            childInfoView(child: child)
            Divider().foregroundColor(Color.divader)
            statistics(child: child)
            progress(green: CGFloat(child.percentageToday), orange: CGFloat(child.percentageProgress))
        }
        .padding(padding)
        .background(Color.appWhite)
        .cornerRadius(cornerRadius)
    }
}

private extension HomeChildCell {
    private func childInfoView(child: ChildModel) -> some View {
        HStack(spacing: spacing) {
            if let imageUrl = child.photoUrl {
                AsyncImageView(withURL: imageUrl.absoluteString, width: imageHeight, height: imageHeight)
                    .frame(width: imageHeight, height: imageHeight)
                    .cornerRadius(imageHeight/2)
            } else {
                Image.ChildDetails.uploadPlaceholder
                    .resizable()
                    .frame(width: imageHeight, height: imageHeight)
                    .cornerRadius(imageHeight/2)
            }
            
            VStack(alignment: .leading) {
                Text(child.name)
                    .font(.appButton)
                Text(child.lastLogin)
                    .font(.appBody)
                    .foregroundColor(.primaryDescription)
            }
            Spacer()
        }
    }
    
    private func statistics(child: ChildModel) -> some View {
        HStack {
            statisticsItem(
                title: "\(child.todayCorrectAnswers) of \(child.todayAnswers)",
                description: "main.parent.home.questions")
            Spacer()
            statisticsItem(title: "\(Int(child.percentageToday))%", description: "main.parent.home.answers")
        }
    }
    
    private func statisticsItem(title: String, description: String) -> some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(title))
                .font(.appLargeTitle)
                .foregroundColor(.link)
            Text(LocalizedStringKey(description))
                .font(.appHeadline)
                .foregroundColor(.primaryDescription)
        }
    }
    
    private func progress(green: CGFloat, orange: CGFloat, grey: CGFloat = 100) -> some View {
        ZStack(alignment: .leading) {
            GeometryReader { geo in
                Rectangle()
                    .foregroundColor(Color.divader)
                    .frame(width: geo.size.width * grey / 100)
                    .cornerRadius(progressCornerRadius)
                Rectangle()
                    .foregroundColor(Color.primaryOrange)
                    .frame(width: geo.size.width * orange / 100)
                    .cornerRadius(progressCornerRadius)
                Rectangle()
                    .foregroundColor(Color.primaryGreen)
                    .frame(width: geo.size.width * green / 100)
                    .cornerRadius(progressCornerRadius)
            }
        }
        .frame(height: progressHeight)
    }
}


struct HomeChildCell_Previews: PreviewProvider {
    static var previews: some View {
        HomeChildCell(child: ChildModel(dto: ChildDto(id: 0, name: "Emma", grade: 1, restrictionTime: nil, photo: nil, todayAnswers: nil, todayCorrectAnswers: nil, percentageToday: nil, percentageProgress: nil, lastLogin: nil, breakEndDatetime: nil, breakStartDatetime: nil, wrongAnswersTime: nil, deviceToken: nil, restrictions: nil, subjects: [])))
    }
}

//
//  CalendarView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/12/24.
//

import SwiftUI

struct CalendarView: View {
    
    @State var currentPage = 1
    @State var isEnd = false
    
    var weeks: Int
    var pages: Int
    var remainder: Int
    var onSelectDay: ((Int, String) -> Void)?
    
    var days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    
    @State var selectedDay = (1, "sunday")
    
    func calculateStartWeek() -> Int {
        return 1 + (4 * (currentPage - 1))
    }
    
    func calculateEndWeek() -> Int {
        return 4 + (4 * (currentPage - 1))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center) {
                Button("", systemImage: "chevron.left") {
                    currentPage -= 1
                    
                    if currentPage < pages {
                        isEnd = false
                    }
                    
                    selectedDay = (1, "monday")
                }
                .frame(width: 20, height: 30)
                .foregroundStyle(currentPage == 1 ? Color.ColorSystem.systemGray3 : Color.ColorSystem.primaryText)
                .buttonStyle(.plain)
                .disabled(currentPage == 1)
                
                Spacer()
                
                Text("Weeks \(calculateStartWeek()) - \(calculateEndWeek())")
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                
                Spacer()
                
                Button("", systemImage: "chevron.right") {
                    currentPage += 1
                    
                    if currentPage == pages {
                        isEnd = true
                    }
                    
                    selectedDay = (1, "sunday")
                }
                .frame(width: 20, height: 30)
                .foregroundStyle(isEnd ? Color.ColorSystem.systemGray3 : Color.ColorSystem.primaryText)
                .buttonStyle(.plain)
                .disabled(isEnd)
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            ForEach(calculateStartWeek()...calculateEndWeek(), id: \.self) { week in
                HStack(alignment: .center) {
                    Text(String(week))
                        .font(Font.FontStyles.caption1)
                        .foregroundStyle(Color.ColorSystem.systemGray6)
                    
                    ForEach(days, id: \.self) { day in
                        if (isEnd && week > weeks) {
                            Text(day.prefix(1).capitalized)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.systemGray5)
                                .background(Color.ColorSystem.systemBackground)
                        } else {
                            Text(day.prefix(1).capitalized)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                                .background(selectedDay == (week, day) ? Color.ColorSystem.systemGray3 : Color.ColorSystem.systemBackground)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedDay = (week, day)
                                    onSelectDay?(week, day)
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
    }
}

#Preview {
    CalendarView(weeks: 5, pages: 4, remainder: 3)
}

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
    
    var programId: String
    var isCreator: Bool
    var weeks: Int
    var pages: Int
    var remainder: Int
    
    var days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    
    @State var selectedDay = (1, "sunday")
    
    @State var presentNewWorkout = false
    
    func calculateStartWeek() -> Int {
        return 1 + (4 * (currentPage - 1))
    }
    
    func calculateEndWeek() -> Int {
        return 4 + (4 * (currentPage - 1))
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                // MARK: Week selector
                HStack(alignment: .center) {
                    Button {
                        currentPage -= 1
                        
                        if currentPage < pages {
                            isEnd = false
                        }
                        
                        selectedDay = (calculateStartWeek(), "sunday")
                    } label: {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "chevron.left")
                                .foregroundStyle(currentPage == 1 ? Color.ColorSystem.systemGray3 : Color.ColorSystem.primaryText)
                            
                            Spacer()
                        }
                        .frame(width: 40, height: 30)
                    }
                    .buttonStyle(.plain)
                    .disabled(currentPage == 1)
                    
                    Spacer()
                    
                    Text("Weeks \(calculateStartWeek()) - \(calculateEndWeek())")
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                    
                    Spacer()
                    
                    Button {
                        currentPage += 1
                        
                        if currentPage == pages {
                            isEnd = true
                        }
                        
                        selectedDay = (calculateStartWeek(), "sunday")
                    } label: {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(isEnd ? Color.ColorSystem.systemGray3 : Color.ColorSystem.primaryText)
                            
                            Spacer()
                        }
                        .frame(width: 40, height: 30)
                    }
                    .buttonStyle(.plain)
                    .disabled(isEnd)
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                // MARK: Calendar
                ForEach(calculateStartWeek()...calculateEndWeek(), id: \.self) { week in
                    HStack(alignment: .center) {
                        Text(String(week))
                            .frame(width: 24)
                            .font(Font.FontStyles.caption1)
                            .foregroundStyle(Color.ColorSystem.systemGray5)
                        
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
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            
            // MARK: Workouts
            Section {
                DayView(viewModel: DayViewModel(programId: programId, week: selectedDay.0, day: selectedDay.1))
            } header: {
                HStack {
                    Text("Workouts")
                        .font(Font.FontStyles.title3)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                    
                    Spacer()
                    
                    if isCreator {
                        Button {
                            presentNewWorkout.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }

                    }
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
            }
            .headerProminence(.increased)
        }
        .sheet(isPresented: $presentNewWorkout) {
            NewProgramWorkoutView(viewModel: NewProgramWorkoutViewModel(
                programId: programId,
                week: selectedDay.0,
                day: selectedDay.1
            ))
        }
    }
}

#Preview {
    CalendarView(programId: "b6619681-8e20-43f7-a67c-b6ed9750c731", isCreator: false, weeks: 5, pages: 4, remainder: 3)
}

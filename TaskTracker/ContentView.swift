//
//  ContentView.swift
//  TaskTracker
//
//  Created by Ruzemath on 4/13/24.
//

import SwiftUI
import SwiftData
import CoreLocationUI
import CoreLocation
import MapKit

struct GymAnnotation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var name: String

    init(coordinate: CLLocationCoordinate2D, name: String) {
        self.coordinate = coordinate
        self.name = name
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var path = NavigationPath()
    @StateObject var taskModel: FitnessTaskVM = FitnessTaskVM()
    @StateObject var gymModel: GymVM = GymVM()
    @ObservedObject var locationDataManager : LocationDataManager = LocationDataManager()
    @Query var profiles: [Profile]
    @State var userLat = ""
    @State var userLon = ""
    
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
                VStack {
                    Image(systemName: "dumbbell")
                    Text("Fitness Task Tracker").font(.title).bold().foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Spacer()
                    Text("Welcome To Your Very Own").font(.title).bold().frame(alignment: .center).foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Text("Fitness Tracker!").font(.title).bold().frame(alignment: .center).foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Spacer()
                    Image(systemName: "person.circle")
                    NavigationLink(destination: ProfileView(path: $path )) {
                        Text("Profile").foregroundStyle(.white).padding().background(Color.red).cornerRadius(10).font(.title3).bold()
                    }
                    Spacer()
                    Image(systemName: "figure.hiking")
                    NavigationLink(destination: TaskView(path: $path, taskModel: taskModel)) {
                        Text("Tasks").foregroundStyle(.white).padding().background(Color.green).cornerRadius(10).font(.title3).bold()
                    }
                    Spacer()
                    Image(systemName: "mappin")
                    NavigationLink(destination: MapView(path: $path, gymModel: gymModel, latUser: $userLat, lonUser: $userLon)) {
                        Text("Find Nearest Gym").foregroundStyle(.white).padding().background(Color.blue).cornerRadius(10).font(.title3).bold()
                    }
                }.padding()
            }
        }
        .onAppear {
            taskModel.modelContext = modelContext
            taskModel.fetchTasks()
            
            if profiles.isEmpty {
                modelContext.insert(Profile(name: "", username: "", age: "", pointsEarned: 0, goals: "", profileDescription: ""))
                print("Inserted")
            }
            
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                userLat = locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading"
                userLon = locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading"
                
            case .restricted, .denied:
                userLat = "Denied/Restricted"
                userLon = "Denied/Restricted"
            case .notDetermined:
                userLat = "Not Determined"
                userLon = "Not Determined"
                ProgressView()
            default:
                userLat = ""
                userLon = ""
                ProgressView()
            }
            gymModel.getJsonData(userLatitude: userLat, userLongitude: userLon)
        }
    }
}

struct ProfileView: View {
    @Binding var path: NavigationPath
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var profiles: [Profile]
    @State var profileEditable = false
    @State var strName = ""
    @State var strUsername = ""
    @State var strAge = ""
    @State var strGoals = ""
    @State var strDescription = ""
    
    var body: some View {
        ZStack {
            Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
            VStack {
                Image(systemName: "person.circle")
                Text("Profile").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                Spacer()
                if !profiles.isEmpty {
                    Text("Name: \(profiles[0].name)").bold().font(.title).frame(maxWidth: 500, alignment: .leading).foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Spacer()
                    Text("Username: \(profiles[0].username)").bold().font(.title).frame(maxWidth: 500, alignment: .leading).foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Spacer()
                    Text("Age: \(String(profiles[0].age))").bold().font(.title).frame(maxWidth: 500, alignment: .leading).foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Spacer()
                    Text("Fitness Goals: \(profiles[0].goals)").bold().font(.title).frame(maxWidth: 500, alignment: .leading).foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Spacer()
                    Text("About Me: \(profiles[0].profileDescription)").bold().font(.title).frame(maxWidth: 500, alignment: .leading).foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Spacer()
                    Text("Points Earned: \(String(profiles[0].pointsEarned))").bold().font(.title).frame(maxWidth: 500, alignment: .leading).foregroundStyle(Color(red: 169/255, green: 151/255, blue: 196/255))
                    Spacer()
                }
                Spacer()
            }.padding()
        }
        .toolbar {
            ToolbarItem {
                Button("Edit Profile") {
                    profileEditable = true
                }.foregroundStyle(.white).background(Color.red).cornerRadius(10).bold().buttonStyle(.bordered)
                .sheet(isPresented: $profileEditable) {
                    ZStack {
                        Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
                        VStack {
                            Image(systemName: "pencil")
                            Text("Edit Your Profile").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                            Spacer()
                            HStack {
                                Spacer().frame(width:25)
                                TextField("Update Name", text: $strName, onEditingChanged: { _ in
                                    if !profiles.isEmpty {
                                        profiles[0].name = strName
                                    }
                                }).font(.title).textFieldStyle(.roundedBorder)
                            }.padding()
                            
                            HStack {
                                Spacer().frame(width:25)
                                TextField("Update Username", text: $strUsername, onEditingChanged: { _ in
                                    if !profiles.isEmpty {
                                        profiles[0].username = strUsername
                                    }
                                }).font(.title).textFieldStyle(.roundedBorder)
                            }.padding()
                            
                            HStack {
                                Spacer().frame(width:25)
                                TextField("Update Age", text: $strAge, onEditingChanged: { _ in
                                    if !profiles.isEmpty {
                                        profiles[0].age = strAge
                                    }
                                }).font(.title).textFieldStyle(.roundedBorder)
                            }.padding()
                            
                            HStack {
                                Spacer().frame(width:25)
                                TextField("Update Goals", text: $strGoals, axis: .vertical)
                                    .font(.title).textFieldStyle(.roundedBorder).onChange(of: strGoals) { newValue in
                                        if !profiles.isEmpty {
                                            profiles[0].goals = newValue
                                        }
                                    }
                            }.padding()
                            
                            HStack {
                                Spacer().frame(width:25)
                                TextField("Update About Me", text: $strDescription, axis: .vertical)
                                    .font(.title).font(.title).textFieldStyle(.roundedBorder).onChange(of: strDescription) { newValue in
                                        if !profiles.isEmpty {
                                            profiles[0].profileDescription = newValue
                                        }
                                    }
                            }.padding()
                            Spacer()
                            Button("Return") {
                                profileEditable = false
                            }.foregroundStyle(.white).padding().background(Color.red).cornerRadius(10).font(.title3).bold()
                        }.padding()
                    }
                    
                }
            }
        }
    }
}

struct TaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var path: NavigationPath
    @ObservedObject var taskModel: FitnessTaskVM
    @State var addTask = false
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
                List {
                    ForEach(taskModel.tasks.filter { !$0.isCompleted }) { task in
                        NavigationLink {
                            TaskDetailView(path: $path, taskModel: taskModel, fitnessTask: task)
                        } label: {
                            HStack {
                                Text("\(task.name)").frame(alignment: .leading)
                                Spacer()
                                Text("\(task.difficulty.rawValue)").frame(alignment: .trailing).foregroundStyle(Color.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }.scrollContentBackground(.hidden)
            }
            .navigationTitle("Task Table")
            .toolbar {
                ToolbarItem {
                    Button("Add Task") {
                        addTask = true
                    }.foregroundStyle(.white).background(Color.green).cornerRadius(10).bold().buttonStyle(.bordered)
                    .sheet(isPresented: $addTask) {
                        AddTaskView(taskModel: taskModel)
                    }
                }
            }
            
            VStack {
                Image(systemName: "trophy")
                NavigationLink(destination: HistoryView(path: $path, taskModel: taskModel)) {
                    Text("Task Acheivements").foregroundStyle(.white).padding().background(Color.green).cornerRadius(10).font(.title3).bold()
                }
            }
        }.background(Color(red: 240/255, green: 217/255, blue: 215/255))
    }
    
    private func deleteTask(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                taskModel.removeTask(task: taskModel.tasks[index])
            }
        }
    }
}

struct AddTaskView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @ObservedObject var taskModel: FitnessTaskVM
    @State var name = ""
    @State var type = ""
    @State var duration = ""
    @State var difficulty: Difficulty = .easy
    @State var points = 0
    @State var isCompleted = false
    let difficulties: [Difficulty] = [.easy, .medium, .hard, .intense]
    var body: some View {
        ZStack {
            Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
            VStack {
                Image(systemName: "figure.hiking")
                Text("Add Task").font(.title).bold().frame(alignment: .center)
                Spacer()
                Form {
                    Section {
                        TextField("Task Name", text: $name)
                        TextField("Type", text: $type)
                        TextField("Duration", text: $duration)
                        Picker("Difficulty", selection: $difficulty) {
                            ForEach(difficulties, id: \.self) { difficulty in
                                Text(difficulty.rawValue)
                            }
                        }.pickerStyle(.menu)
                    }
                    Button("Create Task") {
                        let newTask = FitnessTask(id: UUID(), name: name, type: type, duration: duration, difficulty: difficulty, points: difficulty.points, isCompleted: false)
                        taskModel.addTask(task: newTask)
                        dismiss()
                    }.foregroundStyle(Color.green).cornerRadius(10).font(.title3).bold().frame(maxWidth: 500, alignment: .center)
                }.padding().cornerRadius(10).scrollContentBackground(.hidden)
                Spacer()
            }.padding()
        }
    }
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var path: NavigationPath
    @Query var profiles: [Profile]
    @ObservedObject var taskModel: FitnessTaskVM
    @State var addTask = false
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
                List {
                    ForEach(taskModel.tasks.filter { $0.isCompleted }) { task in
                        NavigationLink {
                            HistoryDetailView(path: $path, taskModel: taskModel, fitnessTask: task)
                        } label: {
                            HStack {
                                Text("\(task.name)").frame(alignment: .leading)
                                Spacer()
                                Text("\(task.difficulty.rawValue)").frame(alignment: .trailing).foregroundStyle(Color.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }.scrollContentBackground(.hidden)
            }
            .navigationTitle("Task History")
        }.background(Color(red: 240/255, green: 217/255, blue: 215/255))
    }
    
    private func deleteTask(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                profiles[0].pointsEarned -= taskModel.tasks[index].points
                taskModel.removeTask(task: taskModel.tasks[index])
            }
        }
    }
}

struct TaskDetailView : View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var profiles: [Profile]
    @Binding var path: NavigationPath
    @ObservedObject var taskModel: FitnessTaskVM
    @State var fitnessTask: FitnessTask
    var body: some View {
        ZStack {
            Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Task: \(fitnessTask.name)").bold().font(.title).frame(alignment: .leading)
                Spacer()
                Text("Duration: \(fitnessTask.duration)").bold().font(.title).frame(alignment: .leading)
                Spacer()
                Text("Difficulty: \(fitnessTask.difficulty.rawValue)").bold().font(.title).frame(alignment: .leading)
                Spacer()
                Text("Points: \(String(fitnessTask.points))").bold().font(.title).frame(alignment: .leading)
                Spacer()
                Button("Complete Task") {
                    fitnessTask.isCompleted = true
                    profiles[0].pointsEarned += fitnessTask.points
                    dismiss()
                }.foregroundStyle(.white).padding().background(Color.green).cornerRadius(10).font(.title3).bold()
            }.padding()
                .toolbar {
                    ToolbarItem {
                        Button("Delete Task") {
                            taskModel.removeTask(task: fitnessTask)
                            dismiss()
                        }.foregroundStyle(.white).background(Color.red).cornerRadius(10).bold().buttonStyle(.bordered)
                    }
                }
        }
    }
}

struct HistoryDetailView : View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var profiles: [Profile]
    @Binding var path: NavigationPath
    @ObservedObject var taskModel: FitnessTaskVM
    @State var fitnessTask: FitnessTask
    var body: some View {
        ZStack {
            Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Task: \(fitnessTask.name)").bold().font(.title).frame(alignment: .leading)
                Spacer()
                Text("Duration: \(fitnessTask.duration)").bold().font(.title).frame(alignment: .leading)
                Spacer()
                Text("Difficulty: \(fitnessTask.difficulty.rawValue)").bold().font(.title).frame(alignment: .leading)
                Spacer()
                Text("Points: \(String(fitnessTask.points))").bold().font(.title).frame(alignment: .leading)
                Spacer()
            }.padding()
        }
    }
}

struct MapView: View {
    @Binding var path: NavigationPath
    @ObservedObject var gymModel: GymVM
    @Binding var latUser: String
    @Binding var lonUser: String
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(),
            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        )
    @State private var annotations: [GymAnnotation] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(red: 240/255, green: 217/255, blue: 215/255).ignoresSafeArea()
                VStack {
                    Text("Nearby Gyms").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                    Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: annotations) { annotation in MapMarker(coordinate: annotation.coordinate)
                    }.padding()
                }
            }
        } .onAppear {
            getNearbyGyms()
        }
    }
    
    private func getNearbyGyms() {
        if let latitude = Double(latUser), let longitude = Double(lonUser) {
            region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

        for gym in gymModel.gyms {
            let annotation = GymAnnotation(coordinate: CLLocationCoordinate2D(latitude: gym.geometry.location.lat, longitude: gym.geometry.location.lng), name: gym.name)
            annotations.append(annotation)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Profile.self, FitnessTask.self], inMemory: true)
}

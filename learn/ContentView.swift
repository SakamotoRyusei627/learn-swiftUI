//
//  ContentView.swift
//  learn
//
//  Created by 坂本龍征 on 2025/08/31.
//

import SwiftUI

struct ContentView: View {
    @State private var todos = ["牛乳を買う","コードを書く","散歩する"]
    @State private var newTodo = ""
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("新しいTodoを入力する", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("追加"){
                        if !newTodo.isEmpty{
                            todos.append(newTodo)
                            newTodo = ""
                        }
                    }
                    .padding(.trailing)
                }
                List {
                    ForEach(todos,id:\.self){ todo in
                        NavigationLink(value: todo){
                            Text(todo)
                        }
                    }
                }
                .navigationDestination(for: String.self){todo in TodoDetailView(todo: todo)
                }
                .navigationTitle("Todoリスト")
            }
        }
    }
}

struct TodoDetailView: View {
    let todo: String
    
    var body: some View {
        VStack(spacing: 20){
            Text("Todoの詳細")
                .font(.headline)
            Text(todo)
                .font(.largeTitle)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

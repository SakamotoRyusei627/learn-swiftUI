//
//  ContentView.swift
//  learn
//
//  Created by 坂本龍征 on 2025/08/31.
//

import SwiftUI

struct Todo: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isDone: Bool = false
}

class TodoStore: ObservableObject {
    @Published var todos: [Todo] = [] {
        didSet {
            save()
        }
    }
    private let key = "todos_key"
    
    init() {
        load()
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Todo].self, from: data) {
            self.todos = decoded
        }
        
    }
}

struct ContentView: View {
    @StateObject private var store = TodoStore()
    @State private var newTodo = ""
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("新しいTodoを入力する", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("追加") {
                        guard !newTodo.isEmpty else { return }
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            store.todos.append(Todo(title: newTodo))
                                                        newTodo = ""
                        }
                    }
                    .padding(.trailing)
                }
                List {
                    ForEach($store.todos) { $todo in
                        NavigationLink(value: todo) { TodoRow(todo: $todo) }
                    }
                    .onDelete { indexSet in
                        withAnimation { store.todos.remove(atOffsets: indexSet) }
                    }
                    .onMove { from, to in
                        withAnimation { store.todos.move(fromOffsets: from, toOffset: to) }
                    }
                }
                .toolbar {
                    EditButton()
                }
                .navigationDestination(for: Todo.self) { todo in
                                    TodoDetailView(todo: todo)
                }
                .navigationTitle("Todoリスト")
            }
        }
    }
}


struct TodoRow: View {
    @Binding var todo: Todo

    var body: some View {
        HStack {
            Toggle(isOn: $todo.isDone) {
                Text(todo.title)
                    .strikethrough(todo.isDone)
                    .foregroundStyle(todo.isDone ? .secondary : .primary)
                    .animation(.easeInOut(duration: 0.2), value: todo.isDone)
            }
            .toggleStyle(.switch)
        }
        .contentShape(Rectangle()) // 行全体をタップ領域に
    }
}

struct TodoDetailView: View {
    let todo: Todo
    var body: some View {
        VStack(spacing: 20) {
            Text("Todoの詳細")
                .font(.headline)
            Text(todo.title)
                .font(.largeTitle)
            Text(todo.isDone ? "✅ 完了済み" : "⏳ 未完了")
                .font(.title2)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

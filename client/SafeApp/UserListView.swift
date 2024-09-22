import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserViewModel
    @State private var searchText = ""

    init(token: String) {
        _viewModel = StateObject(wrappedValue: UserViewModel(token: token))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Ô tìm kiếm
                SearchBar(text: $searchText)
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List {
                        ForEach(filteredUsers) { user in
                            UserRow(user: user)
                        }
                        .onDelete(perform: deleteUser)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                viewModel.fetchAllUsers()
            }) {
                Image(systemName: "arrow.clockwise")
            })
            .onAppear {
                viewModel.fetchAllUsers()
            }
        }
    }
    
    // Lọc danh sách người dùng dựa trên từ khóa tìm kiếm
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewModel.users
        } else {
            return viewModel.users.filter { user in
                user.email.localizedCaseInsensitiveContains(searchText) ||
                user.role.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func deleteUser(at offsets: IndexSet) {
        offsets.forEach { index in
            let user = viewModel.users[index]
            viewModel.deleteUser(user)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal)
        }
    }
}

struct UserRow: View {
    let user: User

    var body: some View {
        HStack {
            if let avatarUrl = user.avatar, let url = URL(string: avatarUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading) {
                Text(user.email)
                    .font(.headline)
                Text(user.role)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmViZThhOTQ2NTYwZmFmM2EzM2ViNmIiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY3MzY1NTMsImV4cCI6MTcyNjgyMjk1M30.QK9cdG3s3mADdCctxiPgxRPv8mZJSD50w2orlAaSgco")
    }
}

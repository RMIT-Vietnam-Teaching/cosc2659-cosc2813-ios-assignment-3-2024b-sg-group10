import SwiftUI
import MapKit

struct SearchView: View {
    @Binding var searchText: String
    @State private var searchResults: [MKMapItem] = [] // Stores search results
    @State private var isSearching = false // Controls the search process
    @State private var debounceWorkItem: DispatchWorkItem? // For debouncing
    @State private var showSuggestions = false // Controls the visibility of suggested locations
    
    // A closure to notify the MapView about location selection
    var onLocationSelected: ((CLLocationCoordinate2D) -> Void)? = nil
    
    var body: some View {
        VStack {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchText, onCommit: {
                    // Perform search when Enter is pressed
                    if let firstResult = searchResults.first {
                        selectLocation(firstResult)
                    }
                })
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .disableAutocorrection(true)
                .onChange(of: searchText) { newValue in
                    debounceSearch(query: newValue) // Trigger debounce function
                    showSuggestions = !newValue.isEmpty
                }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        searchResults = [] // Clear search results when text is cleared
                        showSuggestions = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
            .shadow(radius: 4)
            
            // Suggested Locations appear just below the search bar
            if showSuggestions {
                List(searchResults, id: \.self) { item in
                    VStack(alignment: .leading) {
                        Text(item.name ?? "Unknown")
                            .font(.headline)
                        Text(item.placemark.title ?? "No Address")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        // Select location and dismiss suggestions
                        selectLocation(item)
                        showSuggestions = false
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: 300) // Limit the height of the suggestions list
            }
            
            // Spacer to push the recent locations down
            Spacer()
            
            // Recent Locations and More Options
            List {
                Section(header: Text("Recent").font(.headline)) {
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                        VStack(alignment: .leading) {
                            Text("Home")
                                .font(.headline)
                            Text("ABC Street, XYZ City")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            print("Options tapped for Home")
                        }) {
                            Text("Options")
                        }
                        .tint(Color.blue)
                    }
                    
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                        VStack(alignment: .leading) {
                            Text("Location A")
                                .font(.headline)
                            Text("ABC Street, XYZ City")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            print("Options tapped for Location A")
                        }) {
                            Text("Options")
                        }
                        .tint(Color.blue)
                    }
                }
                
                Section(header: Text("More options").font(.headline)) {
                    HStack {
                        Image(systemName: "briefcase.fill")
                            .foregroundColor(.black)
                        VStack(alignment: .leading) {
                            Text("Work")
                                .font(.headline)
                            Text("ABC Street, XYZ City")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            print("Options tapped for Work")
                        }) {
                            Text("Options")
                        }
                        .tint(Color.blue)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(Color.white) // Ensure background color is consistent
        .animation(.easeInOut)
    }
    
    // Debounce the search query input
    func debounceSearch(query: String) {
        // Cancel any existing work item to avoid unnecessary searches
        debounceWorkItem?.cancel()
        
        // Create a new work item with a delay of 0.5 seconds
        let newWorkItem = DispatchWorkItem {
            performSearch(query: query)
        }
        
        // Store the new work item and execute it after the delay
        debounceWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: newWorkItem)
    }
    
    // Perform search using MKLocalSearch
    func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = [] // Clear results if query is empty
            return
        }
        
        isSearching = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            isSearching = false
            if let response = response {
                self.searchResults = response.mapItems
            } else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // Function to handle selecting a location
    func selectLocation(_ item: MKMapItem) {
        searchText = item.name ?? "Unknown"
        searchResults = [] // Optionally clear the search results
        if let location = item.placemark.location?.coordinate {
            // Notify the parent view (MapView) about the selected location
            onLocationSelected?(location)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}

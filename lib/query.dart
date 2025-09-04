String restaurantSummariesQuery({int limit = 1, int offset = 0}) => '''
  query getRestaurantSummaries {
    search(location: "Las Vegas", limit: $limit, offset: $offset) {
      business {
        id
        name
        price
        rating
        photos
        categories {
          title
          alias
        }
        hours {
          is_open_now
        }
      }
    }
  }
  ''';

String restaurantSummariesWithIdsQuery(List<String> ids) => '''
  query getRestaurantSummariesWithIds {
    ${ids.asMap().entries.map((entry) => '''
    business${entry.key}: business(id: "${entry.value}") {
      id
      name
      price
      rating
      photos
      categories {
        title
        alias
      }
      hours {
        is_open_now
      }
    }
    ''',).join('\n')},
  }
  ''';

String restaurantDetailQuery(String id) => '''
  query getRestaurantDetail {
    business(id: "$id") {
      id
      name
      price
      rating
      photos
      reviews {
        id
        rating
        text
        user {
          id
          image_url
          name
        }
      }
      categories {
        title
        alias
      }
      hours {
        is_open_now
      }
      location {
        formatted_address
      }
    }
  }
  ''';

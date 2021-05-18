import gql from 'graphql-tag'

export const CATEGORIES_QUERY = gql`
  query Categories {
    categories(first: 100, level: 0) {
      edges {
        node {
          id
          name
          slug
        }
      }
    }
  }
`

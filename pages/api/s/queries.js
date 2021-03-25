import gql from 'graphql-tag'

export default gql`
  query Category($slug: String!) {
    category(slug: $slug) {
      id
      name
      products(first: 100) {
        edges {
          node {
            id
            slug
            name
            thumbnail {
              url
              alt
            }
            slug
            defaultVariant {
              id
              name
              sku
              pricing {
                price {
                  net {
                    currency
                    amount
                  }
                }
                discount {
                  net {
                    currency
                    amount
                  }
                }
              }
            }
            images {
              id
              url
              alt
            }
          }
        }
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }
  }
`

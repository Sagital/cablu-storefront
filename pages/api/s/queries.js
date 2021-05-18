import gql from 'graphql-tag'

export default gql`
  query Category($slug: String!) {
    category(slug: $slug) {
      id
      name
      slug
      products(channel: "default-channel", first: 100) {
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
              quantityAvailable
              pricing {
                price {
                  net {
                    currency
                    amount
                  }
                  gross {
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
